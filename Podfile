# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'App' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
 
  # Pods for App
  pod 'SDWebImage', '~>3.8'
  pod 'AFNetworking', '~> 4.0'
  pod 'JSONModel', '~> 1.8.0'
  pod 'Masonry', '~> 1.1.0'
  pod 'ReactiveCocoa' , '2.0'
  pod 'MJRefresh', '~> 3.1.15.7'
  pod 'YYKit','~> 1.0.9'
  pod 'FMDB','~> 2.7.5'
  pod 'Zhugeio','~> 3.2.3'
  pod 'TTTAttributedLabel','~> 2.0.0'
  pod 'IQKeyboardManager','~> 6.2.0'
  pod 'JPush', '~>3.3.2'
  pod 'LBXScan/UI','~> 2.3'
  pod 'LBXScan/LBXNative','~> 2.3'
  pod 'Socket.IO-Client-Swift', '~> 14.0.0'
  pod 'RegexKitLite', '~> 4.0'
  pod 'NullSafe', '~> 2.0'
  #分享
  pod 'WechatOpenSDK', '~> 1.8.6'
  pod 'MCDingTalk', '~> 1.0.1'
  pod 'NBULog', '~> 2.0.0'
  pod 'NBULog/Console' , '~> 2.0.0'
end

target 'AppDev' do
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    # use_frameworks!
    
    # Pods for App
    pod 'SDWebImage', '~>3.8'
    pod 'AFNetworking', '~> 4.0'
    pod 'JSONModel', '~> 1.8.0'
    pod 'Masonry', '~> 1.1.0'
    pod 'ReactiveCocoa' , '2.0'
    pod 'MJRefresh', '~> 3.1.15.7'
    pod 'YYKit','~> 1.0.9'
    pod 'FMDB','~> 2.7.5'
    pod 'Zhugeio','~> 3.2.3'
    pod 'TTTAttributedLabel','~> 2.0.0'
    pod 'IQKeyboardManager','~> 6.2.0'
    pod 'JPush', '~>3.3.2'
    pod 'LBXScan/UI','~> 2.3'
    pod 'LBXScan/LBXNative','~> 2.3'
    pod 'Socket.IO-Client-Swift', '~> 14.0.0'
    pod 'RegexKitLite', '~> 4.0'
    pod 'NullSafe', '~> 2.0'
    #分享
    pod 'WechatOpenSDK', '~> 1.8.6'
    pod 'MCDingTalk', '~> 1.0.1'
    pod 'NBULog', '~> 2.0.0'
    pod 'NBULog/Console' , '~> 2.0.0'
    pod 'FTMobileSDK', '~>1.0.2-alpha.22'
    post_install do |installer_representation|
            installer_representation.pods_project.targets.each do |target|
                if target.name == 'FTMobileSDK'
                    target.build_configurations.each do |config|
                            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','FT_TRACK_GPUUSAGE=0']
#                            puts "===================>target build configure #{config.build_settings}"
                    end
                end
            end
        end
end

target 'AppPreMade' do
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    # use_frameworks!
    
    # Pods for App
    pod 'SDWebImage', '~>3.8'
    pod 'AFNetworking', '~> 4.0'
    pod 'JSONModel', '~> 1.8.0'
    pod 'Masonry', '~> 1.1.0'
    pod 'ReactiveCocoa' , '2.0'
    pod 'MJRefresh', '~> 3.1.15.7'
    pod 'YYKit','~> 1.0.9'
    pod 'FMDB','~> 2.7.5'
    pod 'FMDB','~> 2.7.5'
    pod 'Zhugeio','~> 3.2.3'
    pod 'TTTAttributedLabel','~> 2.0.0'
    pod 'IQKeyboardManager','~> 6.2.0'
    pod 'JPush', '~>3.3.2'
    pod 'LBXScan/UI','~> 2.3'
    pod 'LBXScan/LBXNative','~> 2.3'
    pod 'Socket.IO-Client-Swift', '~> 14.0.0'
    pod 'RegexKitLite', '~> 4.0'
    pod 'NullSafe', '~> 2.0'
    #分享
    pod 'WechatOpenSDK', '~> 1.8.6'
    pod 'MCDingTalk', '~> 1.0.1'
    pod 'NBULog', '~> 2.0.0'
    pod 'NBULog/Console' , '~> 2.0.0'
end



