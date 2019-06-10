
Pod::Spec.new do |s|
  s.name         = "RNLinkkit"
  s.version      = "1.0.0"
  s.summary      = "RNLinkkit"
  s.description  = <<-DESC
                  RNLinkkit
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNLinkkit.git", :tag => "master" }
  s.source_files  = "RNLinkkit/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "Plaid"
  #s.dependency "others"

end

  