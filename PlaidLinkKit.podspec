Pod::Spec.new do |s|
  s.name = "PlaidLinkKit"
  s.version = "0.0.1"
  s.summary = "A quick and secure way to integrate with the Plaid API."

  s.description = <<-DESC
    A quick and secure way to integrate with the Plaid API. Enjoy!
  DESC

  s.author = 'Plaid Technologies, Inc.'
  s.homepage = "https://github.com/plaid/link"
  s.license = "MIT"

  s.platform     = :ios

  s.source = { git: "https://github.com/plaid/link.git" }
  s.vendored_frameworks = "ios/LinkKit.framework"
end
