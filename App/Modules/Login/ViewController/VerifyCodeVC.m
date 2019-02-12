//
//  VerifyCodeVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import "VerifyCodeVC.h"
#import "PWMNView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UserManager.h"
#import "OpenUDID.h"
#import "PasswordSetVC.h"
#import "PWWeakProxy.h"
#import "SetNewPasswordVC.h"

@interface VerifyCodeVC ()
@property (nonatomic, strong) UIImageView *shadowImage;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, assign) NSInteger second;
@end

@implementation VerifyCodeVC


-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
     IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
     keyboardManager.enable = NO;
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 导航栏背景图
    [navBar setBarTintColor:PWBackgroundColor];
    [navBar setTintColor:PWBackgroundColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :PWBlackColor, NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    [navBar setBackgroundImage:[UIImage imageWithColor:PWBackgroundColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];//去掉阴影线
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.second = 60;
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerRun];
        }];
    } else {
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:[PWWeakProxy proxyWithTarget:self] selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
   
}
- (void)createUI{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), Interval(17), 250, ZOOM_SCALE(37))];
    title.text = @"输入验证码";
    title.font = BOLDFONT(26);
    title.textColor = PWTextBlackColor;
    [self.view addSubview:title];
    UILabel *subTitle = [[UILabel alloc]init];
    subTitle.textColor = PWTitleColor;
    subTitle.text = @"验证码已发送至";
    subTitle.font = MediumFONT(18);
    [self.view addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(Interval(6));
        make.left.mas_equalTo(title);
        make.width.offset(kWidth-Interval(32));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *phoneLab = [[UILabel alloc]init];
    phoneLab.text = [NSString stringWithFormat:@"%@******%@",[self.phoneNumber substringToIndex:3],[self.phoneNumber substringFromIndex:9]];
    phoneLab.font = MediumFONT(18);
    [self.view addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title);
        make.top.mas_equalTo(subTitle.mas_bottom).offset(Interval(6));
        make.height.offset(ZOOM_SCALE(25));
        make.width.offset(ZOOM_SCALE(150));
    }];
    UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTitleColor text:@"后重发"];
    [self.view addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneLab);
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWBlueColor text:@"60S"];
        [self.view addSubview:_timeLab];
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(timeLab.mas_left);
        make.centerY.mas_equalTo(timeLab);
    }];
    PWMNView *codeTfView = [[PWMNView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(221), kWidth-Interval(32), ZOOM_SCALE(40))];
    codeTfView.backgroundColor = PWBackgroundColor;
    codeTfView.selectColor = PWBlueColor;
    codeTfView.normolColor = PWGrayColor;
    codeTfView.count = 6;
    [codeTfView createItem];
    codeTfView.completeBlock = ^(NSString *completeStr){
        [self loginWithCode:completeStr];
    };
    [self.view addSubview:codeTfView];
    [codeTfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(phoneLab).offset(Interval(84));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(50));
    }];
}
- (void)timerRun{
    if (self.second>0) {
        self.second--;
    }
    self.timeLab.text = [NSString stringWithFormat:@"%ldS",(long)self.second];
}
- (void)loginWithCode:(NSString *)code{
    if(self.isLog){
    NSString *openUDID = [OpenUDID value];
    NSString *os_version =  [[UIDevice currentDevice] systemVersion];
    NSString *device_version = [NSString getCurrentDeviceModel];
    NSDictionary *param = @{@"data":@{@"username":self.phoneNumber,@"verificationCode":code,@"marker":@"mobile",@"deviceId":openUDID,@"registrationId":@"191e35f7e06a8f91d83",@"deviceOSVersion": os_version,@"deviceVersion":device_version}};
    [[UserManager sharedUserManager] login:UserLoginTypeVerificationCode params:param completion:^(BOOL success, NSString *des) {
        if (success) {
            if ([des isEqualToString:@"isRegister"]) {
                PasswordSetVC *passwordVC = [[PasswordSetVC alloc]init];
                [self.navigationController pushViewController:passwordVC animated:YES];
            }
        }
    }];
    }else{
        NSDictionary *params = @{@"data":@{@"username":self.phoneNumber,@"verificationCode":code,@"marker":@"mobile", }};
        [PWNetworking requsetWithUrl:PW_forgottenPassword withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
            if ([response[@"errCode"] isEqualToString:@""]) {
                NSDictionary *content = response[@"content"];
                NSString *authAccessToken = content[@"authAccessToken"];
                setXAuthToken(authAccessToken);
                SetNewPasswordVC *newPasswordVC = [[SetNewPasswordVC alloc]init];
                newPasswordVC.changePasswordToken = content[@"changePasswordToken"];
                [self.navigationController pushViewController:newPasswordVC animated:YES];
            }else{
                [iToast alertWithTitleCenter:response[@"message"]];
            }
           
        } failBlock:^(NSError *error) {
            
        }];
       
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 导航栏背景图
    [navBar setBarTintColor:CNavBgColor];
    [navBar setTintColor:CNavBgColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :PWBlackColor, NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    [navBar setBackgroundImage:[UIImage imageWithColor:CNavBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:nil];//去掉阴影线
}
-(void)viewDidDisappear:(BOOL)animated{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
}
-(void)dealloc{
    [self.timer invalidate];
    NSLog(@"%s", __func__);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
