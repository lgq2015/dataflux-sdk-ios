//
//  PasswordVerifyVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PasswordVerifyVC.h"

@interface PasswordVerifyVC ()
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *showWordsBtn;

@end

@implementation PasswordVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), kTopHeight+Interval(16), ZOOM_SCALE(120),ZOOM_SCALE(37)) font:BOLDFONT(26) textColor:PWTextBlackColor text:@"密码验证"];
    [self.view addSubview:title];
    UILabel *subTitle = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTitleColor text:@"您的登录账号为"];
    [self.view addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(Interval(7));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    NSString *phone = [NSString stringWithFormat:@"%@******%@",[self.phoneNumber substringToIndex:3],[self.phoneNumber substringFromIndex:9]];
    UILabel *phoneLable = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:phone];
    [self.view addSubview:phoneLable];
    [phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subTitle.mas_bottom).offset(Interval(6));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
