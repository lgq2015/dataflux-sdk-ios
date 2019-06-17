//
//  LoginVerifyCodeVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "LoginVerifyCodeVC.h"
#import "RegisterVC.h"
@interface LoginVerifyCodeVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *passwordBtn;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, assign) NSTimeInterval timestamp; //用于记录用户进入后台的时间戳

@end

@implementation LoginVerifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWWhiteColor;
    self.isHidenNaviBar = YES;
    [self createUI];
    [self observeApplicationActionNotification];

}
- (void)createUI{
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logo];
    logo.frame = CGRectMake(0, 36+kTopHeight, ZOOM_SCALE(148), ZOOM_SCALE(34));
    logo.centerX = self.view.centerX;
   
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    [self.view addSubview:phoneIcon];
    phoneIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(logo.frame)+Interval(62), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(phoneIcon.frame)+Interval(10), kWidth-Interval(72), 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line1];
    [self.getCodeBtn sizeToFit];
    CGSize codeSize = self.getCodeBtn.frame.size;
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line1.mas_right);
        make.centerY.mas_equalTo(phoneIcon);
        make.height.offset(ZOOM_SCALE(21));
        make.width.offset(codeSize.width);
    }];
    UIImageView *passwordIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_code"]];
    [self.view addSubview:passwordIcon];
    passwordIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(line1.frame)+Interval(24), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(passwordIcon.frame)+Interval(10), kWidth-Interval(72), 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line2];
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor =[UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.height.offset(ZOOM_SCALE(16));
        make.centerY.mas_equalTo(phoneIcon);
        make.right.mas_equalTo(self.getCodeBtn.mas_left).offset(-7);
    }];
    self.loginBtn.frame = CGRectMake(Interval(36), CGRectGetMaxY(line2.frame)+Interval(44), kWidth-Interval(72), ZOOM_SCALE(44));
    self.passwordBtn.frame = CGRectMake(Interval(36), CGRectGetMaxY(self.loginBtn.frame)+Interval(16), kWidth-Interval(72), ZOOM_SCALE(44));
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIcon.mas_right).offset(12);
        make.centerY.mas_equalTo(phoneIcon);
        make.right.mas_equalTo(line3.mas_left);
        make.height.offset(ZOOM_SCALE(21));
    }];
    self.codeTF.frame = CGRectMake(CGRectGetMaxX(passwordIcon.frame)+12, 0, kWidth-CGRectGetMaxX(passwordIcon.frame)-Interval(48), ZOOM_SCALE(21));
    self.codeTF.centerY = passwordIcon.centerY;
    [self.registerBtn sizeToFit];
    CGSize registerSize = self.registerBtn.frame.size;
    self.registerBtn.frame = CGRectMake(0, CGRectGetMaxY(self.passwordBtn.frame)+Interval(20), registerSize.width, registerSize.height);
    self.registerBtn.centerX = self.view.centerX;
    
    self.phoneTF.delegate = self;

    [[self.phoneTF rac_textSignal] subscribeNext:^(id x) {
        NSString *num =[x stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self dealTFText:num];
    }];
 
}
- (void)dealTFText:(NSString *)text{
    if (text.length>11) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
        text = [text substringToIndex:11];
        self.phoneTF.text = [NSString stringWithFormat:@"%@ %@ %@",[text substringToIndex:3],[text substringWithRange:NSMakeRange(3, 4)],[text substringFromIndex:7]];
    }else if(text.length>7){
        self.phoneTF.text = [NSString stringWithFormat:@"%@ %@ %@",[text substringToIndex:3],[text substringWithRange:NSMakeRange(3, 4)],[text substringFromIndex:7]];
    }else if(text.length>3){
        self.phoneTF.text = [NSString stringWithFormat:@"%@ %@",[text substringToIndex:3],[text substringFromIndex:3]];
    }else{
        self.phoneTF.text = text;
    }
}
#pragma mark ========== init ==========
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"登录"];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
}
-(UIButton *)passwordBtn{
    if (!_passwordBtn) {
        _passwordBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeSummarize text:@"密码登录"];
        [_passwordBtn setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateNormal];
        [_passwordBtn setBackgroundImage:[UIImage imageWithColor:PWBackgroundColor] forState:UIControlStateHighlighted];
        [_passwordBtn.layer setBorderColor:PWBlueColor.CGColor];
        [_passwordBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_passwordBtn addTarget:self action:@selector(passwordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_passwordBtn];
    }
    return _passwordBtn;
}

-(UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.clearButtonMode=UITextFieldViewModeNever;
        [self.view addSubview:_phoneTF];
    }
    return _phoneTF;
}
-(UITextField *)codeTF{
    if (!_codeTF) {
        _codeTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _codeTF.placeholder = @"请输入验证码";
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.clearButtonMode=UITextFieldViewModeNever;
        _codeTF.delegate = self;
        [self.view addSubview:_codeTF];
    }
    return _codeTF;
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
-(UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"获取验证码"];
        _getCodeBtn.titleLabel.font = RegularFONT(14);
        [_getCodeBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_getCodeBtn];
    }
    return _getCodeBtn;
}
#pragma mark ========== buttonClick ==========
- (void)registerBtnClick{
    RegisterVC *registerVC = [[RegisterVC alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (void)passwordBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getCodeBtnClick{
    
}
- (void)loginBtnClick{
    if ([self.phoneTF.text removeFrontBackBlank].length == 0) {
        [iToast alertWithTitleCenter:@"手机号不能为空"];
        return;
    }
    if (![[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] validatePhoneNumber]) {
        [iToast alertWithTitleCenter:@"请输入11位的手机号码"];
        return;
    }
    if ([self.codeTF.text removeFrontBackBlank].length == 0) {
        [iToast alertWithTitleCenter:@"验证码不能为空"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSMutableDictionary * data = [@{
                                    @"username": [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                                    @"verificationCode": [self.codeTF.text removeFrontBackBlank],
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
        [SVProgressHUD dismiss];
        if (success) {
           
        }else{
          
        }
    }];
    
}
#pragma mark ========== UITextFieldDelegate ==========
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [string validateNumber];
}

#pragma mark =======倒计时切换到后台，再次进入同步倒计时时间==========
- (void)observeApplicationActionNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name: UIApplicationWillResignActiveNotification object:nil];
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
