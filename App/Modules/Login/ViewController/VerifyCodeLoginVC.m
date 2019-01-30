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

@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UIButton *verifyCodeBtn;
@property (nonatomic, strong) UIButton *passwordBtn;
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
    [self.passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.view).offset(Interval(kStatusBarHeight+13));
        make.height.offset(ZOOM_SCALE(22));
    }];
      UILabel  *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(53)+kStatusBarHeight, kWidth, ZOOM_SCALE(37))];
      titleLab.font = BOLDFONT(26);
      titleLab.text = @"您好，";
      titleLab.textColor = PWTextBlackColor;
      titleLab.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:titleLab];
     UILabel  *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(101)+kStatusBarHeight, kWidth, ZOOM_SCALE(37))];
     titleLab2.font = BOLDFONT(26);
     titleLab2.text = @"欢迎来到王教授";
     titleLab2.textColor = PWTextBlackColor;
     titleLab2.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:titleLab2];
    
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(titleLab2.mas_bottom).offset(ZOOM_SCALE(86));
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
    [self.verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(line1.mas_bottom).offset(ZOOM_SCALE(42));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    UILabel *tip = [[UILabel alloc]init];
    tip.text = @"未注册的手机，验证后即完成注册";
    tip.font = MediumFONT(14);
    tip.textColor = [UIColor colorWithHexString:@"8E8E93"];
    tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(self.verifyCodeBtn.mas_bottom).offset(ZOOM_SCALE(12));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(20));
    }];


    RACSignal *phoneTf= [[self.phoneTf rac_textSignal] map:^id(NSString *value) {
        return @([NSString validateCellPhoneNumber:value]);
    }];
    RAC(self.verifyCodeBtn,enabled) = phoneTf;
   
    RAC(self.verifyCodeBtn, backgroundColor) = [phoneTf map: ^id (id value){
        if([value boolValue]){
            return PWBlueColor;
        }else{
            return [UIColor colorWithHexString:@"C7C7CC"];;
        }
    }];
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
-(UIButton *)passwordBtn{
    if (!_passwordBtn) {
        _passwordBtn = [[UIButton alloc]init];
        [_passwordBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        [_passwordBtn addTarget:self action:@selector(passwordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _passwordBtn.titleLabel.font = MediumFONT(16);
        [_passwordBtn setTitleColor:PWTextColor forState:UIControlStateNormal];
        [self.view addSubview:_passwordBtn];
    }
    return _passwordBtn;
}
-(UIButton *)verifyCodeBtn{
    if(!_verifyCodeBtn){
        _verifyCodeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyCodeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [_verifyCodeBtn setBackgroundColor:PWBlueColor];
        _verifyCodeBtn.enabled = NO;
        _verifyCodeBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _verifyCodeBtn.layer.masksToBounds = YES;
        [self.view addSubview:_verifyCodeBtn];
    }
    return _verifyCodeBtn;
}
#pragma mark ========== 跳转密码登录 ==========
- (void)passwordBtnClick{
    LoginPasswordVC *login = [[LoginPasswordVC alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}
#pragma mark ========== 登录 ==========
- (void)loginClick{
    NSDictionary *param = @{
        @"token": @"token",
        @"mobile":self.phoneTf.text
    };
    [[UserManager sharedUserManager] login:kUserLoginTypeVerificationCode params:param completion:^(BOOL success, NSString *des) {
        
    }];
}
#pragma mark ========== 获取验证码 ==========
- (void)getVerifyCode{

    NSDictionary *param;
    //reset_password 
    NSString *token = [[NSString getNowTimeTimestamp] md5String];
    [kUserDefaults setObject:token forKey:verifyCode_token];
    if ([NSString validateCellPhoneNumber:self.phoneTf.text]) {
        param = @{@"token": token,
            @"mobile": self.phoneTf.text,
            @"type": @"entry_option",
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
