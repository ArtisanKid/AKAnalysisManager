#
# Be sure to run `pod lib lint AKAnalysisManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AKAnalysisManager'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AKAnalysisManager.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Freud/AKAnalysisManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Freud' => 'lixiangyujiayou@gmail.com' }
  s.source           = { :git => 'https://github.com/Freud/AKAnalysisManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AKAnalysisManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AKAnalysisManager' => ['AKAnalysisManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'AdSupport', 'CoreTelephony', 'CoreMotion', 'Security', 'SystemConfiguration'
  s.libraries = 'z'

  s.dependency 'TalkingData-AppAnalytics'

  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-l"TalkingData" -ObjC',
    'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/TalkingData-AppAnalytics/**'
  }
end
