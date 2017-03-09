#!/bin/sh
#
#  prepare_for_distribution.sh - prepare a framework for distribution
#  LinkKit
#
#  Copyright © 2016 Plaid Technologies, Inc. All rights reserved.

# Remove unneeded architectures (mostly the iOS Simulator ones i386 and x86_64)
fmwk_dir=$(dirname "${0}")
dylib="${fmwk_dir}/$(basename -s.framework "${fmwk_dir}")"
if [ ! -e "${dylib}" ]; then
  echo "${dylib}: No such file or directory"
  exit 1
fi
fmwk_archs=$(lipo -info "${dylib}" | cut -d: -f3)
dup_archs=$(echo "${fmwk_archs} ${ARCHS}" | tr ' ' '\n' | sort | uniq -u)
printf "Stripping symbols: "
for arch in ${dup_archs}; do
  printf "${arch} "
  lipo "${dylib}" \
    -remove ${arch} \
    -output "${dylib}" \
  # lipo
done
echo

# Remove this script from the final distribution
rm "${0}"
