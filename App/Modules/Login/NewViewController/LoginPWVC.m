//
//  LoginPWVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "LoginPWVC.h"
#import "FindPasswordVC.h"
#import "LoginVerifyCodeVC.h"
#import "RegisterVC.h"

@interface LoginPWVC ()
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UITextField *accountTf;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *registerBtn;
@end

@implementation LoginPWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWWhiteColor;
    self.isHidenNaviBar = YES;
    [self createUI];
}
- (void)createUI{
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logo];
    logo.frame = CGRectMake(0, 36+kTopHeight, ZOOM_SCALE(148), ZOOM_SCALE(34));
    logo.centerX = self.view.centerX;
    
    UIImageView *accountIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_account"]];
    [self.view addSubview:accountIcon];
    accountIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(logo.frame)+Interval(62), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(accountIcon.frame)+Interval(10), kWidth-Interval(72), 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line1];
    
    UIImageView *passwordIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
    [self.view addSubview:passwordIcon];
    passwordIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(line1.frame)+Interval(24), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(passwordIcon.frame)+Interval(10), kWidth-Interval(72), 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line2];
    
    self.loginBtn.frame = CGRectMake(Interval(36), CGRectGetMaxY(line2.frame)+Interval(44), kWidth-Interval(72), ZOOM_SCALE(44));
    self.codeBtn.frame = CGRectMake(Interval(36), CGRectGetMaxY(self.loginBtn.frame)+Interval(16), kWidth-Interval(72), ZOOM_SCALE(44));
    [self.forgetBtn sizeToFit];
    CGSize size = self.forgetBtn.frame.size;
    self.forgetBtn.frame = CGRectMake(kWidth-Interval(36)-size.width, 0, size.width, ZOOM_SCALE(21));
    self.forgetBtn.centerY = passwordIcon.centerY;
    self.accountTf.frame = CGRectMake(CGRectGetMaxX(accountIcon.frame)+12, 0, kWidth-Interval(48)-CGRectGetMaxX(accountIcon.frame), ZOOM_SCALE(21));
    self.accountTf.centerY = accountIcon.centerY;
    self.passwordTF.frame = CGRectMake(CGRectGetMaxX(accountIcon.frame)+12, 0, CGRectGetMinX(self.forgetBtn.frame)-CGRectGetMaxX(accountIcon.frame)-12, ZOOM_SCALE(21));
    self.passwordTF.centerY = passwordIcon.centerY;
    [self.registerBtn sizeToFit];
    CGSize registerSize = self.registerBtn.frame.size;
    self.registerBtn.frame = CGRectMake(0, CGRectGetMaxY(self.codeBtn.frame)+Interval(20), registerSize.width, registerSize.height);
    self.registerBtn.centerX = self.view.centerX;
    

}
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"登录"];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
}
-(UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeSummarize text:@"验证码登录"];
        _codeBtn.titleLabel.font = RegularFONT(16);
        [_codeBtn setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateNormal];
        [_codeBtn setBackgroundImage:[UIImage imageWithColor:PWBackgroundColor] forState:UIControlStateHighlighted];
        [_codeBtn.layer setBorderColor:PWBlueColor.CGColor];
        [_codeBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_codeBtn];
    }
    return _codeBtn;
}
-(UIButton *)forgetBtn{
    if (!_forgetBtn) {
        _forgetBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"忘记密码"];
        [_forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _forgetBtn.titleLabel.font = RegularFONT(14);
        [self.view addSubview:_forgetBtn];
    }
    return _forgetBtn;
}
-(UITextField *)accountTf{
    if (!_accountTf) {
        _accountTf = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _accountTf.placeholder = @"请输入手机号/邮箱";
        [self.view addSubview:_accountTf];
    }
    return _accountTf;
}
-(UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [PWCommonCtrl passwordTextFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _passwordTF.placeholder = @"请输入密码";
        [self.view addSubview:_passwordTF];
    }
    return _passwordTF;
}
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc]init];
        _registerBtn.titleLabel.font = RegularFONT(14);
        [_registerBtn setTitle:@"没有账号？去注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:PWSubTitleColor forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerBtn];
    }
    return _registerBtn;
}
- (void)forgetBtnClick{
    FindPasswordVC *findVC = [[FindPasswordVC alloc]init];
    findVC.isHidenNaviBar = YES;
    findVC.isShowCustomNaviBar = YES;
    DLog(@"%@",self.accountTf.text);
    [self.navigationController pushViewController:findVC animated:YES];
}
- (void)loginBtnClick{
    if ([self.accountTf.text removeFrontBackBlank].length == 0) {
        [iToast alertWithTitleCenter:@"邮箱或手机号不能为空"];
        return;
    }
    if(self.passwordTF.text.length == 0){
        [iToast alertWithTitleCenter:@"密码不能为空"];
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *param = [@{@"marker": @"mobile",
                                    @"username": [self.accountTf.text removeFrontBackBlank],
                                    @"password": self.passwordTF.text,
                                    } mutableCopy];
    //指定最后一次登录的teamid
    NSString *lastLoginTeamId = getPWDefaultTeamID;
    if (lastLoginTeamId.length > 0){
        [param setValue:lastLoginTeamId forKey:@"teamId"];
    }
    [param addEntriesFromDictionary:[UserManager getDeviceInfo]];
    NSDictionary *data = @{@"data":param};
    [[UserManager sharedUserManager] login:UserLoginTypePwd params:data completion:^(BOOL success, NSString *des) {
        [SVProgressHUD dismiss];
    }];
}
- (void)codeBtnClick{
    LoginVerifyCodeVC *login = [[LoginVerifyCodeVC alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}
- (void)registerBtnClick{
    RegisterVC *registerVC = [[RegisterVC alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
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
