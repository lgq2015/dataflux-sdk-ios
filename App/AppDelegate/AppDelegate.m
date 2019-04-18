//
//  AppDelegate.m
//  App
//
//  Created by 胡蕾蕾 on 2018/10/22.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "AppDelegate.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "MainTabBarController.h"
#import "PWSocketManager.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) MainTabBarController *mainTB;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initService];
    [self initWindow];
//    [self initUserManager];
//    [self initZhuge];
//    [self initUMeng];
    [self initSVProgressHUD];
    [self configLog];
    [self configUSharePlatforms];
    //网络监听
    [self monitorNetworkStatus];
    // Override point for customization after application launch.
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_ID
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    if( [getUserNotificationSettings isEqualToString:PWRegister]){
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            NSLog(@"Requesting permission for push notifications..."); // iOS 8
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound categories:nil];
            [UIApplication.sharedApplication registerUserNotificationSettings:settings];
        } else {
            NSLog(@"Registering device for push notifications..."); // iOS 7 and earlier
            [UIApplication.sharedApplication registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeSound];
        }
    }

#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    if ([[UIDevice currentDevice] systemVersion].floatValue > 9.999) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];

    } else {
        UIUserNotificationType types = UIUserNotificationTypeBadge |
                UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings =
                [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

#endif

//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    return YES;
}

- (void)networkDidReceiveMessage:(NSDictionary *)userInfo {
    setRemoteNotificationData(userInfo);
    [kUserDefaults synchronize];

}


- (void)applicationWillResignActive:(UIApplication *)application {
   
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
   
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //修改 badge 数量
    UIBackgroundTaskIdentifier taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:taskID];
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [[UIApplication sharedApplication] endBackgroundTask:taskID];
        });
    });

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [kUserDefaults synchronize];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService resetBadge];
    KPostNotification(KNotificationAppResignActive, nil);
    [[PWSocketManager sharedPWSocketManager] checkForRestart];
    [getUserNotificationSettings isEqualToString:PWRegister]? [application registerForRemoteNotifications]:nil;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [kUserDefaults synchronize];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [getUserNotificationSettings isEqualToString:PWRegister]? [application registerForRemoteNotifications]:nil;
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}
// ios 7.0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{

 
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
      [self dealWithNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DDLogDebug(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark ========== JPUSHRegisterDelegate ========== // 2.1.9 版新增JPUSHRegisterDelegate,需实现以下两个方法
//后台得到的的通知对象(当用户点击通知栏的时候) ios 10.0以上
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler API_AVAILABLE(ios(10.0)){

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];

        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            //程序运行时收到通知，先弹出消息框 一般是前台收到消息 设置的alert
        }else{
       
              [self dealWithNotification:userInfo];
        }
    }
    else {
        // 本地通知
     //   [self networkDidReceiveMessage:userInfo];

    }
    completionHandler();  // 系统要求执行这个方法


}
// 前台通知  需求：不对前台通知进行处理
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){

//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    else {
//        // 本地通知
//     //   [self networkDidReceiveMessage:userInfo];
//
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置

}
#pragma mark ========== ios12 以上 ==========
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification  API_AVAILABLE(ios(10.0)){

    if (notification) {
        //从通知界面直接进入应用
        
    }else{
        //从通知设置界面进入应用
        
    }


}


@end
