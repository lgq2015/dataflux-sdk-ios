//
//  ChangePhoneNumVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChangePhoneNumVC.h"

@interface ChangePhoneNumVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) NSString *temp;

@end

@implementation ChangePhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self crateUI];
}
- (void)crateUI{
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(10, kTopHeight+Interval(16), ZOOM_SCALE(120), ZOOM_SCALE(37)) font:MediumFONT(26) textColor:PWTextBlackColor text:NSLocalizedString(@"local.ModifyThePhone", @"")];
    [self.view addSubview:title];
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(Interval(54));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTf.mas_left);
        make.top.mas_equalTo(self.phoneTf.mas_bottom).offset(ZOOM_SCALE(4));
        make.right.mas_equalTo(self.phoneTf.mas_right);
        make.height.offset(ZOOM_SCALE(1));
    }];
    self.phoneTf.delegate = self;
    RACSignal *phoneTf= [[self.phoneTf rac_textSignal] map:^id(NSString *value) {
        if((value.length == 3 || value.length == 8 )){
            if (value.length<self.temp.length) {
                value =[value substringToIndex:value.length-1];
            }else{
                value = [NSString stringWithFormat:@"%@ ", value];
            }
        }
        self.phoneTf.text = value;
        self.temp = value;
        if (value.length>13) {
            value = [value substringToIndex:13];
            self.phoneTf.text = [value substringToIndex:13];
            self.temp = [value substringToIndex:13];
        }
        return @([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 11);
        //@([NSString validateCellPhoneNumber:[value stringByReplacingOccurrencesOfString:@" " withString:@""]]);
    }];
    RAC(self.commitBtn,enabled) = phoneTf;
    
    RAC(self.commitBtn, backgroundColor) = [phoneTf map: ^id (id value){
        if([value boolValue]){
            return PWBlueColor;
        }else{
            return [UIColor colorWithHexString:@"C7C7CC"];;
        }
    }];
    
}
-(UIButton *)commitBtn{
    if(!_commitBtn){
        _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(40), ZOOM_SCALE(377), ZOOM_SCALE(280), ZOOM_SCALE(44))];
        [_commitBtn setTitle:NSLocalizedString(@"local.login.login", @"") forState:UIControlStateNormal];
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
    
}
-(UITextField *)phoneTf{
    if (!_phoneTf) {
        _phoneTf = [PWCommonCtrl textFieldWithFrame:CGRectZero];
        _phoneTf.placeholder = NSLocalizedString(@"login.placeholder.phone", @"");
        _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_phoneTf];
    }
    return _phoneTf;
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
