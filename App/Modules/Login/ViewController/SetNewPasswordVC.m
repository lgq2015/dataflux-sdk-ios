//
//  SetNewPasswordVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/16.
//  Copyright © 2018 hll. All rights reserved.
//

#import "SetNewPasswordVC.h"
#import "OpenUDID.h"
#import "LoginPasswordVC.h"
#import "SecurityPrivacyVC.h"
#import "JPUSHService.h"

@interface SetNewPasswordVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *showWordsBtn;
@end

@implementation SetNewPasswordVC
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =self;
        
    }}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(16)+kTopHeight, ZOOM_SCALE(200), ZOOM_SCALE(37)) font:BOLDFONT(26) textColor:PWTextBlackColor text:@"输入新密码"];
    [self.view addSubview:titleLab];
    UILabel *tipLab= [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(60)+kTopHeight, ZOOM_SCALE(300), ZOOM_SCALE(52)) font:MediumFONT(18) textColor:PWTitleColor text:@"新密码格式至少包含两种 8-25 位\n大小写字母、数字或字符"];
    tipLab.numberOfLines = 2;
    [self.view addSubview:tipLab];
    if (!_passwordTf) {
        _passwordTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _passwordTf.secureTextEntry = YES;
        _passwordTf.placeholder = @"请输入密码";
        _passwordTf.clearButtonMode=UITextFieldViewModeNever;

        [self.view addSubview:_passwordTf];
    }
   [self.showWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(tipLab.mas_bottom).offset(ZOOM_SCALE(87));
        make.width.height.offset(ZOOM_SCALE(24));
    }];
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.showWordsBtn.mas_left);
        make.centerY.mas_equalTo(self.showWordsBtn);
        make.height.offset(ZOOM_SCALE(25));
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(self.passwordTf.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.view).offset(Interval(-16));
        make.height.offset(ZOOM_SCALE(1));
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(Interval(-16));
        make.top.mas_equalTo(line.mas_bottom).offset(Interval(42));
        make.height.offset(ZOOM_SCALE(47));
    }];
    RACSignal *passwordSignal= [[self.passwordTf rac_textSignal] map:^id(NSString *value) {
        return @(value.length>7);
    }];
    RAC(self.confirmBtn,enabled) = passwordSignal;
    RAC(self.confirmBtn, backgroundColor) = [passwordSignal map: ^id (id value){
        if([value boolValue]){
            return PWBlueColor;
        }else{
            return [UIColor colorWithHexString:@"C7C7CC"];
        }
    }];
}
-(UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setBackgroundColor:PWBlueColor];
        _confirmBtn.enabled = NO;
        _confirmBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _confirmBtn.layer.masksToBounds = YES;
        [self.view addSubview:_confirmBtn];
    }
    return _confirmBtn;
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
- (void)confirmBtnClick{
    if ([self.passwordTf.text validatePassWordForm]) {
   
    NSString *os_version =  [[UIDevice currentDevice] systemVersion];
    NSString *openUDID = [OpenUDID value];
    NSString *device_version = [NSString getCurrentDeviceModel];
    NSString *registrationId = [JPUSHService registrationID];

    NSDictionary *params = @{@"data":@{@"password":self.passwordTf.text,@"changePasswordToken":self.changePasswordToken,@"marker":@"mobile",@"deviceId": openUDID,@"registrationId":registrationId,@"deviceOSVersion": os_version,@"deviceVersion":device_version}};
    [PWNetworking requsetWithUrl:PW_changePassword withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            setXAuthToken(response[@"content"][@"authAccessToken"]);
            if(self.isChange){
            [userManager saveUserInfoLoginStateisChange:NO success:nil];
            [iToast alertWithTitleCenter:@"修改密码成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for(UIViewController *temp in self.navigationController.viewControllers) {
                        if([temp isKindOfClass:[SecurityPrivacyVC class]]){
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                });
            }else{
            [userManager saveUserInfoLoginStateisChange:YES success:nil];
            }
        }else{
            [iToast alertWithTitleCenter:response[@"message"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
    }else{
        [iToast alertWithTitleCenter:@"密码格式有误"];
    }
}
- (void)pwdTextSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    UITextField *tf = self.passwordTf;
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = tf.text;
        tf.text = @""; // 这句代码可以防止切换的时候光标偏移
        tf.secureTextEntry = NO;
        tf.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = tf.text;
        tf.text = @"";
        tf.secureTextEntry = YES;
        tf.text = tempPwdStr;
    }
}
-(void)backBtnClicked{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定放弃设置新密码吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =nil;
        }
        if (self.isChange) {
            for(UIViewController *temp in self.navigationController.viewControllers) {
                if([temp isKindOfClass:[SecurityPrivacyVC class]]){
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
        for(UIViewController *temp in self.navigationController.viewControllers) {
            if([temp isKindOfClass:[LoginPasswordVC class]]){
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        }
    }];
    [alert addAction:cancle];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    return NO;
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
