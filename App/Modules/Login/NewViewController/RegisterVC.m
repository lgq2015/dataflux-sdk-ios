//
//  RegisterVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *registerBtn;
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
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(phoneIcon.frame)+Interval(10), kWidth-Interval(72), 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line1];
    
    UIImageView *passwordIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_code"]];
    [self.view addSubview:passwordIcon];
    passwordIcon.frame = CGRectMake(Interval(36), CGRectGetMaxY(line1.frame)+Interval(24), ZOOM_SCALE(20), ZOOM_SCALE(20));
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(Interval(36), CGRectGetMaxY(passwordIcon.frame)+Interval(10), kWidth-Interval(72), 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.view addSubview:line2];
    
  
    
    self.phoneTF.frame = CGRectMake(CGRectGetMaxX(phoneIcon.frame)+12, 0, kWidth-Interval(48)-CGRectGetMaxX(phoneIcon.frame), ZOOM_SCALE(21));
    self.phoneTF.centerY = phoneIcon.centerY;
    self.codeTF.frame = CGRectMake(CGRectGetMaxX(phoneIcon.frame)+12, 0, kWidth-CGRectGetMaxX(phoneIcon.frame)-Interval(48), ZOOM_SCALE(21));
    self.codeTF.centerY = passwordIcon.centerY;
   

}


-(UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _phoneTF.placeholder = @"请输入手机号";
        [self.view addSubview:_phoneTF];
    }
    return _phoneTF;
}
-(UITextField *)codeTF{
    if (!_codeTF) {
        _codeTF = [PWCommonCtrl passwordTextFieldWithFrame:CGRectZero font:RegularFONT(15)];
        _codeTF.placeholder = @"请输入验证码";
        [self.view addSubview:_codeTF];
    }
    return _codeTF;
}
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeSummarize text:@"注册"];
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerBtn];
    }
    return _registerBtn;
}
- (void)registerBtnClick{
    
}
- (void)passwordBtnClick{
    
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
