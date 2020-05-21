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
#import "NewsWebView.h"
#import "NewsListModel.h"
#import "HomeIssueIndexGuidanceView.h"
#import "IssueListManger.h"
#import "IssueDetailsVC.h"
#import "TeamInfoModel.h"
//#import "IssueChatDataManager.h"
#import "PWSocketManager.h"
#import "IssueSourceManger.h"
#import "LoginPWVC.h"
#import "NSString+ErrorCode.h"
#import <FTMobileAgent.h>

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
-(void)configFTSDK{
    FTMobileConfig *config = [[FTMobileConfig alloc]initWithMetricsUrl:@"http://172.16.0.12:32758/v1/write/metrics?token=tkn_4c4f9f29f39c493199bb5abe7df6af21" akId:@"accid" akSecret:@"accsk" enableRequestSigning:YES];
       config.enableLog = YES;
       config.enableAutoTrack = YES;
       config.autoTrackEventType = FTAutoTrackEventTypeAppClick|FTAutoTrackEventTypeAppLaunch|FTAutoTrackEventTypeAppViewScreen;
       config.monitorInfoType = FTMonitorInfoTypeAll;
       [config enableTrackScreenFlow:YES];
       [FTMobileAgent startWithConfigOptions:config];
       [[FTMobileAgent sharedInstance] startMonitorFlush];
    
    NSDictionary *pages = @{@"LaunchVC":@"启动页面",
                            @"LoginPWVC":@"密码登录页面",
                            @"LoginVerifyCodeVC":@"验证码登录页面",
                            @"RegisterVC":@"注册页面",
                            @"FindPasswordVC":@"找回密码页面",
                            @"HomeIssueListVC":@"情报主页面",
                            @"IssueListVC":@"情报列表页面",
                            @"IssueChartVC":@"情报统计视图页面",
                            @"ScanViewController":@"扫码页面",
                            @"AddIssueVC":@"创建任务页面",
                            @"IssueDetailsVC":@"情报详情页面",
                            @"ZTCreateTeamVC":@"创建团队/团队管理页面",
                            @"SearchIssueVC":@"情报搜索页面",
                            @"CalendarVC":@"日历页面",
                            @"LibraryVC":@"智库页面",
                            @"LibrarySearchVC":@"智库搜索页面",
                            @"HandBookArticleVC":@"智库手册页面",
                            @"TeamVC":@"团队页面",
                            @"IssueSourceListVC":@"云服务页面",
                            @"MineMessageVC":@"我的消息页面",
                            @"InviteMembersVC":@"选择团队邀请方式页面",
                            @"QrCodeInviteVC":@"二维码邀请页面",
                            @"InviteByPhoneOrEmail":@"邮箱/手机号邀请页面",
                            @"MineViewController":@"我的页面",
                            @"MessageDetailVC":@"我的消息详情页面",
                            @"MineCollectionVC":@"我的收藏页面",
                            @"FeedbackVC":@"意见和反馈页面",
                            @"AboutUsVC":@"关于王教授页面",
                            @"FounctionIntroductionVC":@"功能介绍页面",
                            @"SettingUpVC":@"设置页面",
                            @"SecurityPrivacyVC":@"安全与隐私页面",
                            @"PasswordVerifyVC":@"密码验证页面",
                            @"VerifyCodeVC":@"验证码验证页面",
                            @"ContactUsVC":@"联系我们页面",
                            @"PersonalInfoVC":@"个人信息页面",
                            @"PWPhotoPickerViewController":@"选择照片页面",
                            @"ChangeUserInfoVC":@"修改手机号/邮箱页面",
                            @"NotificationRuleVC":@"通知规则列表页面",
                            @"AddNotiRuleVC":@"添加通知规则页面",
                            @"SelectVC":@"通知规则选择条件页面",
                            @"NoticeTimeVC":@"通知规则选择时间页面",
                            @"DefineOriginVC":@"填写自定义情报来源页面",
                            @"SelectAssignVC":@"选择团队成员页面",
                            @"AtTeamMemberListVC":@"选择@某人的页面",
                            @"FillinTeamInforVC":@"团队管理页面",
                            @"ChooseAssignVC":@"指派处理人页面",
                            @"GuideVC":@"引导页",
                            @"MainTabBarController":@"主页面",
                            @"MemberInfoVC":@"成员信息页面",
                            @"HandbookIndexVC":@"智库带索引列表页面",
                            @"PWBaseWebVC":@"WebView",
    };
    NSDictionary *vtps = @{@"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/UIButton[3]":@"点击情报视图切换",
                           @"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/UIButton[0]":@"点击进入扫码页面",
                           @"ScanViewController/UIWindow/UITransitionView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/UIButton[0]":@"取消扫码",
                           @"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/ZTChangeTeamNavView/UIButton[0]":@"首页显示团队列表",
                           @"UIWindow/UIView/UITableView[0]":@"点击首页切换团队/创建团队",
                           @"IssueChartVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/UIView/UITableView/IssueChartCell/TouchLargeButton[3]":@"点击进入情报列表页面",
                           @"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/IssueSelectHeaderView/TouchLargeButton[1]":@"点击情报首页筛选",
                           @"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/IssueSelectHeaderView/TouchLargeButton[3]":@"点击情报首页排序",
                           @"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/IssueSelectHeaderView/UIButton[0]":@"点击创建任务",
                           @"IssueChartListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[1]":@"点击首页情视图列表表查看详情",
                           @"IssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/UIView/UITableView[0]":@"点击首页情报列表查看详情",
                           @"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/TouchLargeButton[2]":@"点击首页情报范围",
                           @"HomeIssueListVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/UIView[4]":@"点击首页搜索",
                           @"SearchIssueVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/SearchBarView/UIButton[2]":@"点击取消情报搜索",
                           @"MainTabBarController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/PWTabBar/UITabBarButton[1]":@"跳转情报页面",
                           @"MainTabBarController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/PWTabBar/UITabBarButton[2]":@"跳转日历页面",
                           @"MainTabBarController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/PWTabBar/UITabBarButton[3]":@"跳转智库页面",
                           @"MainTabBarController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/PWTabBar/UITabBarButton[4]":@"跳转团队页面",
                           @"MainTabBarController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/PWTabBar/UITabBarButton[5]":@"跳转我的页面",
                           @"UIWindow/CalendarSelView/UIView/UIButton[2]":@"选中日历日志视图",
                           @"UIWindow/CalendarSelView/UIView/UIButton[0]":@"选中日历情报视图",
                           @"CalendarVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView/UIButton[1]":@"点击切换情报视图",
                           @"CalendarVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/LTSCalendarScrollView/CalendarArrowView/UIView/TouchLargeButton[0]":@"点击日历视图展开收缩",
                           @"CalendarVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/LTSCalendarScrollView/UITableView/CalendarListCell[4]":@"点击日历中的情报详情",
                           @"LibraryVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIView[2]":@"点击智库搜索",
                           @"LibrarySearchVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/SearchBarView/UIButton[2]":@"点击取消智库页面搜索",
                           @"TeamVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[2]":@"点击查看成员详情",
                           @"TeamVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UIButton[1]":@"点击查看团队消息",
                           @"TeamVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/ZTTeamVCTopCell/UITableViewCellContentView/TouchLargeButton[0]":@"点击邀请成员",
                           @"InviteMembersVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/InviteCardView[0]":@"点击二维码邀请",
                           @"InviteMembersVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/InviteCardView[1]":@"点击邮箱邀请",
                           @"InviteMembersVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/InviteCardView[2]":@"点击手机号邀请",
                           @"SelectConditionVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[1]":@"点击选择通知规则来源页面",
                           @"AddNotiRuleVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[1]":@"点击设置通知规则选择条件",
                           @"AddNotiRuleVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationBar/UINavigationBarContentView/UIButtonBarStackView/UITAMICAdaptorView/UIButton[0]":@"点击保存通知规则",
                           @"NotificationRuleVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationBar/UINavigationBarContentView/UIButtonBarStackView/UITAMICAdaptorView/UIButton[0]":@"点击添加通知规则",
                           @"AddNotiRuleVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[2]":@"点击选择通知方式",
                           @"AddNotiRuleVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[4]":@"点击选择通知周期",
                           @"TeamVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/ZTTeamVCTopCell/UITableViewCellContentView/TouchLargeButton[6]":@"点击通知规则",
                           @"PersonalInfoVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[1]":@"点击修改姓名",
                           @"PersonalInfoVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[2]":@"点击修改手机号",
                           @"PersonalInfoVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[0]":@"点击修改头像",
                           @"MineViewController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/UIView[8]":@"点击我的头像",
                           @"MineViewController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[1]/row[1]":@"点击联系我们",
                           @"ChangeUserInfoVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/ChangeCardItem[3]":@"选择密码验证",
                           @"ChangeUserInfoVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/ChangeCardItem[2]":@"选择手机号验证",
                           @"SecurityPrivacyVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[1]/row[0]":@"点击隐私权政策",
                           @"SecurityPrivacyVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[0]":@"点击修改密码",
                           @"SettingUpVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[0]":@"点击隐私与安全",
                           @"MineViewController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[2]/row[0]":@"点击设置页面",
                           @"MineViewController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[0]":@"点击我的消息",
                           @"MineMessageVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]":@"点击我的消息详情",
                           @"MineViewController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[0]/row[1]":@"点击我的收藏",
                           @"MineViewController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[1]/row[0]":@"点击意见和反馈",
                           @"MineViewController/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[0]/section[1]/row[3]":@"点击关于王教授",
                           @"AboutUsVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[2]/section[0]/row[0]":@"点击功能介绍",
                            @"AboutUsVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[2]/section[0]/row[1]":@"点击服务协议",
                           @"AboutUsVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView[2]/section[0]/row[2]":@"点击检测新版本",
                           @"UIWindow/ZTPopCommentView/ZTPopCommentToolView/UIButton[1]":@"点击@某人",
                           @"UIWindow/ZTPopCommentView/ZTPopCommentToolView/UIButton[0]":@"点击添加附件",
                           @"UIWindow/ZTPopCommentView/ZTPopCommentToolView/UIButton[2]":@"点击弹框中的发送按钮",
                           @"UIWindow/ZTPopCommentView/ChatInputHeaderView/UIButton[1]":@"点击放大缩小回复弹框",
                           @"IssueDetailsVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/IssueDtealsBV[1]":@"点击弹出情报回复弹框",
                           @"IssueDetailsVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/IssueEngineHeaderView/UIView/AssignView[8]":@"点击指派处理人",
                           @"IssueDetailsVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/IssueEngineHeaderView/UIView/TouchLargeButton[2]":@"点击修复情报",
                           @"NotificationRuleVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/NotiRuleCell/UITableViewCellContentView/UIView/MGSwipeButtonsView/UIView/MGSwipeButton[0]":@"点击删除通知规则",
                           @"NotificationRuleVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/NotiRuleCell/UITableViewCellContentView/TouchLargeButton[0]":@"改变通知规则订阅状态",
                           @"TeamVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/ZTTeamVCTopCell/UITableViewCellContentView/TouchLargeButton[6]":@"点击进入通知规则",
                           @"TeamVC/UIWindow/UITransitionView/UIDropShadowView/UILayoutContainerView/UITransitionView/UIViewControllerWrapperView/UILayoutContainerView/UINavigationTransitionView/UIViewControllerWrapperView/UIView/UITableView/ZTTeamVCTopCell/UITableViewCellContentView/TouchLargeButton[2]":@"点击选择云服务页面",
    };
    [[FTMobileAgent sharedInstance] isPageVtpDescEnabled:YES];
    [[FTMobileAgent sharedInstance] isFlowChartDescEnabled:YES];
    [[FTMobileAgent sharedInstance] addPageDescDict:pages];
    [[FTMobileAgent sharedInstance] addVtpDescDict:vtps];
}
#pragma mark ========== 初始化用户系统 ==========
-(void)initUserManager{

    if([userManager loadUserInfo]){
        [[PWSocketManager sharedPWSocketManager] forceRestart];
        //如果有本地数据，先展示TabBar 随后异步自动登录
        [self DetectNewVersion];
        self.mainTabBar = [MainTabBarController new];
        self.window.rootViewController = self.mainTabBar;
    }else{
        DLogE("Can't get UserInfo")
        KPostNotification(KNotificationLoginStateChange, @NO)
    }

}
- (void)dealWithNotification:(NSDictionary *)userInfo{
    DLogE(@"Notification userInfo == %@",userInfo)
    NSDictionary *aps = PWSafeDictionaryVal(userInfo, @"aps");
    NSDictionary *alert = PWSafeDictionaryVal(aps, @"alert");
    NSString *title = [alert valueForKey:@"body"]; //标题
    NSString *msgType = [userInfo stringValueForKey:@"msgType" default:@""];  //消息类型
    NSString *teamID = [userInfo stringValueForKey:@"teamId" default:@""];  //teamID
    TeamInfoModel *currentTeam = [userManager getTeamModel];
    //判断通知teamID是否和本地teamID是否一致
    BOOL isDiffentTeamID = NO;
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
            [self dealNotificationIssueEngineFinish];
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
    } else if ([msgType isEqualToString:@"issue_add"]||[msgType isEqualToString:@"issue_recovered"] || [msgType isEqualToString:@"issue_recoveredByAccount"]||[msgType isEqualToString:@"issue_assignedToYouByAccount"]) {
        [SVProgressHUD show];
        if (isDiffentTeamID){
            [self zy_requestChangeTeam:teamID complete:^(bool isFinished) {
                if (isFinished){
                    [self dealNotificationIssueDetailSkip:userInfo];
                }
            }];
        }else{
            [self dealNotificationIssueDetailSkip:userInfo];
        }
    } else if ([msgType isEqualToString:@"recommendation"]) {
        NSString *entityId = [userInfo stringValueForKey:@"entityId" default:@""];
        NSString *summary = [userInfo stringValueForKey:@"summary" default:@""];
        NSString *url = [userInfo stringValueForKey:@"url" default:@""];
//        NSString *titleW = [userInfo stringValueForKey:@"title" default:@""];
//        NSString *titleH = [alert valueForKey:@"title"];
        NewsListModel *model = [NewsListModel new];
        model.newsID = entityId;
        model.title = title;
        model.subtitle = summary;
        model.url = url;
        NewsWebView *webView = [[NewsWebView alloc] initWithTitle:title andURLString:url];
        webView.fromvc= FromVCForum;
        webView.newsModel = model;
        webView.style = WebItemViewStyleNoCollect;
        [[self getCurrentUIVC].navigationController pushViewController:webView animated:YES];
    }else if([msgType isEqualToString:@"issue_log_at"] || [msgType isEqualToString:@"issue_log_add"]){
        if (isDiffentTeamID){
             [SVProgressHUD show];
            [self zy_requestChangeTeam:teamID complete:^(bool isFinished) {
                if (isFinished){
                    [self dealNotificationIssueAt:userInfo];
                }
            }];
        }else{
            [self dealNotificationIssueAt:userInfo];
        }
        
    }else if([msgType isEqualToString:@"url_schemes"]){
        [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
        MainTabBarController *maintabbar = (MainTabBarController *)self.window.rootViewController;
        [maintabbar setSelectedIndex:0];
        if (isDiffentTeamID){
            [SVProgressHUD show];
            [self zy_requestChangeTeam:teamID complete:^(bool isFinished) {
                if (isFinished){
                    [self dealNotificationIssueDetailSkip:userInfo];
                }
            }];

        }else{
            [self dealNotificationIssueDetailSkip:userInfo];
        }
        
    }else if([msgType isEqualToString:@"issue_list"]){
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
    }else{
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
                [self deleteAllNavViewController];
            }else{
                MessageDetailVC *detail = [[MessageDetailVC alloc] init];
                detail.model = data;
                [[self getCurrentUIVC].navigationController pushViewController:detail animated:YES];
                [self deleteAllNavViewController];
            }
        } else {
            [iToast alertWithTitleCenter:data.errorMsg];
        }
    }];
}
//处理通知情报完成
- (void)dealNotificationIssueEngineFinish{
    //暂时只停留在首页
    [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
    MainTabBarController *maintabbar = (MainTabBarController *)self.window.rootViewController;
    [maintabbar setSelectedIndex:0];
//    if ([[self getCurrentUIVC] isKindOfClass:HomeViewController.class]){
//        [(HomeViewController *)[self getCurrentUIVC] setSelectedIndex:0];
//    }
}
//处理情报数
- (void)dealNotificationIssueEngineCount{
    //暂时只停留在首页
    [self dealNotificationIssueEngineFinish];
}
- (void)dealNotificationIssueAt:(NSDictionary *)userInfo{
    NSString *entityId = [userInfo stringValueForKey:@"issueId" default:@""];
    [[PWHttpEngine sharedInstance] getIssueDetail:entityId callBack:^(id o) {
        [SVProgressHUD dismiss];
        IssueModel *data = (IssueModel *) o;
        if (data.isSuccess) {
            IssueListViewModel *monitorListModel = [[IssueListViewModel alloc] initWithJsonDictionary:data];
            
            IssueDetailsVC *control = [IssueDetailsVC new];
            control.model = monitorListModel;
            [[self getCurrentUIVC].navigationController pushViewController:control animated:YES];
            [self deleteAllNavViewController];
        } else {
            [iToast alertWithTitleCenter:data.errorMsg];
        }
    }];
}
//处理情报添加、情报恢复
- (void)dealNotificationIssueDetailSkip:(NSDictionary *)userInfo{
    NSString *entityId = [userInfo stringValueForKey:@"entityId" default:@""];
    if(![entityId isEqualToString:@""]){
    [[PWHttpEngine sharedInstance] getIssueDetail:entityId callBack:^(id o) {
        [SVProgressHUD dismiss];
        IssueModel *data = (IssueModel *) o;
        if (data.isSuccess) {
            IssueListViewModel *monitorListModel = [[IssueListViewModel alloc] initWithJsonDictionary:data];
        
            IssueDetailsVC *control = [IssueDetailsVC new];
            control.model = monitorListModel;
            [[self getCurrentUIVC].navigationController pushViewController:control animated:YES];
            [self deleteAllNavViewController];
        } else {
            [iToast alertWithTitleCenter:data.errorMsg];
        }
    }];
    }else{
        [self dealNotificationIssueEngineFinish];
    }
}

#pragma mark ========== 登录状态处理 ==========
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
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
    }else {//登陆失败加载登陆页面控制器
        self.mainTabBar = nil;
        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginPWVC new]];
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

    //share
//    [WXApi registerApp:WX_APPKEY];
    [WXApi registerApp:WX_APPKEY universalLink:UNIVERSAL_LINK];
    self.tencentOAuth =  [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:nil];
    [DTOpenAPI registerApp:DINGDING_APPKEY];
}
#pragma mark ========== 诸葛io 初始化 ==========

- (void)initZhuge:(NSDictionary *)launchOptions {
    Zhuge*zhuge = [Zhuge sharedInstance];
    [zhuge startWithAppKey:ZHUGE_APPKEY launchOptions:launchOptions];
    [[zhuge config] setDebug:YES];
}
#pragma mark ========== Jpush 注册成功 ==========
- (void)jPushNetworkDidLogin:(NSNotification *)notification {
    NSString *registrationId = [JPUSHService registrationID];
    NSString *openUDID = [OpenUDID value];
    //给后台发绑定请求
    if (getXAuthToken) {
        [[PWHttpEngine sharedInstance] deviceRegistration:openUDID registrationId:registrationId callBack:^(id response) {
            BaseReturnModel* data = response;
            if(data.isSuccess){
                DLog(@"Bind Success----");
            } else{
                DLog(@"Bind Failure----");
            }
            
        }];
    }
   
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}
#pragma mark ========== OpenURL 回调 ==========
// 支持所有iOS系统。注：此方法是老方法，建议同时实现 application:openURL:options: 若APP不支持iOS9以下，可直接废弃当前，直接使用application:openURL:options:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
   
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{

    [WXApi handleOpenURL:url delegate:self];
    [self handleOpenUrl:url];
    return YES;
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webUrl = userActivity.webpageURL;
        [self handleOpenUrl:webUrl];
    }
    [WXApi handleOpenUniversalLink:userActivity delegate:self];
    return YES;
}


-(void)handleOpenUrl:(NSURL *)url{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    DLog(@"urlComponents == %@",urlComponents);
    // url中参数的key value
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in urlComponents.queryItems) {
        [parameter setValue:item.value forKey:item.name];
    }
    if([parameter containsObjectForKey:@"rtype"]){
        if ([parameter[@"rtype"] isEqualToString:@"issue_detail"]) {
            if( [parameter containsObjectForKey:@"teamid"] &&[parameter containsObjectForKey:@"issueid"]){
                NSDictionary *userinfo = @{@"teamId":[parameter stringValueForKey:@"teamid" default:@""],@"msgType":@"url_schemes",@"entityId":[parameter stringValueForKey:@"issueid" default:@""]};
                setRemoteNotificationData(userinfo);
                [kUserDefaults synchronize];
                KPostNotification(KNotificationNewRemoteNoti, nil);
            }
        }else if([parameter[@"rtype"] isEqualToString:@"issue_list"]){
            if( [parameter containsObjectForKey:@"teamid"]){
                NSDictionary *userinfo = @{@"teamId":[parameter stringValueForKey:@"teamid" default:@""],@"msgType":@"issue_list"};
                setRemoteNotificationData(userinfo);
                [kUserDefaults synchronize];
                KPostNotification(KNotificationNewRemoteNoti, nil);
            }
        }
    }

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

    if(getIsDevMode){
        [NBULog setAppLogLevel:DDLogLevelVerbose];
    } else{
#if DEV
        [NBULog setAppLogLevel:DDLogLevelVerbose];

#elif PREPROD
        [NBULog setAppLogLevel:DDLogLevelVerbose];
#else
        [NBULog setAppLogLevel:DDLogLevelWarning];
#endif
    }

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
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@"home.account.teamNotJoined"]) {
                [iToast alertWithTitleCenter:NSLocalizedString(@"local.NotHaveRelevantPermissions", @"")];
            }else{
            [iToast alertWithTitleCenter:[response[ERROR_CODE]toErrString]];
            }
            completeBlock ? completeBlock(NO) : nil;
        }
    } failBlock:^(NSError *error){
        [SVProgressHUD dismiss];
        completeBlock ? completeBlock(NO) : nil;
    }];
}
- (void)dealChangeTeam:(id) response withTeamID:(NSString *)teamID complete:(void(^)(bool isFinished))completeBlock{
    NSString *token = response[@"content"][@"authAccessToken"];
//    [[IssueChatDataManager sharedInstance] shutDown];
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
- (void)deleteAllNavViewController{
    UINavigationController *nav = [self getCurrentUIVC].navigationController;
    NSMutableArray *vcs = nav.viewControllers.mutableCopy;
    if (vcs.count > 2){
        for (NSInteger i = vcs.count - 2;i>0;i--){
            [vcs removeObjectAtIndex:i];
        }
        [nav setViewControllers:vcs animated:NO];
    }
}
@end
