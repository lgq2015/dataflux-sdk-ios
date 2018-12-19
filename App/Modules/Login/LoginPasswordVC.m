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
#import "VerifyCodeLoginVC.h"
#import "UserManager.h"
#import <AFNetworking.h>
@interface LoginPasswordVC ()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UIImageView *passwordImg;
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *showWordsBtn;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) UIButton *findWordsBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *verifyCodeBtn;

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) CAGradientLayer* backLayer;
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
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(130), ZOOM_SCALE(88), ZOOM_SCALE(100), ZOOM_SCALE(56))];
        _iconImg.image = [UIImage imageNamed:@""];
        [self.view addSubview:_iconImg];
    }
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(164), kWidth, ZOOM_SCALE(25))];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.text = @"密码登录";
        _titleLab.textColor = PWTextColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLab];
    }
    if (!_phoneImg) {
        _phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(249), ZOOM_SCALE(20), ZOOM_SCALE(20))];
        _phoneImg.image = [UIImage imageNamed:@"icon_account"];
        [self.view addSubview:_phoneImg];
    }
    if (!_phoneTf) {
        _phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(ZOOM_SCALE(70), ZOOM_SCALE(250), ZOOM_SCALE(250), ZOOM_SCALE(20))];
        _phoneTf.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _phoneTf.textAlignment = NSTextAlignmentLeft;
        _phoneTf.placeholder = @"请输入手机号码";
        _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTf.textColor = PWTextColor;
        [self.view addSubview:_phoneTf];
    }
    if (!_line1){
        _line1 = [[UIView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(279), ZOOM_SCALE(280), 1)];
        _line1.backgroundColor = PWBlackColor;
        _line1.alpha = 0.05;
        [self.view addSubview:_line1];
    }
    if (!_passwordImg) {
        _passwordImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(306), ZOOM_SCALE(20), ZOOM_SCALE(20))];
        _passwordImg.image = [UIImage imageNamed:@"icon_password"];
        [self.view addSubview:_passwordImg];
    }
    if (!_showWordsBtn) {
        _showWordsBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(296), ZOOM_SCALE(302), ZOOM_SCALE(24), ZOOM_SCALE(24))];
        [_showWordsBtn setImage:[UIImage imageNamed:@"icon_visible"] forState:UIControlStateNormal];
        [_showWordsBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_showWordsBtn addTarget:self action:@selector(pwdTextSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_showWordsBtn];
    }
    if (!_passwordTf) {
        _passwordTf = [[UITextField alloc]init];
        _passwordTf.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _passwordTf.textAlignment = NSTextAlignmentLeft;
        _passwordTf.secureTextEntry = YES;
        _passwordTf.placeholder = @"请输入密码";
        _passwordTf.textColor = PWTextColor;
        [self.view addSubview:_passwordTf];
    }
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordImg.mas_right).offset(ZOOM_SCALE(10));
        make.top.equalTo(self.passwordImg);
        make.right.equalTo(self.showWordsBtn.mas_left).offset(-ZOOM_SCALE(10));
        make.height.offset(ZOOM_SCALE(20));
    }];
    if (!_line2) {
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(336), ZOOM_SCALE(280), 1)];
        _line2.backgroundColor = PWBlackColor;
        _line2.alpha = 0.05;
        [self.view addSubview:_line2];
    }
    if (!_findWordsBtn) {
        _findWordsBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(272), ZOOM_SCALE(343), ZOOM_SCALE(48), ZOOM_SCALE(17))];
        [_findWordsBtn setTitle:@"找回密码" forState:UIControlStateNormal];
        [_findWordsBtn setTitleColor:[UIColor colorWithHexString:@"7F7F7F"] forState:UIControlStateNormal];
        _findWordsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 12];
        [_findWordsBtn addTarget:self action:@selector(findWordClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_findWordsBtn];
    }
    if(!_loginBtn){
        _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(377), ZOOM_SCALE(280), ZOOM_SCALE(44))];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
        _loginBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _loginBtn.layer.masksToBounds = YES;
        [self.view addSubview:_loginBtn];
    }
    if (!_verifyCodeBtn) {
        _verifyCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(110),ZOOM_SCALE(441), ZOOM_SCALE(130), ZOOM_SCALE(20))];
        [_verifyCodeBtn setTitle:@"验证码登录/注册" forState:UIControlStateNormal];
        [_verifyCodeBtn addTarget:self action:@selector(verifyCodeClick) forControlEvents:UIControlEventTouchUpInside];
        _verifyCodeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 14];
        [_verifyCodeBtn setTitleColor:[UIColor colorWithHexString:@"FF4E00"] forState:UIControlStateNormal];
        [self.view addSubview:_verifyCodeBtn];
    }
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
        [self.view addSubview:_bgImg];
    }
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.offset(ZOOM_SCALE(125));
    }];
    RACSignal *phoneTf = [self.phoneTf rac_textSignal];
    RACSignal *passwordTf =  [self.passwordTf rac_textSignal];
   
    RACSignal * validEmailSignal = [RACSignal combineLatest:@[phoneTf,passwordTf] reduce:^id(NSString * phone,NSString * password){
        return @([NSString validateCellPhoneNumber:phone] && [NSString validatePassWordForm:password]);
    }];
    RAC(self.loginBtn,enabled) = validEmailSignal;
    RAC(self.loginBtn, backgroundColor) = [validEmailSignal map: ^id (id value){
        if([value boolValue]){
            [self.loginBtn.layer insertSublayer:self.backLayer below:self.loginBtn.titleLabel.layer];
            return [UIColor clearColor];
        }else{
            [self.backLayer removeFromSuperlayer];
            return PWBtnEnableColor;
        }
    }];
}
#pragma mark ========== 登录 ==========
- (void)loginClick{
    NSString *os_version =  [[UIDevice currentDevice] systemVersion];
    NSString *openUDID = [OpenUDID value];
    NSString *device_version = [NSString getCurrentDeviceModel];
    NSDictionary *param =@{@"auth_type":@"create",
        @"username":self.phoneTf.text,
        @"password": [self.passwordTf.text md5String],
        @"client_id": openUDID,
        @"register_id":@"191e35f7e06a8f91d83",
        @"device_type": @"ios",
        @"os_version": os_version,
        @"device_version":device_version,
    };

    [[UserManager sharedUserManager] login:kUserLoginTypePwd params:param completion:^(BOOL success, NSString *des) {
        
    }];
//    [PWNetworking requsetWithUrl:PW_login withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
//        
//    } failBlock:^(NSError *error) {
//        
//    }];
}
#pragma mark ========== 找回密码 ==========
- (void)findWordClick{
    FindPasswordVC *findVC = [[FindPasswordVC alloc]init];
    [self.navigationController pushViewController:findVC animated:YES];
}
#pragma mark ========== 验证码登录页面跳转 ==========
- (void)verifyCodeClick{
    VerifyCodeLoginVC *verifyVC=[[VerifyCodeLoginVC alloc]init];
    [self.navigationController pushViewController:verifyVC animated:YES];
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
#pragma mark ========== btn渐变背景 ==========
-(CAGradientLayer *)backLayer{
    if (!_backLayer) {
        _backLayer = [self getbackgroundLayerWithFrame:self.loginBtn.frame];
    }
    return _backLayer;
}

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
