//
//  VerifyCodeLoginVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "VerifyCodeLoginVC.h"
#import "UserManager.h"
#import "NSString+verify.h"
#import "LoginPasswordVC.h"
#import "OpenUDID.h"

@interface VerifyCodeLoginVC ()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UIImageView *verifyCodeImg;
@property (nonatomic, strong) UITextField *verifyCodeTf;
@property (nonatomic, strong) UIButton *verifyCodeBtn;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *passwordBtn;

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) CAGradientLayer* backLayer;

@end

@implementation VerifyCodeLoginVC

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
        _titleLab.text = @"验证码登录/注册";
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
    if (!_verifyCodeImg) {
        _verifyCodeImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(306), ZOOM_SCALE(20), ZOOM_SCALE(20))];
        _verifyCodeImg.image = [UIImage imageNamed:@"icon_code"];
        [self.view addSubview:_verifyCodeImg];
    }
    if (!_verifyCodeBtn) {
        _verifyCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(240), ZOOM_SCALE(306), ZOOM_SCALE(70), ZOOM_SCALE(21))];
        [_verifyCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_verifyCodeBtn setTitleColor:PWOrangeTextColor forState:UIControlStateNormal];
        _verifyCodeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 14];
        [_verifyCodeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_verifyCodeBtn];
    }
    if (!_verifyCodeTf) {
        _verifyCodeTf = [[UITextField alloc]init];
        _verifyCodeTf.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _verifyCodeTf.textAlignment = NSTextAlignmentLeft;
        _verifyCodeTf.secureTextEntry = YES;
        _verifyCodeTf.placeholder = @"请输入验证码";
        _verifyCodeTf.textColor = PWTextColor;
        [self.view addSubview:_verifyCodeTf];
    }
    [_verifyCodeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyCodeImg.mas_right).offset(ZOOM_SCALE(10));
        make.top.equalTo(self.verifyCodeImg);
        make.right.equalTo(self.verifyCodeBtn.mas_left).offset(-ZOOM_SCALE(10));
        make.height.offset(ZOOM_SCALE(20));
    }];
    if (!_line2) {
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(336), ZOOM_SCALE(280), 1)];
        _line2.backgroundColor = PWBlackColor;
        _line2.alpha = 0.05;
        [self.view addSubview:_line2];
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
    if (!_passwordBtn) {
        _passwordBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(110),ZOOM_SCALE(441), ZOOM_SCALE(130), ZOOM_SCALE(20))];
        [_passwordBtn setTitle:@"短信登录" forState:UIControlStateNormal];
        [_passwordBtn addTarget:self action:@selector(passwordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _passwordBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 14];
        [_passwordBtn setTitleColor:PWOrangeTextColor forState:UIControlStateNormal];
        [self.view addSubview:_passwordBtn];
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
    RACSignal *passwordTf =  [self.verifyCodeTf rac_textSignal];
    
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
            return [UIColor colorWithHexString:@"D8D8D8"];
        }
    }];
}
#pragma mark ========== 跳转密码登录 ==========
- (void)passwordBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== 登录 ==========
- (void)loginClick{
    NSDictionary *param = @{
        @"token": @"token",
        @"verify_code": self.verifyCodeTf.text,
        @"mobile":self.phoneTf.text
    };
    [[UserManager sharedUserManager] login:kUserLoginTypeVerificationCode params:param completion:^(BOOL success, NSString *des) {
        
    }];
}
#pragma mark ========== 获取验证码 ==========
- (void)getVerifyCode{

    NSDictionary *param;
    if ([NSString validateCellPhoneNumber:self.phoneTf.text]) {
        param = @{@"token": @"token",
            @"mobile": self.phoneTf.text,
            @"type": @"register",
            @"captcha":@"",
            @"client_id": [OpenUDID value]
        };
        [[UserManager sharedUserManager] getVerificationCodeType:CodeTypeCode WithParams:param completion:^(CodeStatus status, NSString *des) {
            
        }];
    }else{
        if (self.phoneTf.text.length == 0) {
            [iToast alertWithTitleCenter:@"手机号码不能为空！"];
        }else{
            [iToast alertWithTitleCenter:@"请输入正确的手机号码！"];
        }
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
    [self.verifyCodeTf resignFirstResponder];
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
