//
//  VerifyCodeVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import "VerifyCodeVC.h"
#import "PersonalInfoVC.h"
#import "PWMNView.h"
#import "UserManager.h"
#import "OpenUDID.h"
#import "PasswordSetVC.h"
#import "PWWeakProxy.h"
#import "SetNewPasswordVC.h"
#import <TTTAttributedLabel.h>
#import "PWBaseWebVC.h"
#import "BindEmailOrPhoneVC.h"
#import "TeamSuccessVC.h"
#import "JPUSHService.h"
#import "ZhugeIOLoginHelper.h"

@interface VerifyCodeVC ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong) UIButton *resendCodeBtn;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) PWMNView *codeTfView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) TTTAttributedLabel *agreementLab;
@property (nonatomic, assign) NSTimeInterval timestamp; //用于记录用户进入后台的时间戳
@end

@implementation VerifyCodeVC



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
    //对前后台状态进行监听
    [self observeApplicationActionNotification];
}
- (void)createUI{
    __weak typeof(self) weakSelf = self;
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(Interval(36), Interval(46)+kTopHeight, 250, ZOOM_SCALE(37))];
    title.text = @"输入验证码";
    title.font = MediumFONT(24);
    title.textColor = PWTextBlackColor;
    [self.view addSubview:title];
    UILabel *subTitle = [[UILabel alloc]init];
    subTitle.textColor = PWTitleColor;
    subTitle.text = @"验证码已发送至";
    subTitle.font = RegularFONT(16);
    [self.view addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(Interval(12));
        make.left.mas_equalTo(title);
        make.width.offset(kWidth-Interval(32));
        make.height.offset(ZOOM_SCALE(25));
    }];
    
    UILabel *phoneLab = [[UILabel alloc]init];
    if([self.phoneNumber validatePhoneNumber]){
         phoneLab.text =[NSString stringWithFormat:@"%@******%@",[self.phoneNumber substringToIndex:3],[self.phoneNumber substringFromIndex:9]];
    }else{
        NSArray *emailary = [self.phoneNumber componentsSeparatedByString:@"@"];
        if ([emailary[0] isKindOfClass:NSString.class]) {
            NSString *  email= emailary[0];
            if(email.length>3){
             phoneLab.text = [NSString stringWithFormat:@"%@...%@@%@",[email substringToIndex:2],[email substringFromIndex:email.length-1],emailary[1]];
            }else{
             phoneLab.text = self.phoneNumber;
            }
        }
    }
    phoneLab.font = RegularFONT(16);
    [self.view addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title);
        make.top.mas_equalTo(subTitle.mas_bottom).offset(Interval(2));
        make.height.offset(ZOOM_SCALE(22));
        make.width.offset(ZOOM_SCALE(150));
    }];
    UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTitleColor text:@"后重发"];
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
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWBlueColor text:@"60S"];
        [self.view addSubview:_timeLab];
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(timeLab.mas_left).offset(-Interval(5));
        make.centerY.mas_equalTo(timeLab);
    }];
    if (!_codeTfView) {
        PWMNView *codeTfView = [[PWMNView alloc]initWithFrame:CGRectMake(Interval(36), ZOOM_SCALE(221), kWidth-Interval(72), ZOOM_SCALE(40))];
        codeTfView.backgroundColor = PWBackgroundColor;
        codeTfView.selectColor = PWBlueColor;
        codeTfView.normolColor = PWGrayColor;
        codeTfView.count = 6;
        [codeTfView createItem];
        codeTfView.completeBlock = ^(NSString *completeStr){
            weakSelf.code = completeStr;
            if (weakSelf.type == VerifyCodeVCTypeLogin &&!weakSelf.selectBtn.selected && weakSelf.code.length == 6) {
                [iToast alertWithTitleCenter:@"同意《服务协议》《隐私权政策》后，方可登录哦"];
            }else{
                [weakSelf btnClickWithCode:completeStr];
            }
        };
//        RACSignal *codeLength =  RACObserve(self.code, length);
//        RACSignal *selected = RACObserve(self.selectBtn, selected);
        
        codeTfView.deleteBlock = ^(void){
            weakSelf.code = @"";
        };
        self.codeTfView = codeTfView;
        [self.view addSubview:self.codeTfView];
    }
    
    
    [self.codeTfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(36));
        make.top.mas_equalTo(phoneLab).offset(Interval(84));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.height.offset(ZOOM_SCALE(50));
    }];
    if (self.type == VerifyCodeVCTypeLogin) {
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
        _agreementLab.font = RegularFONT(14);
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
        [_agreementLab addLinkToURL:[NSURL URLWithString:PW_servicelegal] withRange:linkRange];
        [_agreementLab addLinkToURL:[NSURL URLWithString:PW_privacylegal] withRange:linkRange2];
        [self.view addSubview:_agreementLab];
    }
    return _agreementLab;
}
-(UIButton *)resendCodeBtn{
    if (!_resendCodeBtn) {
        _resendCodeBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"重新发送"];
        _resendCodeBtn.titleLabel.font = RegularFONT(14);
        [_resendCodeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        [_resendCodeBtn addTarget:self action:@selector(resendCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_resendCodeBtn];
    }
    return _resendCodeBtn;
}
- (void)selectBtnClick:(UIButton *)button{
    self.selectBtn.selected = !button.selected;
    if (self.selectBtn.selected) {
        if (self.code.length == 6) {
            [self btnClickWithCode:self.code];
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
    NSString *phone = self.phoneNumber?self.phoneNumber:@"";
    VerificationCodeNetWork *code  =[[VerificationCodeNetWork alloc]init];
    NSString *uuidstr = self.uuid.length>0 ?self.uuid:@"";
    [code VerificationCodeWithType:self.type phone:phone uuid:uuidstr successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            [self.timer setFireDate:[NSDate distantPast]];
            self.resendCodeBtn.hidden = YES;
            self.second = 60;
            self.timeLab.hidden = NO;
            UILabel *lab = [self.view viewWithTag:10];
            lab.hidden = NO;
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
    } failBlock:^(NSError *error) {
      [iToast alertWithTitleCenter:@"网络异常，请稍后再试！"];
    }];
  
}
- (void)btnClickWithCode:(NSString *)code{
    switch (self.type) {
        case VerifyCodeVCTypeLogin:
            [self loginWithCode:code];
            break;
        case VerifyCodeVCTypeFindPassword:
            [self findPasswordWithCode:code];
            break;
        case VerifyCodeVCTypeChangePassword:
            [self changePasswordWithCode:code];
            break;
        case VerifyCodeVCTypeUpdateEmail:
            [self updateEmailWithCode:code];
            break;
        case VerifyCodeVCTypeUpdateMobile:
            [self updateMobileWithCode:code];
            break;
        case VerifyCodeVCTypeUpdateMobileNewMobile:
            [self updateNewMobileWithCode:code];
            break;
        case VerifyCodeVCTypeTeamDissolve:
            [self teamDissolveWithCode:code];
            break;
        case VerifyCodeVCTypeTeamTransfer:
            [self teamTransferWithCode:code];

            break;
    }
}
#pragma mark ========== 验证码登录 ==========
-(void)loginWithCode:(NSString *)code{
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSMutableDictionary * data = [@{
            @"username": self.phoneNumber,
            @"verificationCode": code,
            @"marker": @"mobile",
    } mutableCopy];
    //指定最后一次登录的teamid
    NSString *lastLoginTeamId = getPWDefaultTeamID;
    if (lastLoginTeamId.length > 0){
        [data setValue:lastLoginTeamId forKey:@"teamId"];
    }
    [data addEntriesFromDictionary:[UserManager getDeviceInfo]];
    NSDictionary *param = @{@"data": data};
    [[UserManager sharedUserManager] login:UserLoginTypeVerificationCode params:param completion:^(BOOL success, NSString *des) {
//        [SVProgressHUD dismiss];
        if (success) {
            PasswordSetVC *passwordVC = [[PasswordSetVC alloc]init];
            passwordVC.changePasswordToken = des;
            [self.navigationController pushViewController:passwordVC animated:YES];
        }else{
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
        }
    }];
}
#pragma mark ========== 找回密码 ==========
- (void)findPasswordWithCode:(NSString *)code{
    NSMutableDictionary *dataDic = [@{@"username":self.phoneNumber,@"verificationCode":code,@"marker":@"mobile"}  mutableCopy];
    NSString *lastLoginTeamId = getPWDefaultTeamID;
    if (lastLoginTeamId.length > 0){
        [dataDic setValue:lastLoginTeamId forKey:@"teamId"];
    }
    NSDictionary *params = @{@"data":dataDic};
    [PWNetworking requsetWithUrl:PW_forgottenPassword withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *authAccessToken = content[@"authAccessToken"];
            setXAuthToken(authAccessToken);
            SetNewPasswordVC *newPasswordVC = [[SetNewPasswordVC alloc]init];
            newPasswordVC.isShowCustomNaviBar = YES;
            newPasswordVC.changePasswordToken = content[@"changePasswordToken"];
            [[[[[ZhugeIOLoginHelper new] eventInputGetVeryCode] attrSceneForget] attrResultPass] track];
            [self.navigationController pushViewController:newPasswordVC animated:YES];
        }else{
            [[[[[ZhugeIOLoginHelper new] eventInputGetVeryCode] attrSceneForget] attrResultNoPass] track];
            [self dealWithError:response];
        }
    } failBlock:^(NSError *error) {
        [[[[[ZhugeIOLoginHelper new] eventInputGetVeryCode] attrSceneForget] attrResultNoPass] track];
        [iToast alertWithTitleCenter:@"网络异常"];
    }];
}
#pragma mark ========== 我的/修改密码 ==========
- (void)changePasswordWithCode:(NSString *)code{
    NSDictionary *params = @{@"data":@{@"username":self.phoneNumber,@"verificationCode":code,@"marker":@"mobile"}};
    [PWNetworking requsetWithUrl:PW_forgottenPassword withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *authAccessToken = content[@"authAccessToken"];
            setXAuthToken(authAccessToken);
            SetNewPasswordVC *newPasswordVC = [[SetNewPasswordVC alloc]init];
            
            newPasswordVC.isShowCustomNaviBar = YES;
            newPasswordVC.isChange = YES;
            newPasswordVC.changePasswordToken = content[@"changePasswordToken"];
            [self.navigationController pushViewController:newPasswordVC animated:YES];
        }else{
            [self dealWithError:response];
        }
    } failBlock:^(NSError *error) {
        [iToast alertWithTitleCenter:@"网络异常"];
    }];
}
#pragma mark ========== 我的/修改邮件 ==========
- (void)updateEmailWithCode:(NSString *)code{
    //{ "data": { "username": "18236889895", "uType": "mobile", "verificationCode": "123456", "verificationCodeType": "verifycode", "t": "update_email" } }
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":code,@"t":@"update_email",@"verificationCodeType":@"verifycode"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *uuid = [content stringValueForKey:@"uuid" default:@""];
            BindEmailOrPhoneVC *bindemail = [[BindEmailOrPhoneVC alloc]init];
            bindemail.uuid = uuid;
            bindemail.changeType = BindUserInfoTypeEmail;
            bindemail.isFirst = userManager.curUserInfo.email == nil? YES:NO;
            bindemail.isShowCustomNaviBar = YES;
            [self.navigationController pushViewController:bindemail animated:YES];
        }else{
            [self dealWithError:response];
        }
    } failBlock:^(NSError *error) {
        [iToast alertWithTitleCenter:@"网络异常"];
    }];
}
#pragma mark ========== 我的/修改手机号 验证旧手机 ==========
- (void)updateMobileWithCode:(NSString *)code{
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":code,@"t":@"update_mobile",@"verificationCodeType":@"verifycode"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *uuid = [content stringValueForKey:@"uuid" default:@""];
            BindEmailOrPhoneVC *bindemail = [[BindEmailOrPhoneVC alloc]init];
            bindemail.uuid = uuid;
            bindemail.changeType = BindUserInfoTypeMobile;
            bindemail.isShowCustomNaviBar = YES;
            [self.navigationController pushViewController:bindemail animated:YES];
        }else{
            [self dealWithError:response];
        }
    } failBlock:^(NSError *error) {
        [error errorToast];
    }];

}

#pragma mark ========== 我的/修改手机号 验证新手机 ==========
-(void)updateNewMobileWithCode:(NSString *)code{
    NSDictionary *param = @{@"data":@{@"verificationCode":code,@"uuid":self.uuid}};
    [PWNetworking requsetHasTokenWithUrl:PW_modify_un withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            userManager.curUserInfo.mobile = self.phoneNumber;
            KPostNotification(KNotificationUserInfoChange, nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for(UIViewController *temp in self.navigationController.viewControllers) {
                    if([temp isKindOfClass:[PersonalInfoVC class]]){
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            });
        }else{
            [self dealWithError:response];
        }
    } failBlock:^(NSError *error) {
        [error errorToast];
    }];
    
}
- (void)teamDissolveWithCode:(NSString *)code{
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":code,@"t":@"team_cancel",@"verificationCodeType":@"verifycode"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *uuid = [content stringValueForKey:@"uuid" default:@""];
            [self doteamDissolve:uuid];
        }else{
            [self dealWithError:response];
        }
    } failBlock:^(NSError *error) {
        [error errorToast];
    }];
}
- (void)teamTransferWithCode:(NSString *)code{
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":code,@"t":@"owner_transfer",@"verificationCodeType":@"verifycode"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *uuid = [content stringValueForKey:@"uuid" default:@""];
            [self doTeamTransfer:uuid];
        }else{
            [self dealWithError:response];
        }
    } failBlock:^(NSError *error) {
        [error errorToast];
    }];
}
- (void)doTeamTransfer:(NSString *)uuid{
    NSString *uid = self.teamMemberID;
    NSDictionary *param = @{@"data":@{@"uuid":uuid}};
    [PWNetworking requsetHasTokenWithUrl:PW_OwnertTransfer(uid) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if([response[ERROR_CODE] isEqualToString:@""]){
            TeamSuccessVC *success = [[TeamSuccessVC alloc]init];
            success.isTrans = YES;
            [self presentViewController:success animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self popToAppointViewController:@"FillinTeamInforVC" animated:YES];
            });
        }

    } failBlock:^(NSError *error) {
        [error errorToast];
    }];
}
-(void)doteamDissolve:(NSString *)uuid{
    NSDictionary *param = @{@"data":@{@"uuid":uuid}};
    [PWNetworking requsetHasTokenWithUrl:PW_CancelTeam withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            TeamSuccessVC *success = [[TeamSuccessVC alloc]init];
            success.isTrans = NO;
            [self presentViewController:success animated:YES completion:nil];
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failBlock:^(NSError *error) {
       [error errorToast];
    }];
}


#pragma mark ========== TTTAttributedLabelDelegate ==========
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    NSString *title = @"服务协议";
    if ([url isEqual:[NSURL URLWithString:PW_privacylegal]]) {
        title = @"隐私权政策";
        [[[[ZhugeIOLoginHelper new] eventServiceProtocols] attrSceneLogin] track];
    } else{
        [[[[ZhugeIOLoginHelper new] eventPrivacyPolicy] attrSceneLogin] track];

    }
    PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:title andURL:url];
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"%s", __func__);
}

#pragma mark =======倒计时切换到后台，再次进入同步倒计时时间==========
- (void)observeApplicationActionNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name: UIApplicationWillResignActiveNotification object:nil];
}
- (void)applicationWillResignActive {
    _timestamp = [NSDate date].timeIntervalSince1970;
    self.timer.fireDate = [NSDate distantFuture];
}
- (void)applicationDidBecomeActive {
    //获取在后台躲了多久时间
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970-_timestamp;
    _timestamp = 0;
    NSTimeInterval ret = self.second-timeInterval;
    if (ret>0) {
        self.second = ret;
        _timer.fireDate = [NSDate date];
    } else {
        self.second = 0;
        _timer.fireDate = [NSDate date];
        [self timerRun];
    }
}
- (void)dealWithError:(NSDictionary *)response{
    [self.codeTfView setItemEmpty];
    [self.codeTfView codeView_showWarnState];
    
    if([response[ERROR_CODE] isEqualToString:@"home.auth.tooManyIncorrectAttempts"]){
        NSString *toast = [NSString stringWithFormat:@"您尝试的错误次数过多，请 %lds 后再尝试",(long)[response longValueForKey:@"ttl" default:0]];
        [SVProgressHUD showErrorWithStatus:toast];
    }else{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
    }
}
#pragma mark --寻找控制器返回--
-(void)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated{
    id vc = [self getCurrentViewControllerClass:ClassName];
    if(vc != nil && [vc isKindOfClass:[UIViewController class]]){
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(UIViewController *)getCurrentViewControllerClass:(NSString *)ClassName
{
    Class classObj = NSClassFromString(ClassName);
    
    NSArray * szArray =  self.navigationController.viewControllers;
    for (id vc in szArray) {
        if([vc isMemberOfClass:classObj])
        {
            return vc;
        }
    }
    
    return nil;
}
@end
