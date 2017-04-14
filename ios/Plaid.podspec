Pod::Spec.new do |s|
  s.name                           = 'Plaid'
  s.version                        = '1.0.4'
  s.summary                        = 'The official Plaid Link SDK for iOS'
  s.license                        = { type: 'MIT', file: 'ios/LICENSE' }
  s.homepage                       = 'https://plaid.com/docs/api/#ios-bindings'
  s.author                         = 'Plaid Technologies, Inc.'
  s.platform                       = :ios, '8.0'
  s.source                         = { :git => 'https://github.com/plaid/link.git', :tag => 'master' }
  s.frameworks                     = 'Foundation', 'UIKit', 'WebKit', 'SafariServices'
  s.vendored_frameworks            = 'ios/LinkKit.framework'
end
