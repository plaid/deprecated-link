package main

import (
	"encoding/json"
	"fmt"
	fretchet "github.com/artpar/frechet/frechet"
	"github.com/boltdb/bolt"
	"github.com/mdlayher/waveform"
	"io/ioutil"
	"log"
	"math"
	"path"
)

var SAMPLE_LIMIT int = 50

type SignalJsonHolder struct {
	Signal []float64 `json:"signal"`
}

func storeAllSignals(dir string) {
	files, err := ioutil.ReadDir(dir)
	if err != nil {
		fmt.Println(err.Error())
	}

	db, err := bolt.Open("my.db", 0600, nil)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	err = db.Update(func(tx *bolt.Tx) error {
		err = tx.DeleteBucket([]byte("SongSignals"))
		_, err = tx.CreateBucket([]byte("SongSignals"))
		if err != nil {
			return fmt.Errorf("create bucket: %s", err)
		}
		return nil
	})

	for _, file := range files {
		signal, _ := waveform.SignalFromFile(path.Join(dir, file.Name()))
		if len(signal) < SAMPLE_LIMIT {
			continue
		}
		signal = normalizedFloats(signal[0:SAMPLE_LIMIT])

		signalHolder := SignalJsonHolder{
			Signal: signal,
		}

		outputSignal, err := json.Marshal(signalHolder)
		if err != nil {
			fmt.Println(err.Error())
			return
		}

		db.Update(func(tx *bolt.Tx) error {
			b := tx.Bucket([]byte("SongSignals"))
			err := b.Put([]byte(file.Name()), outputSignal)
			return err
		})

		var signalJsonHolder SignalJsonHolder
		json.Unmarshal(outputSignal, &signalJsonHolder)
		fmt.Printf("Stored Song = %s\n", file.Name())
		fmt.Printf("Stored Signal = %v\n\n", signalJsonHolder.Signal)
	}
}

func listAllSignals() {
	db, err := bolt.Open("my.db", 0600, nil)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	amount := 0
	db.View(func(tx *bolt.Tx) error {
		// Assume bucket exists and has keys
		b := tx.Bucket([]byte("SongSignals"))
		b.ForEach(func(k, v []byte) error {
			fmt.Printf("Stored Song = %s\n", k)
			fmt.Printf("Stored Signal = %v\n", v)
			amount += 1
			return nil
		})
		return nil
	})
	fmt.Printf("Signal Count = %v\n", amount)
}

func findMostSimilar(a []float64) (string, [][]float64, [][]float64) {
  var originalSignal [][]float64
  var similarSignal [][]float64
	var similarName string
	similarDistance := float64(math.MaxUint32)

	db, err := bolt.Open("my.db", 0600, nil)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	db.View(func(tx *bolt.Tx) error {
		// Assume bucket exists and has keys
		b := tx.Bucket([]byte("SongSignals"))
		b.ForEach(func(k, v []byte) error {
			//fmt.Println(string(k))
			var signalJsonHolder SignalJsonHolder
			json.Unmarshal(v, &signalJsonHolder)

			tempA := numberedFloats(normalizedFloats(a))

			var tempB [][]float64
			if len(tempA) < len(signalJsonHolder.Signal) {
				bValues := signalJsonHolder.Signal[0:len(tempA)]
				normalizedBValues := normalizedFloats(bValues)
				tempB = numberedFloats(normalizedBValues)
			} else {
				tempB = numberedFloats(signalJsonHolder.Signal)
			}

			distance := compareSignal(tempA, tempB)
			if distance <= similarDistance {
				similarDistance = distance
				similarName = string(k)
        originalSignal = tempA
        similarSignal = tempB
			}
			return nil
		})
		return nil
	})
	return similarName, originalSignal, similarSignal
}

func compareSignal(a [][]float64, b [][]float64) float64 {
	var frechet fretchet.FrechetDistance
	var dist float64

	// two curves in 2D
	// 1.1-approximation of Euclidean (in 2 dimensions) (NB: any value above sqrt(2) uses sqrt(2) as approximation value)
	frechet = fretchet.NewPolyhedralFretchetDistance(fretchet.EpsApproximation2D(1.5))
	dist = frechet.ComputeDistance(a, b)
	//fmt.Printf("Distance 3 : %f\n\n\n\n\n", dist)
	return dist

	/*
	  // L-infinity in 4 dimensions
	  frechet = fretchet.NewPolyhedralFretchetDistance(fretchet.LInfinity(2));
	  dist = frechet.ComputeDistance(a, b);
	  fmt.Printf("Distance 2 : %f\n\n\n\n\n", dist)
	  return dist

		// L-1 in 3 dimensions
		frechet = fretchet.NewPolyhedralFretchetDistance(fretchet.L1(2))
		dist = frechet.ComputeDistance(a, b)
		fmt.Printf("Distance 1 : %f\n\n\n\n\n", dist)
		return dist
		// two curves in 4D

	  // 6-regular polygon (in 2 dimensions)
	  // implementation supports only symmetric polyhedra, so parameter must be even!
	  frechet = fretchet.NewPolyhedralFretchetDistance(fretchet.KRegular2D(8));
	  dist = frechet.ComputeDistance(a, b);
	  fmt.Printf("Distance 4 : %f\n", dist)
	  return dist
	*/
}

func numberedFloats(floatArray []float64) [][]float64 {
	var numberedResult [][]float64
	for i := 0; i < len(floatArray); i++ {
		numberedFloat := []float64{float64(i), float64(floatArray[i])}
		numberedResult = append(numberedResult, numberedFloat)
	}
	return numberedResult
}

func normalizedFloats(floatArray []float64) []float64 {
	maxAmount := float64(math.MaxUint32) * -1
	minAmount := float64(math.MaxUint32)

	for i := 0; i < len(floatArray); i++ {
		if floatArray[i] > maxAmount {
			maxAmount = floatArray[i]
		}
		if floatArray[i] < minAmount {
			minAmount = floatArray[i]
		}
	}

	var normalizedArray []float64
	for i := 0; i < len(floatArray); i++ {
		normalFloat := float64(floatArray[i]-minAmount) / float64(maxAmount-minAmount)
		normalizedArray = append(normalizedArray, normalFloat)
	}

	return normalizedArray
}

func scaleDiscreteX(coordArray [][]float64, maxX float64) [][]float64 {
	var scaledArray [][]float64
	scalingFactor := float64(maxX) / float64(len(coordArray)-1)
	for i := 0; i < len(coordArray); i++ {
		scaledCoord := []float64{float64(int(coordArray[i][0] * scalingFactor)), float64(coordArray[i][1])}
		scaledArray = append(scaledArray, scaledCoord)
	}
	return scaledArray
}
