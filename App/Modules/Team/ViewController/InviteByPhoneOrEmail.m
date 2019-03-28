//
//  InviteByPhoneOrEmail.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InviteByPhoneOrEmail.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface InviteByPhoneOrEmail ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, copy) NSString *temp;
@end

@implementation InviteByPhoneOrEmail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.isPhone == YES?@"手机号邀请":@"邮箱邀请";
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    NSDictionary *dict ;
    if (self.isPhone) {
        dict = @{@"title":@"手机号",@"placeholder":@"请输入邀请成员手机号码"};
    }else{
        dict = @{@"title":@"邮箱",@"placeholder":@"请输入邀请成员邮箱"};
    }
    UIView *item = [self itemWithData:dict];
    [self.view addSubview:item];
    UIButton *commitTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"确认邀请"];
    commitTeam.enabled = NO;
    [commitTeam addTarget:self action:@selector(commitTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitTeam];
    [commitTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(item.mas_bottom).offset(Interval(137));
        make.height.offset(ZOOM_SCALE(47));
    }];
    if(self.isPhone){
        self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
        self.codeTF.delegate = self;
        RACSignal *phoneTf= [[self.codeTF rac_textSignal] map:^id(NSString *value) {
            if((value.length == 3 || value.length == 8 )){
                if (value.length<self.temp.length) {
                    value =[value substringToIndex:value.length-1];
                }else{
                    value = [NSString stringWithFormat:@"%@ ", value];
                }
            }
            self.codeTF.text = value;
            self.temp = value;
            if (value.length>13) {
                value = [value substringToIndex:13];
                self.codeTF.text = [value substringToIndex:13];
                self.temp = [value substringToIndex:13];
            }
            return @([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 11);
        }];
         RAC(commitTeam,enabled) = phoneTf;
    }else{
        RACSignal *emailSignal= [[self.codeTF rac_textSignal] map:^id(NSString *value) {
            return @(value.length>0);
        }];
        RAC(commitTeam,enabled) = emailSignal;
    }
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
      [self.codeTF becomeFirstResponder];
    
}
- (UIView *)itemWithData:(NSDictionary *)dict{
    UIView *item = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, ZOOM_SCALE(65))];
    item.backgroundColor = PWWhiteColor;
    [self.view addSubview:item];
    UILabel *titel = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(8), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:MediumFONT(14) textColor:PWTitleColor text:dict[@"title"]];
    [item addSubview:titel];
    self.codeTF = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), Interval(14)+ZOOM_SCALE(20), kWidth-Interval(32), ZOOM_SCALE(22))];
    self.codeTF.placeholder = dict[@"placeholder"];
   
    [item addSubview:self.codeTF];
    return item;
}
- (void)commitTeamClick{
    NSDictionary *param ;
    if (self.isPhone) {
        param = @{@"data":@{@"invite_type":@"mobile",@"invite_id":[self.codeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""]}};
    }else{
        BOOL  isEmail = [self.codeTF.text validateEmail];
        if (isEmail == NO){
            [iToast alertWithTitleCenter:@"邮箱格式错误"];
            return;
        }
        param = @{@"data":@{@"invite_type":@"email",@"invite_id":self.codeTF.text}};
    }
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_teamInvite withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            [SVProgressHUD showSuccessWithStatus:@"邀请成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"邀请失败"];

    }];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
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
-(void)viewDidDisappear:(BOOL)animated{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
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
