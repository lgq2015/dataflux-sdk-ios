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
#import "UITextField+HLLHelper.h"
#import "VerificationCodeNetWork.h"
#import "PWWeakProxy.h"

@interface RegisterVC ()<TTTAttributedLabelDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UILabel  *passwordTipLab;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) TTTAttributedLabel *agreementLab;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) TouchLargeButton *selectBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timestamp; //用于记录用户进入后台的时间戳
@property (nonatomic, assign) NSInteger second;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWWhiteColor;
    self.isHidenNaviBar = YES;
    [self createUI];
}
- (void)createUI{
    self.second = 60;
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
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIcon.mas_right).offset(12);
        make.centerY.mas_equalTo(phoneIcon);
        make.right.mas_equalTo(line3);
        make.height.offset(ZOOM_SCALE(21));
    }];
   
    [self itemWithImageName:@"login_code" textfiled:self.codeTF topView:phoneIcon isPassword:NO];
    [self itemWithImageName:@"login_name" textfiled:self.nameTF topView:self.codeTF isPassword:NO];
    [self itemWithImageName:@"login_password" textfiled:self.passwordTF topView:self.nameTF isPassword:YES];
    [self itemWithImageName:@"icon_email" textfiled:self.emailTF topView:self.passwordTF isPassword:NO];
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
    [[self.phoneTF rac_textSignal] subscribeNext:^(NSString *value) {
        if (value.length > 11){
            self.phoneTF.text = [self.phoneTF.text substringToIndex:11];
            [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
        }
    }];
    [[self.passwordTF rac_textSignal] subscribeNext:^(NSString *value) {
        if (value.length > 25){
            self.passwordTF.text = [self.passwordTF.text substringToIndex:25];
            [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
        }
    }];
    
}
-(void)itemWithImageName:(NSString *)imageName textfiled:(UITextField *)tf topView:(UIView *)top isPassword:(BOOL)ispassword{
    UIImageView *accountIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:accountIcon];
    accountIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(top.frame)+Interval(37), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(accountIcon.frame)+Interval(10), kWidth-Interval(72), SINGLE_LINE_WIDTH)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line1];
   
    if(ispassword){
        UIButton *showWordsBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [showWordsBtn setImage:[UIImage imageNamed:@"login_disvisable"] forState:UIControlStateNormal];
        [showWordsBtn setImage:[UIImage imageNamed:@"login_visable"] forState:UIControlStateSelected];
        [showWordsBtn addTarget:self action:@selector(pwdTextSwitch:) forControlEvents:UIControlEventTouchUpInside];
        showWordsBtn.frame = CGRectMake(kWidth-Interval(36)-ZOOM_SCALE(20), 0, ZOOM_SCALE(20), ZOOM_SCALE(20));
        showWordsBtn.centerY = accountIcon.centerY;
        [self.view addSubview:showWordsBtn];

        self.passwordTipLab.frame =CGRectMake(Interval(36), CGRectGetMaxY(line1.frame)+2, kWidth-Interval(72), ZOOM_SCALE(16));
        tf.frame = CGRectMake(CGRectGetMaxX(accountIcon.frame)+12, 0, CGRectGetMinX(showWordsBtn.frame)-Interval(12)-CGRectGetMaxX(accountIcon.frame), ZOOM_SCALE(21));
    }else{
    tf.frame = CGRectMake(CGRectGetMaxX(accountIcon.frame)+12, 0, kWidth-Interval(48)-CGRectGetMaxX(accountIcon.frame), ZOOM_SCALE(21));
    }
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
        _phoneTF.placeholder = NSLocalizedString(@"login.placeholder.phone", @"");
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.delegate = self;
        _phoneTF.clearButtonMode=UITextFieldViewModeNever;
        [self.view addSubview:_phoneTF];
    }
    return _phoneTF;
}
-(UITextField *)codeTF{
    if (!_codeTF) {
        _codeTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.clearButtonMode=UITextFieldViewModeNever;
        _codeTF.delegate = self;
        _codeTF.placeholder = NSLocalizedString(@"login.placeholder.code", @"");
        [self.view addSubview:_codeTF];
    }
    return _codeTF;
}
-(UITextField *)nameTF{
    if (!_nameTF) {
        _nameTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _nameTF.placeholder = NSLocalizedString(@"login.placeholder.name", @"");
        _nameTF.hll_limitTextLength = 30;
        _nameTF.delegate = self;
        _nameTF.spellCheckingType = UITextSpellCheckingTypeNo;// 禁用拼写检查
        [self.view addSubview:_nameTF];
    }
    return _nameTF;
}
-(UILabel *)passwordTipLab{
    if (!_passwordTipLab) {
        _passwordTipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#F6584C"] text:NSLocalizedString(@"tip.correctPasswordFormat", @"")];
        _passwordTipLab.hidden = YES;
        [self.view addSubview:_passwordTipLab];
    }
    return _passwordTipLab;
}
-(UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [PWCommonCtrl passwordTextFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _passwordTF.delegate = self;
        _passwordTF.placeholder = NSLocalizedString(@"login.placeholder.password", @"");
        [self.view addSubview:_passwordTF];
    }
    return _passwordTF;
}
-(UITextField *)emailTF{
    if (!_emailTF) {
        _emailTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _emailTF.placeholder = NSLocalizedString(@"login.placeholder.email", @"");
        _emailTF.delegate = self;
        [self.view addSubview:_emailTF];
    }
    return _emailTF;
}
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:NSLocalizedString(@"login.register", @"")];
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerBtn];
    }
    return _registerBtn;
}
-(UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:NSLocalizedString(@"home.getCode", @"")];
        _getCodeBtn.titleLabel.font = RegularFONT(14);
        [_getCodeBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:PWBlueColor forState:UIControlStateDisabled];

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
        [_loginBtn addTarget:self action:@selector(passwordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
}
-(TTTAttributedLabel *)agreementLab{
    if (!_agreementLab) {
        NSString *linkText = [NSString stringWithFormat:@"《%@》",NSLocalizedString(@"local.serviceAgreement", @"")];
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
    NSString *title = NSLocalizedString(@"local.serviceAgreement", @"");
    if ([url isEqual:[NSURL URLWithString:PW_privacylegal]]) {
        title = @"隐私权政策";
    }
    PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:title andURL:url];
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark ========== BTN/CLICK ==========
- (void)pwdTextSwitch:(UIButton *)sender {
    // 切换按钮的状态
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.passwordTF.text;
        self.passwordTF.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTF.secureTextEntry = NO;
        self.passwordTF.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = self.passwordTF.text;
        self.passwordTF.text = @"";
        self.passwordTF.secureTextEntry = YES;
        self.passwordTF.text = tempPwdStr;
    }
}
- (void)registerBtnClick{
    if ([self.phoneTF.text removeFrontBackBlank].length == 0) {
        [iToast alertWithTitleCenter:@"手机号不能为空"];
        return;
    }
    if (![[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] validatePhoneNumber]) {
        [iToast alertWithTitleCenter:@"请输入11位的手机号码"];
        return;
    }
    if ([self.codeTF.text removeFrontBackBlank].length == 0) {
        [iToast  alertWithTitleCenter:@"验证码不能为空"];
        return;
    }
    if ([self.nameTF.text removeFrontBackBlank].length == 0) {
        [iToast alertWithTitleCenter:@"姓名不能为空"];
        return;
    }
    if ([self.passwordTF.text removeFrontBackBlank].length == 0) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"login.password.empty", @"")];
        return;
    }
    if ([self.passwordTF.text removeFrontBackBlank].length<8) {
        [iToast alertWithTitleCenter:@"密码不能少于 8 位"];
        return;
    }
    if (![[self.passwordTF.text removeFrontBackBlank] validatePassWordForm]) {
        [iToast alertWithTitleCenter:@"至少包含字母、数字、字符中的 2 种"];
        return;
    }
    
    if ([self.emailTF.text removeFrontBackBlank].length == 0) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"tip.emailNotNull", @"")];
        return;
    }
    if (![[self.emailTF.text removeFrontBackBlank] validateEmail]) {
        [iToast alertWithTitleCenter:@"请输入正确格式的邮箱"];
        return;
    }
    if (!self.selectBtn.selected) {
        [iToast alertWithTitleCenter:@"同意《服务协议》《隐私权政策》后，方可注册"];
        return;
    }
    NSDictionary *param = @{@"email":[self.emailTF.text removeFrontBackBlank],@"mobile":[self.phoneTF.text removeFrontBackBlank],@"name":[self.nameTF.text removeFrontBackBlank],@"password":[self.passwordTF.text removeFrontBackBlank],@"marker":@"mobile",@"verificationCode":[self.codeTF.text removeFrontBackBlank]};
    [SVProgressHUD show];
    [userManager registerWithParam:param completion:^(CodeStatus status, NSString *des) {
        
    }];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.passwordTF]) {
        if (![[textField.text removeFrontBackBlank] validatePassWordForm]) {
            self.passwordTipLab.hidden = NO;
        }else{
            self.passwordTipLab.hidden = YES;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([textField isEqual:self.phoneTF]) {
        [self.codeTF becomeFirstResponder];
    }
    if([textField isEqual:self.codeTF]){
        [self.nameTF becomeFirstResponder];
    }
    if ([textField isEqual:self.nameTF]) {
        [self.passwordTF becomeFirstResponder];
    }
    if ([textField isEqual:self.passwordTF]) {
        [self.emailTF becomeFirstResponder];
    }
    
    return YES;
}
- (void)passwordBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)getCodeBtnClick{
    WeakSelf
    if ([[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] validatePhoneNumber]) {
        [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] checkRegisterWithPhone:[self.phoneTF.text removeFrontBackBlank] callBack:^(id response) {
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                VerificationCodeNetWork *code = [[VerificationCodeNetWork alloc]init];
                [code VerificationCodeWithType:VerifyCodeVCTypeLogin phone:[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] uuid:@"" successBlock:^(id response) {
                    [SVProgressHUD dismiss];
                    if ([response[ERROR_CODE] isEqualToString:@""]) {
                        if (@available(iOS 10.0, *)) {
                            if(self.second == 60){
                                self.getCodeBtn.enabled = NO;
                                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                                    [weakSelf timerRun];
                                }];
                            }else{
                                self.second = 60;
                                [weakSelf.timer setFireDate:[NSDate distantPast]];
                            }
                        } else {
                            self.timer = [NSTimer timerWithTimeInterval:1.0 target:[PWWeakProxy proxyWithTarget:self] selector:@selector(timerRun) userInfo:nil repeats:YES];
                            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
                        }
                        //对前后台状态进行监听
                        [self observeApplicationActionNotification];
                    }else{
                        [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
                    }
                } failBlock:^(NSError *error) {
                    [SVProgressHUD dismiss];
                }];
            }else{
                [SVProgressHUD dismiss];
                if ([model.errorCode isEqualToString:@"home.auth.alreadyRegister"]) {
                    [iToast alertWithTitleCenter:NSLocalizedString(@"login.auth.alreadyRegister", @"")];
                }else{
                     [iToast alertWithTitleCenter:model.errorMsg];
                }
            }
        }];
       
    }else{
        [iToast alertWithTitleCenter:NSLocalizedString(@"tip.enterCorrectPhoneNumber", @"")];
    }

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
#pragma mark ========== 倒计时展示/重新发送 ==========
- (void)timerRun{
    if (self.second>0) {
        self.second--;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ldS后重发",(long)self.second] forState:UIControlStateNormal];
    }else if(self.second == 0){
        self.getCodeBtn.enabled = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }
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
