Pod::Spec.new do |s|
  s.name              = 'Plaid'
  s.module_name       = 'LinkKit'
  s.version           = '1.0.7'

  s.summary           = 'The official Plaid Link SDK for iOS.'

  s.description       = <<-DESC
                        Plaid Link is a quick and secure way to integrate with
                        the Plaid API. LinkKit is an embeddable framework
                        that handles credential validation, multi-factor
                        authentication, and error handling for each institution
                        that Plaid supports — all while keeping credentials from
                        ever hitting your infrastructure.
                        DESC
  s.screenshot        = 'https://raw.githubusercontent.com/plaid/link/master/ios/docs/images/link-ios-citi.jpg'

  s.homepage          = 'https://plaid.com/docs/api/#ios-bindings'
  s.license           = { :type => 'MIT', :file => 'ios/LICENSE' }
  s.author            = 'Plaid Technologies, Inc.'

  s.platform          = :ios, '8.0'
  s.source            = { :git => 'https://github.com/plaid/link.git', :tag => "ios/#{s.version}" }

  s.ios.frameworks    = 'Foundation', 'UIKit', 'WebKit', 'SafariServices'
  s.ios.vendored_frameworks = 'ios/LinkKit.framework'
end
