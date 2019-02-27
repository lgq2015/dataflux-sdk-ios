//
//  BindEmailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BindEmailOrPhoneVC.h"
#import "PersonalInfoVC.h"
@interface BindEmailOrPhoneVC ()
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
    //_emailTF.placeholder = @"请输入邮箱";

    if (self.isEmail) {
        if (self.isFirst) {
            placeholder = @"请输入邮箱";
        }else{
            placeholder = @"请输入新邮箱";
        }
        title =@"修改手机";
    }else{
        title = @"绑定邮箱";
        placeholder = @"请输入新的手机号";
    }
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), kTopHeight+Interval(16), ZOOM_SCALE(120), ZOOM_SCALE(37)) font:BOLDFONT(26) textColor:PWTextBlackColor text:title];
    [self.view addSubview:titleLab];
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(ZOOM_SCALE(53));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_left);
        make.top.mas_equalTo(self.emailTF.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.emailTF.mas_right);
        make.height.offset(ZOOM_SCALE(1));
    }];
    self.emailTF.placeholder = placeholder;
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(line1.mas_bottom).offset(Interval(42));
        make.height.offset(ZOOM_SCALE(47));
    }];
   
    RACSignal *emailSignal= [[self.emailTF rac_textSignal] map:^id(NSString *value) {
        if (self.isEmail) {
           return @(value.length>4);
        }else{
            
            self.emailTF.text = value;
            self.temp = value;
            if (value.length>13) {
                value = [value substringToIndex:13];
                self.emailTF.text = [value substringToIndex:13];
                self.temp = [value substringToIndex:13];
            }
//            if (value.length>0) {
//                if(![self validateNumber:[value substringFromIndex:value.length-1]]){
//                    value = [value substringToIndex:value.length-1];
//                    self.emailTF.text = value;
//                    self.temp = value;
//                }
//            }
            if((value.length == 3 || value.length == 8 )){
                if (value.length<self.temp.length) {
                    value =[value substringToIndex:value.length-1];
                }else{
                    value = [NSString stringWithFormat:@"%@ ", value];
                }
            }
            return @([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 11);
        }
    }];
    RAC(self.commitBtn,enabled) = emailSignal;
    
    RAC(self.commitBtn, backgroundColor) = [emailSignal map: ^id (id value){
        if([value boolValue]){
            return PWBlueColor;
        }else{
            return [UIColor colorWithHexString:@"C7C7CC"];;
        }
    }];
}
-(UITextField *)emailTF{
    if (!_emailTF) {
        _emailTF = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _emailTF.keyboardType = UIKeyboardTypeDefault;
        [self.view addSubview:_emailTF];
    }
    return _emailTF;
}
-(UIButton *)commitBtn{
    if(!_commitBtn){
        _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(377), ZOOM_SCALE(280), ZOOM_SCALE(44))];
        [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_commitBtn setBackgroundColor:PWBlueColor];
        _commitBtn.enabled = NO;
        _commitBtn.layer.cornerRadius = ZOOM_SCALE(5);
        _commitBtn.layer.masksToBounds = YES;
        [self.view addSubview:_commitBtn];
    }
    return _commitBtn;
}
- (void)commitBtnClick{
     BOOL isemail = [NSString validateEmail:self.emailTF.text];
    if (isemail) {
        NSDictionary *param = @{@"data":@{@"username":self.emailTF.text,@"uType":@"email",@"uuid":self.uuid}};
        [PWNetworking requsetWithUrl:PW_verifycodesend withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
            if ([response[@"errCode"] isEqualToString:@""]) {
                for(UIViewController *temp in self.navigationController.viewControllers) {
                    if([temp isKindOfClass:[PersonalInfoVC class]]){
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
                [iToast alertWithTitleCenter:@"绑定成功"];
            }else if([response[@"message"] isEqualToString:@"Email Exists"]){
                [iToast alertWithTitleCenter:@"该邮箱号已被绑定"];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }else{
        [iToast alertWithTitleCenter:@"请输入正确的邮箱"];
    }
 
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
