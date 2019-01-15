//
//  FindPasswordVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "FindPasswordVC.h"
#import "SetNewPasswordVC.h"
@interface FindPasswordVC ()
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UITextField *userTf;
@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UIImageView *verifyCodeImg;
@property (nonatomic, strong) UITextField *verifyCodeTf;
@property (nonatomic, strong) UIButton *verifyCodeBtn;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) UIButton *nextSetPasswordBtn;

@end

@implementation FindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWWhiteColor;
    self.isShowLiftBack = YES;
    self.title = @"找回密码";
    [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
    if (!_userImg) {
        _userImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(57), ZOOM_SCALE(20), ZOOM_SCALE(20))];
        _userImg.image = [UIImage imageNamed:@"icon_account"];
        [self.view addSubview:_userImg];
    }
    if (!_userTf) {
        _userTf = [PWCommonCtrl textFieldWithFrame:CGRectMake(ZOOM_SCALE(70), ZOOM_SCALE(58), ZOOM_SCALE(250), ZOOM_SCALE(20))];
        _userTf.placeholder = @"请输入手机号/邮箱";
        _userTf.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_userTf];
    }
    if (!_line1){
        _line1 = [[UIView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(90), ZOOM_SCALE(280), 1)];
        _line1.backgroundColor = PWBlackColor;
        _line1.alpha = 0.05;
        [self.view addSubview:_line1];
    }
    if (!_verifyCodeImg) {
        _verifyCodeImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(118), ZOOM_SCALE(20), ZOOM_SCALE(20))];
        _verifyCodeImg.image = [UIImage imageNamed:@"icon_code"];
        [self.view addSubview:_verifyCodeImg];
    }
    if (!_verifyCodeBtn) {
        _verifyCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(240), ZOOM_SCALE(117), ZOOM_SCALE(70), ZOOM_SCALE(21))];
        [_verifyCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_verifyCodeBtn setTitleColor:PWOrangeTextColor forState:UIControlStateNormal];
        _verifyCodeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 14];
        [_verifyCodeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_verifyCodeBtn];
    }
    if (!_verifyCodeTf) {
        _verifyCodeTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _verifyCodeTf.secureTextEntry = YES;
        _verifyCodeTf.placeholder = @"请输入验证码";
        [self.view addSubview:_verifyCodeTf];
    }
    [_verifyCodeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyCodeImg.mas_right).offset(ZOOM_SCALE(10));
        make.top.equalTo(self.verifyCodeImg);
        make.right.equalTo(self.verifyCodeBtn.mas_left).offset(-ZOOM_SCALE(10));
        make.height.offset(ZOOM_SCALE(20));
    }];
    if (!_line2) {
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(147), ZOOM_SCALE(280), 1)];
        _line2.backgroundColor = PWBlackColor;
        _line2.alpha = 0.05;
        [self.view addSubview:_line2];
    }
    
    if(!_nextSetPasswordBtn){
        _nextSetPasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(188), ZOOM_SCALE(280), ZOOM_SCALE(44))];
        [_nextSetPasswordBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextSetPasswordBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _nextSetPasswordBtn.enabled = YES;
        _nextSetPasswordBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _nextSetPasswordBtn.layer.masksToBounds = YES;
        _nextSetPasswordBtn.backgroundColor = PWBtnEnableColor;
        [self.view addSubview:_nextSetPasswordBtn];
    }
    
}
#pragma mark ========== 获取验证码 ==========
- (void)getVerifyCode{
    BOOL isPhone = [NSString validateCellPhoneNumber:self.userTf.text];
    BOOL isEmail = [NSString validateEmail:self.userTf.text];
    if (!(isEmail || isPhone)) {
        [iToast alertWithTitleCenter:@"请输入正确的手机号/邮箱"];
    }else{
      
    }
    
}
#pragma mark ========== 下一步 ==========
- (void)nextBtnClick{
    SetNewPasswordVC *setVC = [[SetNewPasswordVC alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.userTf resignFirstResponder];
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
