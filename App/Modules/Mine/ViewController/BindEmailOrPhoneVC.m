//
//  BindEmailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BindEmailOrPhoneVC.h"
#import "PersonalInfoVC.h"
#import "VerifyCodeVC.h"
#import "ChangeUserInfoVC.h"
#import "UITextField+HLLHelper.h"

#define tipLabTag 88
@interface BindEmailOrPhoneVC ()<UITextFieldDelegate>
@property (nonatomic ,strong) UITextField *emailTF;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) NSString *temp;

@end

@implementation BindEmailOrPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    NSString *title;
    NSString *placeholder;
    NSString *tipTitle;
    switch (self.changeType) {
        case BindUserInfoTypeEmail:
            if (self.isFirst) {
                placeholder = @"请输入邮箱";
            }else{
                placeholder = @"请输入新邮箱";
            }
            title = @"绑定邮箱";
            tipTitle = @"邮箱";
            break;
        case BindUserInfoTypeName:
            title =@"修改姓名";
            if (self.isFirst) {
                placeholder = @"请输入姓名";
            }else{
                placeholder = @"请输入新的姓名";
            }
            tipTitle = @"姓名";
            self.emailTF.text = userManager.curUserInfo.name;
            [self.emailTF becomeFirstResponder];
            break;
        case BindUserInfoTypeMobile:
            title =@"修改手机";
            placeholder = @"请输入新的手机号";
            tipTitle = @"手机号";
            break;
    }

    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(36), kTopHeight+Interval(46), ZOOM_SCALE(120), ZOOM_SCALE(37)) font:MediumFONT(26) textColor:PWTextBlackColor text:title];
    
    [self.view addSubview:titleLab];
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(Interval(70));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWSubTitleColor text:tipTitle];
    tipLab.tag = tipLabTag;
    tipLab.hidden = YES;
    [self.view addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(Interval(40));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(tipLab.mas_bottom).offset(ZOOM_SCALE(10));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.height.offset(ZOOM_SCALE(21));
    }];
    tipLab.hidden = YES;
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(self.emailTF.mas_bottom).offset(10);
        make.right.mas_equalTo(self.emailTF.mas_right);
        make.height.offset(SINGLE_LINE_WIDTH);
    }];
    self.emailTF.placeholder = placeholder;
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(36));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.top.mas_equalTo(line1.mas_bottom).offset(Interval(42));
        make.height.offset(ZOOM_SCALE(44));
    }];
   
    if (self.changeType == BindUserInfoTypeEmail) {
        RACSignal *emailSignal= [[self.emailTF rac_textSignal] map:^id(NSString *value) {
                return @(value.length>4);
        }];
        RAC(self.commitBtn,enabled) = emailSignal;
        
    }else if(self.changeType == BindUserInfoTypeMobile){
        [self.commitBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.emailTF.keyboardType = UIKeyboardTypeNumberPad;
        RACSignal *phoneSignal= [[self.emailTF rac_textSignal] map:^id(NSString *value) {
            
                if (value.length>13) {
                    value = [value substringToIndex:13];
                    self.emailTF.text = [value substringToIndex:13];
                    self.temp = [value substringToIndex:13];
                }
                if((value.length == 3 || value.length == 8 )){
                    if (value.length<self.temp.length) {
                        value =[value substringToIndex:value.length-1];
                    }else{
                        value = [NSString stringWithFormat:@"%@ ", value];
                    }
                }
                self.temp = value;
                self.emailTF.text = value;
                return @([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 11);
        }];
        RAC(self.commitBtn,enabled) = phoneSignal;
    }else{

        self.emailTF.hll_limitTextLength = 30;
         [self.commitBtn setTitle:@"保存" forState:UIControlStateNormal];
        RACSignal *emailSignal= [[self.emailTF rac_textSignal] map:^id(NSString *value) {
    
            return @([value stringByReplacingOccurrencesOfString:@" " withString:@""].length>0);
        }];
        RAC(self.commitBtn,enabled) = emailSignal;
    }
}
-(void)backBtnClicked{
    BOOL isHave = NO;
    for(UIViewController *temp in self.navigationController.viewControllers) {
        if([temp isKindOfClass:[ChangeUserInfoVC class]]){
            isHave =YES;
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    if (isHave == NO) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UITextField *)emailTF{
    if (!_emailTF) {
        _emailTF = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _emailTF.delegate = self;
        _emailTF.keyboardType = UIKeyboardTypeDefault;
        _emailTF.spellCheckingType = UITextSpellCheckingTypeNo;// 禁用拼写检查
        [self.view addSubview:_emailTF];
    }
    return _emailTF;
}
-(UIButton *)commitBtn{
    if(!_commitBtn){
        _commitBtn = [PWCommonCtrl buttonWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(377), ZOOM_SCALE(280), ZOOM_SCALE(44)) type:PWButtonTypeContain text:@"确定"];
        [_commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.enabled = NO;
        [self.view addSubview:_commitBtn];
    }
    return _commitBtn;
}
- (void)commitBtnClick{
    switch (self.changeType) {
        case BindUserInfoTypeEmail:
           [self commitEmailClick];
            break;
        case BindUserInfoTypeName:
            [self commitNameClick];
            break;
        case BindUserInfoTypeMobile:
            [self commitPhoneClick];
            break;
    }
   
}
- (void)commitEmailClick{
     BOOL isemail = [self.emailTF.text validateEmail];
    if (isemail) {
        [SVProgressHUD show];
        NSDictionary *param = @{@"data":@{@"username":self.emailTF.text,@"uType":@"email",@"uuid":self.uuid}};
        [PWNetworking requsetHasTokenWithUrl:PW_verifycodesend withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [iToast alertWithTitleCenter:@"绑定成功"];
                userManager.curUserInfo.email = self.emailTF.text;
                KPostNotification(KNotificationUserInfoChange, nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for(UIViewController *temp in self.navigationController.viewControllers) {
                        if([temp isKindOfClass:[PersonalInfoVC class]]){
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                });
            }else{
                if ([response[ERROR_CODE] isEqualToString:@"home.auth.invalidIdentityToken"]) {
                    [iToast alertWithTitleCenter:@"身份验证已过期，请重新验证"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        for(UIViewController *temp in self.navigationController.viewControllers) {
                            if([temp isKindOfClass:[ChangeUserInfoVC class]]){
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                        }
                    });
                }else{
                [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
                }}
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [iToast alertWithTitleCenter:@"请输入正确的邮箱"];
        }];
    }else{
        [iToast alertWithTitleCenter:@"请输入正确的邮箱"];
    }
 
}
- (void)naviSkip{
    
}
- (void)commitPhoneClick{
    if (![[self.emailTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] validatePhoneNumber]) {
        [iToast alertWithTitleCenter:@"请输入正确的手机号码"];
        return;
    }
    NSDictionary *param = @{@"data":@{@"username":[self.emailTF.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"uType":@"mobile",@"uuid":self.uuid}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodesend withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            VerifyCodeVC *verify = [[VerifyCodeVC alloc]init];
            verify.type = VerifyCodeVCTypeUpdateMobileNewMobile;
            verify.isShowCustomNaviBar = YES;
            verify.phoneNumber =[self.emailTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            verify.uuid = self.uuid;
            [self.navigationController pushViewController:verify animated:YES];
        }else {
            if ([response[ERROR_CODE] isEqualToString:@"home.account.mobileExists"]) {
                [iToast alertWithTitleCenter:@"该手机号已被注册"];
            }else if ([response[ERROR_CODE] isEqualToString:@"home.auth.invalidIdentityToken"]) {
                [iToast alertWithTitleCenter:@"身份验证已过期，请重新验证"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for(UIViewController *temp in self.navigationController.viewControllers) {
                        if([temp isKindOfClass:[ChangeUserInfoVC class]]){
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                });
            }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
            }
        }
    } failBlock:^(NSError *error) {
//        [iToast alertWithTitleCenter:@"绑定失败"];
        
    }];
}
- (void)commitNameClick{
    [SVProgressHUD show];
    NSDictionary *param =@{@"data":@{@"name":[self.emailTF.text removeFrontBackBlank]}};
    [PWNetworking requsetHasTokenWithUrl:PW_accountName withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            userManager.curUserInfo.name = [self.emailTF.text removeFrontBackBlank];
            [userManager saveChangeUserInfo];
            KPostNotification(KNotificationUserInfoChange, nil);
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self.navigationController popViewControllerAnimated:YES];
            });
           
        }else{
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
         [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
}
#pragma mark ========== <UITextFieldDelegate> ==========

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(self.changeType == BindUserInfoTypeMobile){
    return [string validateNumber];
    }else if(self.changeType == BindUserInfoTypeName){
        if (![string isEqualToString:@""]) {
          return [string validateSpecialCharacter];
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view viewWithTag:tipLabTag].hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view viewWithTag:tipLabTag].hidden = textField.text.length>0? NO:YES;
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
