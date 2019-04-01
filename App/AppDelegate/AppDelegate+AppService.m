//
//  AppDelegate+AppService.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "RootNavigationController.h"
#import "LoginPasswordVC.h"
#import "VerifyCodeLoginVC.h"
#import "UserManager.h"
#import "AppManager.h"
#import "IssueListManger.h"
#import <Zhuge.h>
#import "PWSocketManager.h"
#import "GuideVC.h"
#import "LaunchVC.h"
#import "DetectionVersionAlert.h"
@implementation AppDelegate (AppService)
#pragma mark ========== 初始化服务 ==========
-(void)initService{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];
    
    //网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
}

-(void)initSVProgressHUD{
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"pw_toast_hub_ic_success"]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"pw_toast_hub_ic_fail"]];
    [SVProgressHUD setMinimumSize:CGSizeMake(110,110)];
    [SVProgressHUD setImageViewSize:CGSizeMake(40,40)];
    [SVProgressHUD setFont:RegularFONT(15)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

}

#pragma mark ========== 初始化window ==========
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = PWWhiteColor;
    //Launch 页面显示
    self.window.rootViewController = [LaunchVC new];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"]) {
            // 引导页
            GuideVC *wsCtrl = [[GuideVC alloc]init];
            self.window.rootViewController = wsCtrl;
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isFirst"];
        }else{
            [self initUserManager];
        }
    });

}
#pragma mark ========== 初始化网络配置 ==========
-(void)NetWorkConfig{
  
}

#pragma mark ========== 初始化用户系统 ==========
-(void)initUserManager{
//    DLog(@"设备IMEI ：%@",[OpenUDID value]);
//
    if([userManager loadUserInfo]){
        [[PWSocketManager sharedPWSocketManager] connect];
        //如果有本地数据，先展示TabBar 随后异步自动登录
        self.mainTabBar = [MainTabBarController new];
        self.window.rootViewController = self.mainTabBar;
        [self DetectNewVersion];
        //自动登录
//        [userManager autoLoginToServer:^(BOOL success, NSString *des) {
//            if (success) {
//                DLog(@"自动登录成功");
//                // [MBProgressHUD showSuccessMessage:@"自动登录成功"];
//                KPostNotification(KNotificationAutoLoginSuccess, nil);
//            }else{
////                [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
//            }
//        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }

}

#pragma mark ========== 登录状态处理 ==========
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        [[PWSocketManager sharedPWSocketManager] connect];
        //为避免自动登录成功刷新tabbar
        if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            self.mainTabBar = [MainTabBarController new];
            
            CATransition *anima = [CATransition animation];
            anima.type = @"cube";//设置动画的类型
            anima.subtype = kCATransitionFromRight; //设置动画的方向
            anima.duration = 0.3f;
            
            self.window.rootViewController = self.mainTabBar;
            
            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
            
        }
      
//        BOOL connect =  [[IssueListManger sharedIssueListManger] judgeIssueConnectState];
//        if (connect) {
//            [[IssueListManger sharedIssueListManger] downLoadAllIssueList];
//        }
        
    }else {//登陆失败加载登陆页面控制器
        self.mainTabBar = nil;
        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[VerifyCodeLoginVC new]];
        CATransition *anima = [CATransition animation];
        anima.type = @"fade";//设置动画的类型
        anima.subtype = kCATransitionFromRight; //设置动画的方向
        anima.duration = 0.3f;
        self.window.rootViewController = loginNavi;
        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    }
    //展示FPS
#ifdef DEBUG //开发环境
    [AppManager showFPS];
#endif

}
#pragma mark ========== 网络状态监听  ==========

- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkState) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}
#pragma mark ========== 网络状态变化 ==========
- (void)netWorkState{
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([conn currentReachabilityStatus] == NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        KPostNotification(KNotificationNetWorkStateChange, nil);
    }else{
        KPostNotification(KNotificationNetWorkStateChange, nil);
    }
}
- (void)netWorkStateChange:(NSNotification *)notification
{
    
    [[PWSocketManager sharedPWSocketManager]checkForRestart];
    
}

#pragma mark ========== 友盟 初始化 ==========
-(void)initUMeng{
  
}
#pragma mark ========== 配置第三方 ==========
-(void)configUSharePlatforms{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    keyboardManager.keyboardDistanceFromTextField = 20;
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];   
}
#pragma mark ========== 诸葛io 初始化 ==========
-(void)initZhuge{
    
}
#pragma mark ========== OpenURL 回调 ==========
// 支持所有iOS系统。注：此方法是老方法，建议同时实现 application:openURL:options: 若APP不支持iOS9以下，可直接废弃当前，直接使用application:openURL:options:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return YES;
}



+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}
-(void)DetectNewVersion{
  
    
    //获取appStore网络版本号
    [PWNetworking requsetWithUrl:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", APP_ID] withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        NSArray *results = response[@"results"];
        if (results.count>0) {
            NSDictionary *dict = results[0];
            [self judgeTheVersion:dict];
        }
        
    } failBlock:^(NSError *error) {
      
        
    }];
    

}
- (void)judgeTheVersion:(NSDictionary *)dict{
    NSString *releaseNotes = [dict stringValueForKey:@"releaseNotes" default:@""];
    NSString *version = [dict stringValueForKey:@"version" default:@""];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if ([nowVersion compare:version options:NSNumericSearch] != NSOrderedDescending) {
        DetectionVersionAlert *alert = [[DetectionVersionAlert alloc]initWithReleaseNotes:releaseNotes Version:version];
        [alert showInView:[UIApplication sharedApplication].keyWindow];
        alert.itemClick = ^(){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", APP_ID]];
            [[UIApplication sharedApplication] openURL:url];
        };
    }
//    if (![nowVersion isEqualToString:version]) {
    
//    }

}
@end
