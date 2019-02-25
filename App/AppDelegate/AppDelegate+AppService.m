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

#pragma mark ========== 初始化window ==========
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = PWWhiteColor;
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"]) {
//       // 引导页
//        RootViewController *wsCtrl = [[RootViewController alloc]init];
//        self.window.rootViewController = wsCtrl;
//        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isFirst"];
//    }else{
        [self initUserManager];
//    self.mainTabBar = [[MainTabBarController alloc]init];
//    self.window.rootViewController = self.mainTabBar;
//    [self.window makeKeyAndVisible];
//    [[UIButton appearance] setExclusiveTouch:YES];
//    if (@available(iOS 11.0, *)){
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
   // }
}
#pragma mark ========== 初始化网络配置 ==========
-(void)NetWorkConfig{
   
}

#pragma mark ========== 初始化用户系统 ==========
-(void)initUserManager{
//    DLog(@"设备IMEI ：%@",[OpenUDID value]);
//
    if([userManager loadUserInfo]){
        //如果有本地数据，先展示TabBar 随后异步自动登录
        self.mainTabBar = [MainTabBarController new];
        self.window.rootViewController = self.mainTabBar;
        
        //自动登录
        [userManager autoLoginToServer:^(BOOL success, NSString *des) {
            if (success) {
                DLog(@"自动登录成功");
                // [MBProgressHUD showSuccessMessage:@"自动登录成功"];
                KPostNotification(KNotificationAutoLoginSuccess, nil);
            }else{
//                [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
            }
        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }

}

#pragma mark ========== 登录状态处理 ==========
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        
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
    [AppManager showFPS];
}


#pragma mark ========== 网络状态变化 ==========
- (void)netWorkStateChange:(NSNotification *)notification
{
    
}

#pragma mark ========== 友盟 初始化 ==========
-(void)initUMeng{
  
}
#pragma mark ========== 配置第三方 ==========
-(void)configUSharePlatforms{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES; // 控制整个功能是否启用
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
  
   
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

#pragma mark ========== 网络状态监听 ==========
- (void)monitorNetworkStatus
{
   
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
    //检查新版本 更新
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        
        //获取本地版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *nowVersion = [NSString stringWithFormat:@"%@", version];
        
        //获取appStore网络版本号
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", APP_ID]];
        NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        NSString *appStoreVersion;
        if (substr.length==0) {
            appStoreVersion = @"";
        }else{
        NSRange range1 = NSMakeRange(substr.location+substr.length,10);
        //    NSRange substr2 =[file rangeOfString:@"\"" options:nil range:range1];
        NSRange substr2 = [file rangeOfString:@"\"" options:NSCaseInsensitiveSearch  range:range1];
        NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
           appStoreVersion =[file substringWithRange:range2];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            //如果不一样去更新
            if(![nowVersion isEqualToString:appStoreVersion])
            {
                [self showAlertisNew:NO];
            }else{
                [self showAlertisNew:YES];
            }
            
            
        });
    });
}
- (void)showAlertisNew:(BOOL)isNew{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    NSString *message = isNew == YES? @"已是最新版本！":@"检测有最新版本";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    if (isNew == YES) {
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancle];
    }else{
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *update = [PWCommonCtrl actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", APP_ID]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alert addAction:cancle];
        [alert addAction:update];
    }
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
