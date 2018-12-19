//
//  SetNewPasswordVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/16.
//  Copyright © 2018 hll. All rights reserved.
//

#import "SetNewPasswordVC.h"

@interface SetNewPasswordVC ()
@property (nonatomic, strong) UIImageView *passwordImg;
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation SetNewPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWWhiteColor;
    self.title = @"找回密码";
    [self createUI];
}
- (void)createUI{
    if (!_passwordImg) {
        _passwordImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(58), ZOOM_SCALE(20), ZOOM_SCALE(20))];
        _passwordImg.image = [UIImage imageNamed:@"icon_password"];
        [self.view addSubview:_passwordImg];
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
        make.right.mas_equalTo(ZOOM_SCALE(290));
        make.height.offset(ZOOM_SCALE(20));
    }];
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(90), ZOOM_SCALE(280), 1)];
        _line.backgroundColor = PWBlackColor;
        _line.alpha = 0.05;
        [self.view addSubview:_line];
    }
    
    if(!_confirmBtn){
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(131), ZOOM_SCALE(280), ZOOM_SCALE(44))];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.enabled = YES;
        _confirmBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.backgroundColor = PWBtnEnableColor;
        [self.view addSubview:_confirmBtn];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.passwordTf resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)confirmClick{
    
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
