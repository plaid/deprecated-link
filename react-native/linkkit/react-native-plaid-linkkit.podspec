
Pod::Spec.new do |s|
  s.name         = "react-native-plaid-linkkit"
  s.version      = "0.1.0"
  s.summary      = "RNLinkkit"
  s.description  = <<-DESC
                  RNLinkkit
                   DESC
  s.homepage     = "https://github.com/alkafinance/plaid-link/tree/master/react-native"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNLinkkit.git", :tag => "master" }
  s.source_files  = "ios/RNLinkkit.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "Plaid"
  #s.dependency "others"

end

  