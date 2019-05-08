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
#import "PWLogFormatter.h"
#import <WXApi.h>
#import <DTShareKit/DTOpenKit.h>
#import <JPUSHService.h>
#import "OpenUDID.h"
#import "MineMessageModel.h"
#import "IssueModel.h"
#import "MessageDetailVC.h"
#import "PWBaseWebVC.h"
#import "IssueListViewModel.h"
#import "IssueDetailRootVC.h"
#import "NewsWebView.h"
#import "IssueProblemDetailsVC.h"
#import "NewsListModel.h"
#import "IssueDetailVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HomeViewController.h"
#import "HomeIssueIndexGuidanceView.h"
#import "IssueListManger.h"
#import "IssueChatDataManager.h"
#import "PWSocketManager.h"
#import "IssueSourceManger.h"
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
    //监听JPush注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jPushNetworkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
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
#if DEBUG
    //是否显示控制器名称
    [self isShowVCName:YES];
#endif
}
#pragma mark ========== 初始化网络配置 ==========
-(void)NetWorkConfig{
  
}

#pragma mark ========== 初始化用户系统 ==========
-(void)initUserManager{
//    DLog(@"设备IMEI ：%@",[OpenUDID value]);
//
    if([userManager loadUserInfo]){
        [[PWSocketManager sharedPWSocketManager] forceRestart];
        //如果有本地数据，先展示TabBar 随后异步自动登录
        [self DetectNewVersion];
        self.mainTabBar = [MainTabBarController new];
        self.window.rootViewController = self.mainTabBar;
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
        DLogE("Can't get UserInfo")
        KPostNotification(KNotificationLoginStateChange, @NO)
    }

}
- (void)dealWithNotification:(NSDictionary *)userInfo{
    NSDictionary *aps = PWSafeDictionaryVal(userInfo, @"aps");
    NSDictionary *alert = PWSafeDictionaryVal(aps, @"alert");
    NSString *title = [alert valueForKey:@"title"]; //标题
    NSString *msgType = [userInfo stringValueForKey:@"msgType" default:@""];  //消息类型
    NSString *teamID = [userInfo stringValueForKey:@"teamId" default:@""];  //teamID
    TeamInfoModel *currentTeam = [userManager getTeamModel];
    //判断通知teamID是否和本地teamID是否一致
    bool isDiffentTeamID = NO;
    if (teamID.length > 0 && ![teamID isEqualToString:currentTeam.teamID]){
        isDiffentTeamID = YES;
    }else{
        isDiffentTeamID = NO;
    }
    //判断是否是其他团队的通知消息
    if ([msgType isEqualToString:@"system_message"]) {
        [SVProgressHUD show];
        if (isDiffentTeamID){
            [self zy_requestChangeTeam:teamID complete:^(bool isFinished) {
                if (isFinished){
                    [self dealNotificaionSystemMessage:userInfo withTitle:title];
                }
            }];
        }else{
            [self dealNotificaionSystemMessage:userInfo withTitle:title];
        }
    } else if ([msgType isEqualToString:@"issue_engine_finish"]) {
        if (isDiffentTeamID){
            [SVProgressHUD show];
            [self zy_requestChangeTeam:teamID complete:^(bool isFinished) {
                if (isFinished){
                    [SVProgressHUD dismiss];
                    [self dealNotificationIssueEngineFinish];
                }
            }];
        }else{
            [self dealNotificationIssueEngineFinish];
        }
       
    } else if ([msgType isEqualToString:@"issue_engine_count"]) {
        if (isDiffentTeamID){
            [SVProgressHUD show];
            [self zy_requestChangeTeam:teamID complete:^(bool isFinished) {
                if (isFinished){
                    [SVProgressHUD dismiss];
                    [self dealNotificationIssueEngineCount];
                }
            }];
        }else{
            [self dealNotificationIssueEngineCount];
        }
    } else if ([msgType isEqualToString:@"issue_add"]) {
        [SVProgressHUD show];
        if (isDiffentTeamID){
            [self zy_requestChangeTeam:teamID complete:^(bool isFinished) {
                if (isFinished){
                    [self dealNotificationIssueAdd:userInfo];
                }
            }];
        }else{
            [self dealNotificationIssueAdd:userInfo];
        }
    } else if ([msgType isEqualToString:@"recommendation"]) {
        NSString *entityId = [userInfo stringValueForKey:@"entityId" default:@""];
        NSString *summary = [userInfo stringValueForKey:@"summary" default:@""];
        NSString *url = [userInfo stringValueForKey:@"url" default:@""];
        NSString *titleW = [userInfo stringValueForKey:@"title" default:@""];
        DLog(@"zhangtao123456------%@-----%@",title,titleW);
        NewsListModel *model = [NewsListModel new];
        model.newsID = entityId;
        model.title = title;
        model.subtitle = summary;
        model.url = url;
        NewsWebView *webView = [[NewsWebView alloc] initWithTitle:title andURLString:url];
        webView.newsModel = model;
        webView.style = WebItemViewStyleNoCollect;
        [[self getCurrentUIVC].navigationController pushViewController:webView animated:YES];
    }
    
}
//处理通知系统消息
- (void)dealNotificaionSystemMessage:(NSDictionary *)userInfo withTitle:(NSString *)title{
    NSString *entityId = [userInfo stringValueForKey:@"entityId" default:@""];
    [[PWHttpEngine sharedInstance] getMessageDetail:entityId callBack:^(id o) {
        [SVProgressHUD dismiss];
        MineMessageModel *data = (MineMessageModel *) o;
        if (data.isSuccess) {
            if ([userInfo containsObjectForKey:@"uri"] && ![[userInfo stringValueForKey:@"uri" default:@""] isEqualToString:@""]) {
                NSString *uri = [userInfo stringValueForKey:@"uri" default:@""];
                PWBaseWebVC *webView = [[PWBaseWebVC alloc] initWithTitle:title andURLString:uri];
                [[self getCurrentUIVC].navigationController pushViewController:webView animated:YES];
            }else{
                MessageDetailVC *detail = [[MessageDetailVC alloc] init];
                detail.model = data;
                [[self getCurrentUIVC].navigationController pushViewController:detail animated:YES];
            }
        } else {
            [iToast alertWithTitleCenter:data.errorCode];
        }
    }];
}
//处理通知情报完成
- (void)dealNotificationIssueEngineFinish{
    //暂时只停留在首页
    [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
    MainTabBarController *maintabbar = (MainTabBarController *)self.window.rootViewController;
    [maintabbar setSelectedIndex:0];
    if ([[self getCurrentUIVC] isKindOfClass:HomeViewController.class]){
        [(HomeViewController *)[self getCurrentUIVC] setSelectedIndex:0];
    }
}
//处理情报数
- (void)dealNotificationIssueEngineCount{
    //暂时只停留在首页
    [self dealNotificationIssueEngineFinish];
}
//处理情报添加
- (void)dealNotificationIssueAdd:(NSDictionary *)userInfo{
    NSString *entityId = [userInfo stringValueForKey:@"entityId" default:@""];
    [[PWHttpEngine sharedInstance] getIssueDetail:entityId callBack:^(id o) {
        [SVProgressHUD dismiss];
        IssueModel *data = (IssueModel *) o;
        if (data.isSuccess) {
            IssueListViewModel *monitorListModel = [[IssueListViewModel alloc] initWithJsonDictionary:data];
            
            IssueDetailRootVC *control;
            if ([data.origin isEqualToString:@"user"]) {
                control = [IssueProblemDetailsVC new];
            } else {
                control = [IssueDetailVC new];
            }
            control.model = monitorListModel;
            
            [[self getCurrentUIVC].navigationController pushViewController:control animated:YES];
            
        } else {
            [iToast alertWithTitleCenter:data.errorCode];
        }
    }];
}
#pragma mark ========== 登录状态处理 ==========
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
//        [[PWSocketManager sharedPWSocketManager] connect];
        [self DetectNewVersion];

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
    keyboardManager.keyboardDistanceFromTextField = 25;

    keyboardManager.enableAutoToolbar = NO;

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD setKeyBoardMove:YES];

    //分享
    [WXApi registerApp:WX_APPKEY];
    self.tencentOAuth =  [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:nil];
    [DTOpenAPI registerApp:DINGDING_APPKEY];
}
#pragma mark ========== 诸葛io 初始化 ==========
-(void)initZhuge{
    
}
#pragma mark ========== Jpush 注册成功 ==========
- (void)jPushNetworkDidLogin:(NSNotification *)notification {
    NSString *registrationId = [JPUSHService registrationID];
    NSString *openUDID = [OpenUDID value];
    //给后台发绑定请求
    NSDictionary *params = @{
                             @"deviceId": openUDID,
                             @"registrationId":registrationId
                             };
    [PWNetworking requsetHasTokenWithUrl:PW_jpushDidLogin withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        DLog(@"绑定成功----");
    } failBlock:^(NSError *error) {
        DLog(@"绑定失败----");
    }];
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}
#pragma mark ========== OpenURL 回调 ==========
// 支持所有iOS系统。注：此方法是老方法，建议同时实现 application:openURL:options: 若APP不支持iOS9以下，可直接废弃当前，直接使用application:openURL:options:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"支付宝result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:KZhifubaoPayResult object:resultDic];
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"支付宝result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            DLog(@"支付宝授权结果 authCode = %@", authCode?:@"");
            [[NSNotificationCenter defaultCenter] postNotificationName:KZhifubaoPayResult object:resultDic];
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"支付宝result = %@",resultDic);
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"支付宝result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            DLog(@"支付宝授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

#pragma mark ===========是否显示控制器名称 ========
- (void)isShowVCName:(BOOL)isShow{
    if (isShow){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"zt_showvcname"];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zt_showvcname"];
    }
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
-(UIView *)getCurrentView{
   
    
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
    
   return  [[window subviews] objectAtIndex:0];
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
    NSDictionary *dict1 =getNewVersionDict;
    NSMutableDictionary *versionDict  =[NSMutableDictionary dictionaryWithDictionary:dict1];
    BOOL setversion = [versionDict boolValueForKey:version default:NO];
    if (!setversion) {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (![version isEqualToString:@""] && [nowVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        DetectionVersionAlert *alert = [[DetectionVersionAlert alloc]initWithReleaseNotes:releaseNotes Version:version];
       
           [alert showInView:[UIApplication sharedApplication].keyWindow];
        
        alert.itemClick = ^(){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", APP_ID]];
            [[UIApplication sharedApplication] openURL:url];
        };
        alert.nextClick = ^(){
            [versionDict addEntriesFromDictionary:@{version:[NSNumber numberWithBool:YES]}];
            setNewVersionDict(versionDict);
            [kUserDefaults synchronize];
        };
    }
    }

}

-(void)configLog {


    NSURL *dirUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *path = [dirUrl.path stringByAppendingPathComponent:@"pwlog"];

    PWLogFormatter *logFormatter = [[PWLogFormatter alloc] init];

    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    DDLogFileManagerDefault *fileManagerDefault = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:path];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManagerDefault];
    fileLogger.maximumFileSize=20*1024*1024;
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:logFormatter];

    [DDLog addLogger:fileLogger];

}

- (void)zy_requestChangeTeam:(NSString *)teamID complete:(void(^)(bool isFinished))completeBlock{
    NSDictionary *params = @{@"data":@{@"teamId":teamID}};
    [PWNetworking requsetHasTokenWithUrl:PW_AuthSwitchTeam withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            [self dealChangeTeam:response withTeamID:teamID complete:^(bool isFinished) {
                if (isFinished){
                    KPostNotification(KNotificationSwitchTeam, nil);
                    completeBlock ? completeBlock(YES) : nil;
                }
            }];
        }else{
            completeBlock ? completeBlock(NO) : nil;
        }
    } failBlock:^(NSError *error){
        completeBlock ? completeBlock(NO) : nil;
    }];
}
- (void)dealChangeTeam:(id) response withTeamID:(NSString *)teamID complete:(void(^)(bool isFinished))completeBlock{
    NSString *token = response[@"content"][@"authAccessToken"];
    [[IssueChatDataManager sharedInstance] shutDown];
    [[IssueListManger sharedIssueListManger] shutDown];
    [[PWSocketManager sharedPWSocketManager] shutDown];
    [[IssueSourceManger sharedIssueSourceManger] logout];
    setXAuthToken(token);
    setPWDefaultTeamID(teamID);
    //请求当前团队
    [userManager addTeamSuccess:^(BOOL isSuccess) {
        completeBlock ? completeBlock(isSuccess) : nil;
    }];
}


@end
