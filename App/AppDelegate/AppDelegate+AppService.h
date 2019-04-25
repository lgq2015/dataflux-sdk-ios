//
//  AppDelegate+AppService.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "AppDelegate.h"

#define ReplaceRootViewController(vc) [[AppDelegate shareAppDelegate] replaceRootViewController:vc]
/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)
//初始化服务
-(void)initService;

- (void)initSVProgressHUD;

//初始化 window
-(void)initWindow;
-(void)configUSharePlatforms;
//初始化 UMeng
-(void)initUMeng;
//初始化 zhuge
-(void)initZhuge;
//初始化用户系统
-(void)initUserManager;

//监听网络状态
- (void)monitorNetworkStatus;

//初始化网络配置
-(void)NetWorkConfig;

//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
-(UIViewController*)getCurrentVC;

-(UIViewController*) getCurrentUIVC;
-(UIView *)getCurrentView;
- (void)DetectNewVersion;
- (void)configLog;

//是否显示控制器名称在当前界面上
- (void)isShowVCName:(BOOL)isShow;
//处理推送
- (void)dealWithNotification:(NSDictionary *)userInfo;
@end
