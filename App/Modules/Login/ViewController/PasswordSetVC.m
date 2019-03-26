//
//  PasswordSetVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PasswordSetVC.h"
#import "OpenUDID.h"
#import "JPUSHService.h"
@interface PasswordSetVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIButton *showWordsBtn;
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation PasswordSetVC
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =self;
        
    }}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    [self createUI];
}
- (void)createUI{
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.view).offset(Interval(kStatusBarHeight+16));
        make.height.offset(ZOOM_SCALE(22));
    }];
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), kStatusBarHeight+Interval(53), ZOOM_SCALE(200), ZOOM_SCALE(37)) font:BOLDFONT(26) textColor:PWTextBlackColor text:@"密码设置"];
    [self.view addSubview:title];
    UILabel *subTitle = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), kStatusBarHeight+Interval(97), ZOOM_SCALE(300), ZOOM_SCALE(52)) font:MediumFONT(18) textColor:PWTitleColor text:@"密码格式为 8-25 位\n至少含字母、数字、字符 2 种 组合"];
    subTitle.numberOfLines = 2;
    [self.view addSubview:subTitle];
    [self.showWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(Interval(-16));
        make.top.mas_equalTo(subTitle.mas_bottom).offset(Interval(85));
        make.width.height.offset(ZOOM_SCALE(24));
    }];
    self.showWordsBtn.selected = NO;

    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.showWordsBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.showWordsBtn);
        make.height.offset(ZOOM_SCALE(25));
    }];
    UIView  *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordTf.mas_left);
        make.top.mas_equalTo(self.passwordTf.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(1));
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(line.mas_bottom).offset(Interval(42));
        make.height.offset(ZOOM_SCALE(47));
    }];
    RACSignal *phoneTf= [[self.passwordTf rac_textSignal] map:^id(NSString *value) {
        if(value.length>25){
            value = [value substringToIndex:25];
            self.passwordTf.text = value;
        }
        return @(value.length>=8?YES:NO);
    }];
    RAC(self.confirmBtn,enabled) = phoneTf;
    
    RAC(self.confirmBtn, backgroundColor) = [phoneTf map: ^id (id value){
        if([value boolValue]){
            return PWBlueColor;
        }else{
            return [UIColor colorWithHexString:@"C7C7CC"];;
        }
    }];
    
}
-(UITextField *)passwordTf{
    if (!_passwordTf) {
        _passwordTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _passwordTf.secureTextEntry = YES;
        _passwordTf.clearButtonMode=UITextFieldViewModeNever;
        [self.view addSubview:_passwordTf];
    }
    return _passwordTf;
}
-(UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.titleLabel.font = MediumFONT(16);
        [_skipBtn setTitleColor:PWTitleColor forState:UIControlStateNormal];
        [self.view addSubview:_skipBtn];
    }
    return _skipBtn;
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
- (void)confirmBtnClick{
    if ([self.passwordTf.text validatePassWordForm]) {
    NSString *os_version =  [[UIDevice currentDevice] systemVersion];
    NSString *openUDID = [OpenUDID value];
    NSString *device_version = [NSString getCurrentDeviceModel];
    NSString *registrationId = [JPUSHService registrationID];
    NSDictionary *params = @{@"data":@{@"password":self.passwordTf.text,@"changePasswordToken":self.changePasswordToken,@"marker":@"mobile", @"deviceId": openUDID,@"registrationId":registrationId,@"deviceOSVersion": os_version,@"deviceVersion":device_version}};
    [PWNetworking requsetWithUrl:PW_changePassword withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            setXAuthToken(response[@"content"][@"authAccessToken"]);
            [iToast alertWithTitleCenter:@"密码设置成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                KPostNotification(KNotificationLoginStateChange, @YES);
            });
        }else{
            [iToast alertWithTitleCenter:@"密码设置失败，请重试"];
//            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {
        
    }];
    }else{
        [iToast alertWithTitleCenter:@"密码格式有误"];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    return NO;
}
- (void)skipBtnClick{
//    [userManager  saveUserInfo];
    KPostNotification(KNotificationLoginStateChange, @YES);
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
