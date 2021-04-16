#
# Be sure to run `pod lib lint PoporDomain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  
  s.name             = 'PoporDomain'
  s.version          = '1.0'
  s.summary          = '简易的域名配置工具,方便开发测试.'
  
  s.homepage         = 'https://gitee.com/popor/PoporDomain'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'popor' => '908891024@qq.com' }
  s.source           = { :git => 'https://gitee.com/popor/PoporDomain.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  
  s.source_files = 'PoporDomain/Classes/*.{h,m}'
  
  s.dependency 'JSONModel'
  
end
