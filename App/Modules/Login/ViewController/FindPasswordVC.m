//
//  FindPasswordVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "FindPasswordVC.h"
#import "SetNewPasswordVC.h"
#import "VerifyCodeVC.h"
#import "VerificationCodeNetWork.h"

@interface FindPasswordVC ()
@property (nonatomic, strong) UITextField *userTf;

@property (nonatomic, strong) UIButton *veritfyCodeBtn;

@end

@implementation FindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
   
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(16)+kTopHeight, ZOOM_SCALE(200), ZOOM_SCALE(37)) font:BOLDFONT(26) textColor:PWTextBlackColor text:@"忘记密码"];
    [self.view addSubview:titleLab];
    UILabel *tipLab= [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(84)+kTopHeight, ZOOM_SCALE(150), ZOOM_SCALE(20)) font:MediumFONT(14) textColor:[UIColor colorWithHexString:@"8E8E93"] text:@"手机号/邮箱"];
    [self.view addSubview:tipLab];
    if (!_userTf) {
        _userTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _userTf.placeholder = @"请输入手机号/邮箱";
        _userTf.keyboardType = UIKeyboardTypeDefault;
        _userTf.clearButtonMode=UITextFieldViewModeNever;

        [self.view addSubview:_userTf];
    }
    [self.userTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(tipLab.mas_bottom).offset(Interval(8));
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(self.userTf.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.userTf.mas_right);
        make.height.offset(ZOOM_SCALE(1));
    }];
   
    [self.veritfyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(line.mas_bottom).offset(Interval(42));
        make.height.offset(ZOOM_SCALE(47));
    }];
    RACSignal *phoneTf= [[self.userTf rac_textSignal] map:^id(NSString *value) {
        if (value.length>0) {
            tipLab.hidden = NO;
        }else{
            tipLab.hidden = YES;
        }
        return @(value.length>0);
    }];
    RAC(self.veritfyCodeBtn,enabled) = phoneTf;
    
    RAC(self.veritfyCodeBtn, backgroundColor) = [phoneTf map: ^id (id value){
        if([value boolValue]){
            return PWBlueColor;
        }else{
            return [UIColor colorWithHexString:@"C7C7CC"];;
        }
    }];
    DLog(@"%@",self.userAcount);
    self.userTf.text = self.userAcount;
    if (self.userAcount.length>0) {
        self.veritfyCodeBtn.enabled = YES;
        self.veritfyCodeBtn.backgroundColor = PWBlueColor;
    }
}
-(UIButton *)veritfyCodeBtn{
    if(!_veritfyCodeBtn){
        _veritfyCodeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_veritfyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_veritfyCodeBtn addTarget:self action:@selector(veritfyCodeClick) forControlEvents:UIControlEventTouchUpInside];
        [_veritfyCodeBtn setBackgroundColor:PWBlueColor];
        _veritfyCodeBtn.enabled = NO;
        _veritfyCodeBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _veritfyCodeBtn.layer.masksToBounds = YES;
        [self.view addSubview:_veritfyCodeBtn];
    }
    return _veritfyCodeBtn;
}
#pragma mark ========== 获取验证码 ==========
- (void)veritfyCodeClick{
    if ( [self.userTf.text validatePhoneNumber]||[self.userTf.text validateEmail]) {
        VerificationCodeNetWork *code = [[VerificationCodeNetWork alloc]init];
        [code VerificationCodeWithType:VerifyCodeVCTypeFindPassword phone:self.userTf.text uuid:@"" successBlock:^(id response) {
            if([response[ERROR_CODE] isEqualToString:@""]){
                VerifyCodeVC *codeVC = [[VerifyCodeVC alloc]init];
                codeVC.isHidenNaviBar = YES;
                codeVC.isShowCustomNaviBar = YES;
                codeVC.type = VerifyCodeVCTypeFindPassword;
                codeVC.phoneNumber = self.userTf.text;
                [self.navigationController pushViewController:codeVC animated:YES];
            }else{
                [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
            }
        } failBlock:^(NSError *error) {
            
        }];

    }else{
        [iToast alertWithTitleCenter:@"手机号/邮箱有误"];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.userTf resignFirstResponder];
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
