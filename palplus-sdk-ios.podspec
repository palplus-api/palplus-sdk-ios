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
  s.version          = "0.1.0"
  s.summary          = "TODO A short description of PalplusSDK."
  s.description      = <<-DESC
                       TODO An optional longer description of PalplusSDK

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/palplus-api/palplus-sdk-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'Apache 2'
  s.author           = { "palplus-api" => "support@palplus.me" }
  s.source           = { :git => "https://github.com/palplus-api/palplus-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'palplus-sdk-ios' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
