//
//  LoginPasswordVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/6.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "LoginPasswordVC.h"
#import "NSString+verify.h"
#import "OpenUDID.h"
#import "FindPasswordVC.h"
#import "UserManager.h"
#import <TTTAttributedLabel.h>

@interface LoginPasswordVC ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UITextField *phoneTf;

@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *showWordsBtn;

@property (nonatomic, strong) UIButton *findWordsBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *verifyCodeBtn;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) TTTAttributedLabel *agreementLab;

@property (nonatomic, strong) NSString *temp;
@end

@implementation LoginPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWWhiteColor;
    self.isHidenNaviBar = YES;
    [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
    [self.verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.view).offset(Interval(kStatusBarHeight+16));
        make.height.offset(ZOOM_SCALE(22));
    }];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), kTopHeight+ZOOM_SCALE(50), kWidth, ZOOM_SCALE(37))];
    titleLab.font = BOLDFONT(26);
    titleLab.text = @"账号密码登录";
    titleLab.textColor = PWTextBlackColor;
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLab];
  
    UILabel *phone = [[UILabel alloc]init];
    phone.text = @"手机号/邮箱";
    phone.font = MediumFONT(14);
    phone.textColor = PWSubTitleColor;
    [self.view addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(ZOOM_SCALE(31));
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(phone.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
     
      UIView * line1 = [[UIView alloc]init];
        line1.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
      [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(self.phoneTf.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.phoneTf.mas_right);
        make.height.offset(ZOOM_SCALE(1));
    }];
    UILabel *password = [[UILabel alloc]init];
    password.text = @"密码";
    password.font = MediumFONT(14);
    password.textColor = PWSubTitleColor;
    [self.view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(line1.mas_bottom).offset(ZOOM_SCALE(27));
        make.right.mas_equalTo(self.phoneTf.mas_right);
        make.height.offset(ZOOM_SCALE(20));
    }];
    
    [self.showWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(password.mas_bottom).offset(ZOOM_SCALE(3));
        make.width.height.offset(ZOOM_SCALE(24));
    }];
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(password.mas_bottom).offset(ZOOM_SCALE(4));
        make.left.mas_equalTo(password.mas_left);
        make.right.mas_equalTo(self.showWordsBtn.mas_left);
        make.height.offset(ZOOM_SCALE(25));
    }];
    
    UIView  *line2 = [[UIView alloc]initWithFrame:CGRectZero];
    line2.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(self.passwordTf.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(line1.mas_right);
        make.height.offset(ZOOM_SCALE(1));
    }];

    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(line2).offset(ZOOM_SCALE(71));
        make.height.offset(ZOOM_SCALE(47));
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_left);
        make.top.mas_equalTo(line2.mas_bottom).offset(ZOOM_SCALE(14));
        make.width.height.offset(ZOOM_SCALE(13));
    }];
    [self.findWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(Interval(-16));
        make.height.offset(ZOOM_SCALE(20));
        make.centerY.mas_equalTo(self.selectBtn);
        make.width.offset(ZOOM_SCALE(60));
    }];
    
    [self.agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(ZOOM_SCALE(10));
        make.right.mas_equalTo(self.findWordsBtn.mas_left).offset(-ZOOM_SCALE(10));
        make.height.offset(ZOOM_SCALE(20));
        make.centerY.mas_equalTo(self.selectBtn);
    }];

    RACSignal *phoneTf = [[self.phoneTf rac_textSignal]map:^id(NSString *value) {
        
        if((value.length == 3 || value.length == 8 )){
            if (value.length<self.temp.length) {
                value =[value substringToIndex:value.length-1];
            }else{
            value = [NSString stringWithFormat:@"%@ ", value];
            }
        }
        self.phoneTf.text = value;
        self.temp = value;
        return value;
    }];
    RACSignal *passwordTf =  [self.passwordTf rac_textSignal];
    RACSignal *btn = [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]map:^id(id value) {
        return @(self.selectBtn.selected);
    }];
    RACSignal * validEmailSignal = [RACSignal combineLatest:@[phoneTf,passwordTf,btn] reduce:^id(NSString * phone,NSString * password){
        return @(@([phone stringByReplacingOccurrencesOfString:@" " withString:@""].length == 11) && [NSString validatePassWordForm:password] && self.selectBtn.selected);
    }];
    RAC(self.loginBtn,enabled) = validEmailSignal;
    RAC(self.loginBtn, backgroundColor) = [validEmailSignal map: ^id (id value){
        if([value boolValue]){
            return PWBlueColor;
        }else{
            return [UIColor colorWithHexString:@"C7C7CC"];
        }
    }];
}
-(UIButton *)findWordsBtn{
    if (!_findWordsBtn) {
        _findWordsBtn = [[UIButton alloc]init];
        [_findWordsBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        _findWordsBtn.titleLabel.font = MediumFONT(14);
        [_findWordsBtn addTarget:self action:@selector(findWordClick) forControlEvents:UIControlEventTouchUpInside];
        [_findWordsBtn setTitleColor:PWTitleColor forState:UIControlStateNormal];
        [self.view addSubview:_findWordsBtn];
    }
    return _findWordsBtn;
}
-(UITextField *)phoneTf{
    if (!_phoneTf) {
        _phoneTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _phoneTf.placeholder = @"请输入手机号码";
        _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_phoneTf];
        }
    return _phoneTf;
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
-(UIButton *)loginBtn{
    if(!_loginBtn){
        _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(377), ZOOM_SCALE(280), ZOOM_SCALE(44))];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn setBackgroundColor:PWBlueColor];
        _loginBtn.enabled = NO;
        _loginBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _loginBtn.layer.masksToBounds = YES;
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
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
-(UITextField *)passwordTf{
    if (!_passwordTf) {
        _passwordTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _passwordTf.secureTextEntry = YES;
        _passwordTf.placeholder = @"请输入密码";
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
-(UIButton *)verifyCodeBtn{
    if (!_verifyCodeBtn) {
        _verifyCodeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_verifyCodeBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_verifyCodeBtn addTarget:self action:@selector(verifyCodeClick) forControlEvents:UIControlEventTouchUpInside];
        _verifyCodeBtn.titleLabel.font = MediumFONT(16);
        [_verifyCodeBtn setTitleColor:PWTitleColor forState:UIControlStateNormal];
        [self.view addSubview:_verifyCodeBtn];
    }
    return _verifyCodeBtn;
}

#pragma mark ========== 登录 ==========
- (void)loginClick{
    NSString *os_version =  [[UIDevice currentDevice] systemVersion];
    NSString *openUDID = [OpenUDID value];
    NSString *device_version = [NSString getCurrentDeviceModel];
    NSDictionary *param =@{@"marker":@"mobile",
        @"username":[self.phoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""],
        @"password": self.passwordTf.text,
        @"deviceId": openUDID,
        @"registrationId":@"191e35f7e06a8f91d83",
        @"deviceOSVersion": os_version,
        @"deviceVersion":device_version,
    };
    NSDictionary *data = @{@"data":param};
    [[UserManager sharedUserManager] login:UserLoginTypePwd params:data completion:^(BOOL success, NSString *des) {
        
    }];

}
- (void)selectBtnClick:(UIButton *)button{
    self.selectBtn.selected = !button.selected;
}
#pragma mark ========== 找回密码 ==========
- (void)findWordClick{
    FindPasswordVC *findVC = [[FindPasswordVC alloc]init];
    findVC.isHidenNaviBar = YES;
    findVC.isShowCustomNaviBar = YES;
    [self.navigationController pushViewController:findVC animated:YES];
}
#pragma mark ========== 验证码登录页面跳转 ==========
- (void)verifyCodeClick{
//    VerifyCodeLoginVC *verifyVC=[[VerifyCodeLoginVC alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
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
//#pragma mark ========== btn渐变背景 ==========
//-(CAGradientLayer *)backLayer{
//    if (!_backLayer) {
//        _backLayer = [self getbackgroundLayerWithFrame:self.loginBtn.frame];
//    }
//    return _backLayer;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.phoneTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
