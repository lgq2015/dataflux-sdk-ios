//
//  AppDelegate.h
//  App
//
//  Created by 胡蕾蕾 on 2018/10/22.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "Reachability.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainTabBarController *mainTabBar;
@property (strong, nonatomic) Reachability *conn;
@property (nonatomic, strong)TencentOAuth *tencentOAuth;


@end

