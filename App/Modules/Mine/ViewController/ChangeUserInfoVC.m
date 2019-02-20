//
//  ChangeUserInfoVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChangeUserInfoVC.h"
#import "VerifyCodeVC.h"
#define TagPhoneItem  100  // 右侧图片
#define TagPasswordItem 200
@interface ChangeUserInfoVC ()

@end

@implementation ChangeUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createUI];
}

- (void)createUI{
    switch (self.type) {
        case ChangeUITPhoneNumber:
           [self setNaviTitle:@"修改密码"];
            break;
        case ChangeUITPassword:
           [self setNaviTitle:@"修改密码"];
            break;
        case ChangeUITEmail:
           [self setNaviTitle:@"修改密码"];
            break;
    }
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, Interval(58)+kTopHeight, kWidth, ZOOM_SCALE(55)) font:MediumFONT(18) textColor:PWTextBlackColor text:@"为了保障您的账号安全 \n请选择一种身份验证"];
    tipLab.numberOfLines = 2;
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
    NSDictionary *phoneDict = @{@"icon":@"icon_phone",@"phone":userManager.curUserInfo.mobile,@"tip":@"通过手机验证码验证身份"};
    NSDictionary *passwordDict = @{@"icon":@"icon_minecode",@"phone":@"密码验证",@"tip":@"通过密码验证身份"};
    
    UIView *phoneItem = [self itemViewWithData:phoneDict];
    phoneItem.tag = TagPhoneItem;
    [phoneItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(tipLab.mas_bottom).offset(Interval(96));
        make.height.offset(Interval(35)+ZOOM_SCALE(45));
    }];
    UIView *passItem = [self itemViewWithData:passwordDict];
    [self.view addSubview:passItem];
    passItem.tag = TagPasswordItem;
    [passItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(phoneItem.mas_bottom).offset(Interval(20));
        make.height.offset(Interval(35)+ZOOM_SCALE(45));
    }];
}
- (UIView *)itemViewWithData:(NSDictionary *)data{
    UIView *item = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-Interval(32), ZOOM_SCALE(80))];
    [self.view addSubview:item];
    item.backgroundColor = PWWhiteColor;
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(24), 0, ZOOM_SCALE(36), ZOOM_SCALE(36))];
    icon.image = [UIImage imageNamed:data[@"icon"]];
    CGPoint center = icon.center;
    center.y = item.centerY;
    icon.center = center;
    [item addSubview:icon];
    NSString *phone =data[@"phone"];
    if (phone.length==11) {
        phone =[NSString stringWithFormat:@"%@******%@",[phone substringToIndex:3],[phone substringFromIndex:9]];
    }
    UILabel *phoneLab = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(18) textColor:[UIColor colorWithHexString:@"595860"] text:phone];
    [item addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(26));
        make.top.mas_equalTo(item).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:[UIFont systemFontOfSize:14] textColor:textColorNormalState text:data[@"tip"]];
    [item addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLab.mas_left);
        make.top.mas_equalTo(phoneLab.mas_bottom).offset(Interval(4));
        make.height.offset(ZOOM_SCALE(20));
    }];
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextbig"]];
    [item addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(item).offset(-Interval(24));
        make.width.offset(ZOOM_SCALE(12));
        make.height.offset(ZOOM_SCALE(24));
        make.centerY.mas_equalTo(item);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
    [item addGestureRecognizer:tap];
    item.layer.cornerRadius = 8;
    item.layer.shadowOffset = CGSizeMake(0,2);
    item.layer.shadowColor = [UIColor blackColor].CGColor;
    item.layer.shadowRadius = 8;
    item.layer.shadowOpacity = 0.06;
    return item;
}
- (void)itemClick:(UITapGestureRecognizer *)tap{
    if(tap.view.tag == TagPhoneItem){
        NSString *t;
        VerifyCodeVCType type;
        switch (self.type) {
            case ChangeUITPhoneNumber:
                t = @"update_mobile";
                type = VerifyCodeVCTypeUpdateMobile;
                break;
            case ChangeUITPassword:
                t = @"change_password";
                type = VerifyCodeVCTypeChangePassword;
                break;
            case ChangeUITEmail:
                t = @"update_email";
                type = VerifyCodeVCTypeUpdateEmail;
                break;
        }
//        NSDictionary *param = @{@"data":@{@"to":userManager.curUserInfo.mobile,@"t":t}};
//        [PWNetworking requsetHasTokenWithUrl:PW_sendAuthCodeUrl withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
//            if ([response[@"errorCode"] isEqualToString:@""]) {
                VerifyCodeVC *codeVC = [[VerifyCodeVC alloc]init];
                codeVC.type = type;
                codeVC.phoneNumber = userManager.curUserInfo.mobile;
                codeVC.isShowCustomNaviBar = YES;
                [self.navigationController pushViewController:codeVC animated:YES];
//            }
//        } failBlock:^(NSError *error) {
//
//        }];
      
    }else if(tap.view.tag == TagPasswordItem){
        
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
