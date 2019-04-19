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
#import "VerifyCodeVC.h"
#import "VerificationCodeNetWork.h"
#define phoneLabTag  55

@interface VerifyCodeLoginVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UIButton *verifyCodeBtn;
@property (nonatomic, strong) UIButton *passwordBtn;
@property (nonatomic, strong) NSString *temp;

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
        make.top.mas_equalTo(self.view).offset(Interval(kStatusBarHeight+16));
        make.height.offset(ZOOM_SCALE(22));
    }];
      UILabel  *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(53)+kStatusBarHeight, kWidth, ZOOM_SCALE(37))];
      titleLab.font = MediumFONT(26);
      titleLab.text = @"您好，";
      titleLab.textColor = PWTextBlackColor;
      titleLab.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:titleLab];
     UILabel  *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(101)+kStatusBarHeight, kWidth, ZOOM_SCALE(37))];
     titleLab2.font = MediumFONT(26);
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
    UILabel *phoneTip = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:@"手机号"];
    phoneTip.tag = phoneLabTag;
    phoneTip.hidden = YES;
    [self.view addSubview:phoneTip];
    [phoneTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.bottom.mas_equalTo(self.phoneTf.mas_top).offset(-Interval(5));
        make.height.offset(ZOOM_SCALE(20));
    }];
    
    [self.verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(line1.mas_bottom).offset(ZOOM_SCALE(42));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    UILabel *tip = [[UILabel alloc]init];
    tip.text = @"未注册的手机，验证后即完成注册";
    tip.font = RegularFONT(14);
    tip.textColor = [UIColor colorWithHexString:@"8E8E93"];
    tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(self.verifyCodeBtn.mas_bottom).offset(ZOOM_SCALE(12));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(20));
    }];

/*
 if((value.length == 3 || value.length == 8 )){
 if (value.length<self.temp.length) {
 value =[value substringToIndex:value.length-1];
 }else{
 value = [NSString stringWithFormat:@"%@ ", value];
 }
 }
 self.phoneTf.text = value;
 self.temp = value;
 if (value.length>13) {
 value = [value substringToIndex:13];
 self.phoneTf.text = [value substringToIndex:13];
 self.temp = [value substringToIndex:13];
 }
 */
      self.phoneTf.delegate = self;
      RACSignal *phoneTf= [[self.phoneTf rac_textSignal] map:^id(NSString *value) {
          NSString *num =[value stringByReplacingOccurrencesOfString:@" " withString:@""];
          [self dealTFText:num];
          return @(num.length >= 11);
    }];
   
    RAC(self.verifyCodeBtn,enabled) = phoneTf;
    RAC(self.verifyCodeBtn, backgroundColor) = [phoneTf map: ^id (id value){
        if([value boolValue]){
            self.verifyCodeBtn.enabled = YES;
            return PWBlueColor;
        }else{
            self.verifyCodeBtn.enabled = NO;
            return [UIColor colorWithHexString:@"C7C7CC"];;
        }
    }];
}
- (void)dealTFText:(NSString *)text{
    if (text.length>11) {
         [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
        text = [text substringToIndex:11];
        self.phoneTf.text = [NSString stringWithFormat:@"%@ %@ %@",[text substringToIndex:3],[text substringWithRange:NSMakeRange(3, 4)],[text substringFromIndex:7]];
    }else if(text.length>7){
        self.phoneTf.text = [NSString stringWithFormat:@"%@ %@ %@",[text substringToIndex:3],[text substringWithRange:NSMakeRange(3, 4)],[text substringFromIndex:7]];
    }else if(text.length>3){
        self.phoneTf.text = [NSString stringWithFormat:@"%@ %@",[text substringToIndex:3],[text substringFromIndex:3]];
    }else{
        self.phoneTf.text = text;
    }
}
-(UITextField *)phoneTf{
    if (!_phoneTf) {
        _phoneTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _phoneTf.placeholder = @"请输入手机号";
        _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTf.clearButtonMode=UITextFieldViewModeNever;
        [self.view addSubview:_phoneTf];
    }
    return _phoneTf;
}
-(UIButton *)passwordBtn{
    if (!_passwordBtn) {
        _passwordBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"密码登录"];
        [_passwordBtn addTarget:self action:@selector(passwordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _passwordBtn.titleLabel.font = RegularFONT(16);
        [_passwordBtn setTitleColor:PWTextColor forState:UIControlStateNormal];
        [self.view addSubview:_passwordBtn];
    }
    return _passwordBtn;
}
-(UIButton *)verifyCodeBtn{
    if(!_verifyCodeBtn){
        _verifyCodeBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"获取验证码"];
        [_verifyCodeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        _verifyCodeBtn.enabled = NO;
        [self.view addSubview:_verifyCodeBtn];
    }
    return _verifyCodeBtn;
}
#pragma mark ========== 跳转密码登录 ==========
- (void)passwordBtnClick{
    LoginPasswordVC *login = [[LoginPasswordVC alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark ========== 获取验证码 ==========
- (void)getVerifyCode{
    if ([[self.phoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""] validatePhoneNumber]) {
    VerificationCodeNetWork *code = [[VerificationCodeNetWork alloc]init];
    [code VerificationCodeWithType:VerifyCodeVCTypeLogin phone:[self.phoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""] uuid:@"" successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            VerifyCodeVC *codeVC = [[VerifyCodeVC alloc]init];
            codeVC.type = VerifyCodeVCTypeLogin;
            codeVC.isHidenNaviBar = YES;
            codeVC.isShowCustomNaviBar = YES;
            codeVC.phoneNumber = [self.phoneTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            [self.navigationController pushViewController:codeVC animated:YES];
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
    } failBlock:^(NSError *error) {
        
    }];
    }else{
        [iToast alertWithTitleCenter:@"请输入正确的手机号码"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}
#pragma mark ========== <UITextFieldDelegate> ==========
-(void)textFieldDidBeginEditing:(UITextField *)textField{
        [self.view viewWithTag:phoneLabTag].hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
        [self.view viewWithTag:phoneLabTag].hidden = textField.text.length>0? NO:YES;
}
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
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
