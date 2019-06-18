//
//  RegisterVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RegisterVC.h"
#import <TTTAttributedLabel.h>
#import "PWBaseWebVC.h"
#import "TouchLargeButton.h"

@interface RegisterVC ()<TTTAttributedLabelDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) TTTAttributedLabel *agreementLab;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) TouchLargeButton *selectBtn;
@end

@implementation RegisterVC

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
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    [self.view addSubview:phoneIcon];
    phoneIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(logo.frame)+Interval(62), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(phoneIcon.frame)+Interval(10), kWidth-Interval(72), SINGLE_LINE_WIDTH)];
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
   
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor =[UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SINGLE_LINE_WIDTH);
        make.height.offset(ZOOM_SCALE(16));
        make.centerY.mas_equalTo(phoneIcon);
        make.right.mas_equalTo(self.getCodeBtn.mas_left).offset(-7);
    }];
    
    
    self.phoneTF.frame = CGRectMake(CGRectGetMaxX(phoneIcon.frame)+12, 0, kWidth-Interval(48)-CGRectGetMaxX(phoneIcon.frame), ZOOM_SCALE(21));
    self.phoneTF.centerY = phoneIcon.centerY;
    
    [self itemWithImageName:@"login_code" textfiled:self.codeTF topView:self.phoneTF];
    [self itemWithImageName:@"login_name" textfiled:self.nameTF topView:self.codeTF];
    [self itemWithImageName:@"login_password" textfiled:self.passwordTF topView:self.nameTF];
    [self itemWithImageName:@"icon_email" textfiled:self.emailTF topView:self.passwordTF];
    self.registerBtn.frame = CGRectMake(Interval(36), CGRectGetMaxY(self.emailTF.frame)+55, kWidth-Interval(72), ZOOM_SCALE(44));
    [self.loginBtn sizeToFit];
    CGSize loginBtnSize = self.loginBtn.frame.size;
    self.loginBtn.frame = CGRectMake(0, CGRectGetMaxY(self.registerBtn.frame)+Interval(20), loginBtnSize.width, loginBtnSize.height);
    self.loginBtn.centerX = self.view.centerX;
    [self.agreementLab sizeToFit];
    CGSize agreeSize = self.agreementLab.frame.size;
    self.agreementLab.frame = CGRectMake(0, kHeight-20-ZOOM_SCALE(17)-SafeAreaBottom_Height, agreeSize.width, ZOOM_SCALE(17));
    self.agreementLab.centerX = self.view.centerX+20;
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.agreementLab.mas_left).offset(-7);
        make.width.height.offset(13);
        make.centerY.mas_equalTo(self.agreementLab);
    }];
}
-(void)itemWithImageName:(NSString *)imageName textfiled:(UITextField *)tf topView:(UIView *)top{
    UIImageView *accountIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:accountIcon];
    accountIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(top.frame)+Interval(37), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(accountIcon.frame)+Interval(10), kWidth-Interval(72), SINGLE_LINE_WIDTH)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line1];
    tf.frame = CGRectMake(CGRectGetMaxX(accountIcon.frame)+12, 0, kWidth-Interval(48)-CGRectGetMaxX(accountIcon.frame), ZOOM_SCALE(21));
    tf.centerY = accountIcon.centerY;
}
-(TouchLargeButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[TouchLargeButton alloc]init];
        _selectBtn.largeHeight = 15;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.selected = YES;
        [self.view addSubview:_selectBtn];
    }
    return _selectBtn;
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
        _codeTF = [PWCommonCtrl passwordTextFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.clearButtonMode=UITextFieldViewModeNever;
        _codeTF.placeholder = @"请输入验证码";
        [self.view addSubview:_codeTF];
    }
    return _codeTF;
}
-(UITextField *)nameTF{
    if (!_nameTF) {
        _nameTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _nameTF.placeholder = @"请输入姓名";
        [self.view addSubview:_nameTF];
    }
    return _nameTF;
}
-(UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [PWCommonCtrl passwordTextFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _passwordTF.placeholder = @"请输入密码";
        [self.view addSubview:_passwordTF];
    }
    return _passwordTF;
}
-(UITextField *)emailTF{
    if (!_emailTF) {
        _emailTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _emailTF.placeholder = @"请输入邮箱";
        [self.view addSubview:_emailTF];
    }
    return _emailTF;
}
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"注册"];
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
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.titleLabel.font = RegularFONT(14);
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:@"已有账号？去登录"];
        //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
        NSRange range = [@"已有账号？去登录" rangeOfString:@"去登录"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = PWBlueColor;
        //赋值
        [attribut addAttributes:dic range:range];
        _loginBtn.titleLabel.textColor = PWSubTitleColor;
        [_loginBtn setAttributedTitle:attribut forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
}
-(TTTAttributedLabel *)agreementLab{
    if (!_agreementLab) {
        NSString *linkText = @"《服务协议》";
        NSString *linkText2 = @"《隐私权政策》";
        NSString *promptText = @"同意《服务协议》与《隐私权政策》";
        NSRange linkRange = [promptText rangeOfString:linkText];
        NSRange linkRange2 = [promptText rangeOfString:linkText2];
        _agreementLab = [[TTTAttributedLabel alloc] initWithFrame: CGRectZero];
        _agreementLab.font = RegularFONT(12);
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
- (void)registerBtnClick{
    
}
- (void)passwordBtnClick{
    
}
- (void)getCodeBtnClick{
    
}
- (void)selectBtnClick{
    self.selectBtn.selected = !self.selectBtn.selected;
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
