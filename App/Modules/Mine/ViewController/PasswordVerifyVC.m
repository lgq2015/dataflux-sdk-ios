//
//  PasswordVerifyVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PasswordVerifyVC.h"
#import "SetNewPasswordVC.h"
#import "BindEmailOrPhoneVC.h"
#import "TeamSuccessVC.h"
#import "ZhugeIOMineHelper.h"

@interface PasswordVerifyVC ()
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *showWordsBtn;

@end

@implementation PasswordVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(36), kTopHeight+Interval(46), ZOOM_SCALE(120),ZOOM_SCALE(33)) font:MediumFONT(24) textColor:PWTextBlackColor text:@"密码验证"];
    [self.view addSubview:title];
    UILabel *subTitle = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"您的登录账号为"];
    [self.view addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(Interval(7));
        make.left.mas_equalTo(self.view).offset(Interval(36));
        make.height.offset(ZOOM_SCALE(22));
    }];
    NSString *phone = [NSString stringWithFormat:@"%@******%@",[self.phoneNumber substringToIndex:3],[self.phoneNumber substringFromIndex:9]];
    UILabel *phoneLable = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:phone];
    [self.view addSubview:phoneLable];
    [phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subTitle.mas_bottom).offset(Interval(6));
        make.left.mas_equalTo(self.view).offset(Interval(36));
        make.height.offset(ZOOM_SCALE(22));
    }];
  
    [self.showWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.top.mas_equalTo(phoneLable.mas_bottom).offset(ZOOM_SCALE(83));
        make.width.height.offset(ZOOM_SCALE(24));
    }];
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(36));
        make.right.mas_equalTo(self.showWordsBtn.mas_left);
        make.centerY.mas_equalTo(self.showWordsBtn);
        make.height.offset(ZOOM_SCALE(21));
    }];
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLable.mas_left);
        make.top.mas_equalTo(self.passwordTf.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.height.offset(SINGLE_LINE_WIDTH);
    }];
    UIButton *confirmBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"确认"];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(36));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.top.mas_equalTo(line1.mas_bottom).offset(Interval(42));
        make.height.offset(ZOOM_SCALE(44));
    }];
    
    RACSignal *emailSignal= [[self.passwordTf rac_textSignal] map:^id(NSString *value) {
        if(value.length>25){
            value = [value substringToIndex:25];
            self.passwordTf.text = value;
            [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
        }
        return @(value.length>7);
    }];
    RAC(confirmBtn,enabled) = emailSignal;
    
}
-(UITextField *)passwordTf{
    if (!_passwordTf) {
        _passwordTf = [PWCommonCtrl passwordTextFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _passwordTf.secureTextEntry = YES;
        _passwordTf.placeholder = NSLocalizedString(@"login.placeholder.password", @"");
        [self.view addSubview:_passwordTf];
    }
    return _passwordTf;
}
-(UIButton *)showWordsBtn{
    if (!_showWordsBtn) {
        _showWordsBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_showWordsBtn setImage:[UIImage imageNamed:@"icon_disvisible"] forState:UIControlStateNormal];
        [_showWordsBtn setImage:[UIImage imageNamed:@"icon_visible"] forState:UIControlStateSelected];
        [_showWordsBtn addTarget:self action:@selector(pwdTextSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_showWordsBtn];
    }
    return _showWordsBtn;
}
#pragma mark ========== 密码可见/不可见 ==========
- (void)pwdTextSwitch:(UIButton *)sender {
    // 切换按钮的状态
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.passwordTf.text;
        self.passwordTf.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTf.secureTextEntry = NO;
        self.passwordTf.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = self.passwordTf.text;
        self.passwordTf.text = @"";
        self.passwordTf.secureTextEntry = YES;
        self.passwordTf.text = tempPwdStr;
    }
}
- (void)confirmBtnClick{
    switch (self.type) {
        case PassWordVerifyChangePassword:
            [[[[ZhugeIOMineHelper new] eventVerifyPwd] attrSceneChangePwd] track];

            [self changePassword];
            break;
        case PassWordVerifyUpdateEmail:
            [[[[ZhugeIOMineHelper new] eventVerifyPwd] attrSceneChangeEmail] track];

            [self updateEmail];
            break;
        case PassWordVerifyUpdateMobile:
            [[[[ZhugeIOMineHelper new] eventVerifyPwd] attrSceneChangeMobile] track];

            [self updateMobile];
            break;
        case PassWordVerifyTypeTeamTransfer:
            [[[[ZhugeIOMineHelper new] eventVerifyPwd] attrSceneVerify] track];

            [self teamTransfer];
            break;
        case PassWordVerifyTypeTeamDissolve:
            [[[[ZhugeIOMineHelper new] eventVerifyPwd] attrSceneVerify] track];

            [self teamDissolve];
            break;
    }
}
- (void)changePassword{
     [SVProgressHUD show];

    [[[[ZhugeIOMineHelper new] eventClickSetPwd] attrSceneChangePwd] track];

    NSDictionary *param = @{@"data":@{@"oldPassword":self.passwordTf.text}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifyoldpassword withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
         [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            SetNewPasswordVC *newPasswordVC = [[SetNewPasswordVC alloc]init];
            newPasswordVC.isShowCustomNaviBar = YES;
            newPasswordVC.isChange = YES;
            newPasswordVC.changePasswordToken = content[@"changePasswordToken"];
            [self.navigationController pushViewController:newPasswordVC animated:YES];
            [[[[ZhugeIOMineHelper new] eventClickChangePwd] attrVerifyWayPwd] track];

        }else{
            [iToast alertWithTitleCenter:@"密码错误" delay:0.3];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
- (void)updateEmail{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":self.passwordTf.text,@"verificationCodeType":@"password",@"t":@"update_email"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            BindEmailOrPhoneVC *bind = [[BindEmailOrPhoneVC alloc]init];
            bind.changeType = BindUserInfoTypeEmail;
            bind.uuid = response[@"content"][@"uuid"];
            bind.isShowCustomNaviBar = YES;
            [self.navigationController pushViewController:bind animated:YES];
            [[[[ZhugeIOMineHelper new] eventChangeEmail] attrVerifyWayPwd] track];

        }else{
            [iToast alertWithTitleCenter:@"密码错误"];

        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
- (void)updateMobile{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":[self.passwordTf.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"verificationCodeType":@"password",@"t":@"update_mobile"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            BindEmailOrPhoneVC *bind = [[BindEmailOrPhoneVC alloc]init];
            bind.changeType = BindUserInfoTypeMobile;
            bind.isShowCustomNaviBar = YES;
            bind.uuid =response[@"content"][@"uuid"];
            [self.navigationController pushViewController:bind animated:YES];
            [[[[ZhugeIOMineHelper new] eventChangePhone] attrVerifyWayPwd] track];

        }else{
            [iToast alertWithTitleCenter:@"密码错误"];

        }

    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
#pragma mark ========== team ==========
- (void)teamTransfer{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":[self.passwordTf.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"verificationCodeType":@"password",@"t":@"owner_transfer"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSString * uuid =response[@"content"][@"uuid"];
            [self doTeamTransfer:uuid];
        }else{
            if ([response[ERROR_CODE] isEqualToString:@"home.auth.passwordIncorrect"]) {
                [iToast alertWithTitleCenter:@"密码错误"];
            }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
            }
        }
        [SVProgressHUD dismiss];
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)teamDissolve{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data":@{@"uType":@"mobile",@"verificationCode":[self.passwordTf.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"verificationCodeType":@"password",@"t":@"team_cancel"}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodeVerify withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            
            NSString * uuid =response[@"content"][@"uuid"];
            [self doteamDissolve:uuid];
        }else{
           [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
        [SVProgressHUD dismiss];
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
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
