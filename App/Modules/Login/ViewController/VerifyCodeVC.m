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
#import <TTTAttributedLabel.h>

@interface VerifyCodeVC ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong) UIButton *resendCodeBtn;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) PWMNView *codeTfView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) TTTAttributedLabel *agreementLab;

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
    timeLab.tag = 10;
    [self.view addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneLab);
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    [self.resendCodeBtn sizeToFit];
    CGFloat width = self.resendCodeBtn.frame.size.width +5;
    [self.resendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneLab);
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(25));
        make.width.offset(width);
    }];
    self.resendCodeBtn.hidden = YES;
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWBlueColor text:@"60S"];
        [self.view addSubview:_timeLab];
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(timeLab.mas_left);
        make.centerY.mas_equalTo(timeLab);
    }];
    if (!_codeTfView) {
        PWMNView *codeTfView = [[PWMNView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(221), kWidth-Interval(32), ZOOM_SCALE(40))];
        codeTfView.backgroundColor = PWBackgroundColor;
        codeTfView.selectColor = PWBlueColor;
        codeTfView.normolColor = PWGrayColor;
        codeTfView.count = 6;
        [codeTfView createItem];
        codeTfView.completeBlock = ^(NSString *completeStr){
            self.code = completeStr;
            if (self.isLog &&!self.selectBtn.selected) {
                [iToast alertWithTitleCenter:@"未同意用户协议"];
            }else{
                [self loginWithCode:completeStr];
            }
        };
        codeTfView.deleteBlock = ^(void){
            self.code = @"";
        };
        self.codeTfView = codeTfView;
        [self.view addSubview:self.codeTfView];
    }
    
    
    [self.codeTfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(phoneLab).offset(Interval(84));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(50));
    }];
    if (self.isLog) {
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.codeTfView.mas_left);
            make.top.mas_equalTo(self.codeTfView.mas_bottom).offset(ZOOM_SCALE(14));
            make.width.height.offset(ZOOM_SCALE(13));
        }];
        [self.agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.selectBtn.mas_right).offset(ZOOM_SCALE(10));
            make.right.mas_equalTo(self.view).offset(-ZOOM_SCALE(10));
            make.height.offset(ZOOM_SCALE(20));
            make.centerY.mas_equalTo(self.selectBtn);
        }];
    }else{
    
    }
    
}
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.selected = YES;
        [self.view addSubview:_selectBtn];
    }
    return _selectBtn;
}
-(TTTAttributedLabel *)agreementLab{
    if (!_agreementLab) {
        NSString *linkText = @"《服务协议》";
        NSString *linkText2 = @"《隐私权政策》";
        NSString *promptText = @"同意《服务协议》与《隐私权政策》";
        NSRange linkRange = [promptText rangeOfString:linkText];
        NSRange linkRange2 = [promptText rangeOfString:linkText2];
        _agreementLab = [[TTTAttributedLabel alloc] initWithFrame: CGRectZero];
        _agreementLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _agreementLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
        _agreementLab.numberOfLines = 1;
        _agreementLab.delegate = self;
        _agreementLab.lineBreakMode = NSLineBreakByCharWrapping;
        _agreementLab.text = promptText;
        NSDictionary *attributesDic = @{(NSString *)kCTForegroundColorAttributeName : (__bridge id)PWBlueColor.CGColor,
                                        (NSString *)kCTUnderlineStyleAttributeName : @(NO)
                                        };
        _agreementLab.linkAttributes = attributesDic;
        _agreementLab.activeLinkAttributes = attributesDic;
        [_agreementLab addLinkToURL:[NSURL URLWithString:@"testURL"] withRange:linkRange];
        [_agreementLab addLinkToURL:[NSURL URLWithString:@"testURL"] withRange:linkRange2];
        [self.view addSubview:_agreementLab];
    }
    return _agreementLab;
}
-(UIButton *)resendCodeBtn{
    if (!_resendCodeBtn) {
        _resendCodeBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"重新发送"];
        [_resendCodeBtn setTitleColor:[UIColor colorWithHexString:@"D50000"] forState:UIControlStateNormal];
        [_resendCodeBtn addTarget:self action:@selector(resendCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_resendCodeBtn];
    }
    return _resendCodeBtn;
}
- (void)selectBtnClick:(UIButton *)button{
    self.selectBtn.selected = !button.selected;
    if (self.selectBtn.selected) {
        if (self.code.length == 6) {
            [self loginWithCode:self.code];
        }
    }
}
#pragma mark ========== 倒计时展示/重新发送 ==========
- (void)timerRun{
    if (self.second>0) {
        self.second--;
        self.timeLab.text = [NSString stringWithFormat:@"%ldS",(long)self.second];
    }else if(self.second == 0){
        self.resendCodeBtn.hidden = NO;
        [self.timer setFireDate:[NSDate distantFuture]];
        UILabel *lab = [self.view viewWithTag:10];
        lab.hidden = YES;
        self.timeLab.hidden = YES;
    }
}
- (void)resendCodeBtnClick{
    //    NSDictionary *param = @{@"data": @{@"to":self.phoneTf.text,@"t":@"login"}};
    //    [PWNetworking requsetWithUrl:PW_sendAuthCodeUrl withRequestType:NetworkPostType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
    //        if ([response[@"errCode"] isEqualToString:@""]) {
    [self.timer setFireDate:[NSDate distantPast]];
    self.resendCodeBtn.hidden = YES;
    self.second = 60;
    self.timeLab.hidden = NO;
    UILabel *lab = [self.view viewWithTag:10];
    lab.hidden = NO;
    //        }else{
    //        [iToast alertWithTitleCenter:response[@"message"]];
    //        }
    //    } failBlock:^(NSError *error) {
    //        [iToast alertWithTitleCenter:@"网络异常，请稍后再试！"];
    //    }];
}
- (void)loginWithCode:(NSString *)code{
    if(self.isLog){
    NSString *openUDID = [OpenUDID value];
    NSString *os_version =  [[UIDevice currentDevice] systemVersion];
    NSString *device_version = [NSString getCurrentDeviceModel];
    NSDictionary *param = @{@"data":@{@"username":self.phoneNumber,@"verificationCode":code,@"marker":@"mobile",@"deviceId":openUDID,@"registrationId":@"191e35f7e06a8f91d83",@"deviceOSVersion": os_version,@"deviceVersion":device_version}};
    [[UserManager sharedUserManager] login:UserLoginTypeVerificationCode params:param completion:^(BOOL success, NSString *des) {
        if (success) {
            PasswordSetVC *passwordVC = [[PasswordSetVC alloc]init];
            passwordVC.changePasswordToken = des;
            [self.navigationController pushViewController:passwordVC animated:YES];
        }else{
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
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
