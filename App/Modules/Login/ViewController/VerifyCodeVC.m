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
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), Interval(17)+kTopHeight, 250, ZOOM_SCALE(37))];
    title.text = @"输入验证码";
    title.font = MediumFONT(26);
    title.textColor = PWTextBlackColor;
    [self.view addSubview:title];
    UILabel *subTitle = [[UILabel alloc]init];
    subTitle.textColor = PWTitleColor;
    subTitle.text = @"验证码已发送至";
    subTitle.font = RegularFONT(18);
    [self.view addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(Interval(6));
        make.left.mas_equalTo(title);
        make.width.offset(kWidth-Interval(32));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *phoneLab = [[UILabel alloc]init];
    phoneLab.text = [NSString stringWithFormat:@"%@******%@",[self.phoneNumber substringToIndex:3],[self.phoneNumber substringFromIndex:9]];
    phoneLab.font = RegularFONT(18);
    [self.view addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title);
        make.top.mas_equalTo(subTitle.mas_bottom).offset(Interval(6));
        make.height.offset(ZOOM_SCALE(25));
        make.width.offset(ZOOM_SCALE(150));
    }];
    UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTitleColor text:@"后重发"];
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
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWBlueColor text:@"60S"];
        [self.view addSubview:_timeLab];
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(timeLab.mas_left).offset(-Interval(5));
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
            if (self.type == VerifyCodeVCTypeLogin &&!self.selectBtn.selected && self.code.length == 6) {
                [iToast alertWithTitleCenter:@"同意《服务协议》《隐私权政策》后，方可登录哦"];
            }else{
                [self btnClickWithCode:completeStr];
            }
        };
//        RACSignal *codeLength =  RACObserve(self.code, length);
//        RACSignal *selected = RACObserve(self.selectBtn, selected);
        
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

    [data addEntriesFromDictionary:[UserManager getDeviceInfo]];

    NSDictionary *param = @{@"data": data};
    [[UserManager sharedUserManager] login:UserLoginTypeVerificationCode params:param completion:^(BOOL success, NSString *des) {
        [SVProgressHUD dismiss];
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
    NSDictionary *params = @{@"data":@{@"username":self.phoneNumber,@"verificationCode":code,@"marker":@"mobile"}};
    [PWNetworking requsetWithUrl:PW_forgottenPassword withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *authAccessToken = content[@"authAccessToken"];
            setXAuthToken(authAccessToken);
            SetNewPasswordVC *newPasswordVC = [[SetNewPasswordVC alloc]init];
            newPasswordVC.isShowCustomNaviBar = YES;
            newPasswordVC.changePasswordToken = content[@"changePasswordToken"];
            [self.navigationController pushViewController:newPasswordVC animated:YES];
        }else{
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
            if ([response[ERROR_CODE] isEqualToString:@"home.auth.invalidIdentityToken"]) {
                [iToast alertWithTitleCenter:@"身份验证已过期，请重新验证"];
            }else if([response[ERROR_CODE] isEqualToString:@"home.auth.emailCodeIncorrect"]){
                 [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            }else{
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
            }
        }
    } failBlock:^(NSError *error) {
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
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];

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
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];

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
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];

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
           
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
            if ([response[ERROR_CODE] isEqualToString:@"home.auth.invalidIdentityToken"]) {
                [iToast alertWithTitleCenter:@"身份验证已过期，请重新验证"];
            }else{
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
            }
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
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
            if ([response[ERROR_CODE] isEqualToString:@"home.auth.invalidIdentityToken"]) {
                [iToast alertWithTitleCenter:@"身份验证已过期，请重新验证"];
            }else{
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
            }        }
    } failBlock:^(NSError *error) {
        
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
            [self.codeTfView setItemEmpty];
            [self.codeTfView codeView_showWarnState];
            if ([response[ERROR_CODE] isEqualToString:@"home.auth.invalidIdentityToken"]) {
                [iToast alertWithTitleCenter:@"身份验证已过期，请重新验证"];
            }else{
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
            }
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
        }else{
            [SVProgressHUD showErrorWithStatus:@"转移失败"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
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
            [SVProgressHUD showErrorWithStatus:@"解散失败"];
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
    }
    PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:title andURL:url];
    [self.navigationController pushViewController:webView animated:YES];
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
