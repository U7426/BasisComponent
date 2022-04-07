#
# Be sure to run `pod lib lint BasisComponent.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BasisComponent'
  s.version          = '0.2.7'
  s.summary          = '冯龙飞基础库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/U7426/BasisComponent'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'U7426' => 'u7426fenglongfei@163.com' }
  s.source           = { :git => 'https://github.com/U7426/BasisComponent.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files =
  'BasisComponent/Classes/Net/*',
  'BasisComponent/Classes/Extension/*',
  'BasisComponent/Classes/Public/*',
  'BasisComponent/Classes/Mediator/*'
  
  # s.resource_bundles = {
  #   'BasisComponent' => ['BasisComponent/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'RxSwift'
   s.dependency 'RxCocoa'
   s.dependency 'Alamofire'
   s.dependency 'HandyJSON'
   s.dependency 'SwifterSwift'
   s.dependency 'SnapKit'
   s.dependency 'MJRefresh'
   s.dependency 'Kingfisher'
   s.dependency 'FDFullscreenPopGesture'
   s.dependency 'MBProgressHUD'
end
