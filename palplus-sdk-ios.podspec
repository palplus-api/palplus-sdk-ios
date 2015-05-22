#
# Be sure to run `pod lib lint PalplusSDK.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "palplus-sdk-ios"
  s.version          = "0.1.3"
  s.summary          = "Pal+ iOS SDK"
  s.description      = <<-DESC
                       Pal+ iOS SDK enables 3rd party apps to browse a board and post an article to Pal+
                       DESC
  s.homepage         = "https://github.com/palplus-api/palplus-sdk-ios"
  s.license          = 'Apache 2'
  s.author           = { "palplus-api" => "support@palplus.me" }
  s.source           = { :git => "https://github.com/palplus-api/palplus-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'palplus-sdk-ios' => ['Pod/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
