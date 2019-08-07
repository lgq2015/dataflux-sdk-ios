//
//  ChangeUserInfoVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChangeUserInfoVC.h"
#import "VerifyCodeVC.h"
#import "ChangeCardItem.h"
#import "PasswordVerifyVC.h"
#import "VerificationCodeNetWork.h"
#import "ZhugeIOMineHelper.h"
#import "NSString+ErrorCode.h"

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
           [self setNaviTitle:NSLocalizedString(@"local.ModifyThePhone", @"")];
            break;
        case ChangeUITPassword:
           [self setNaviTitle:NSLocalizedString(@"local.ChangeThePassword", @"")];
            break;
        case ChangeUITEmail:
        if (userManager.curUserInfo.email == nil ||[userManager.curUserInfo.email isEqualToString:@""]) {
            [self setNaviTitle:NSLocalizedString(@"local.BindingEmail", @"")];
        }else{
            [self setNaviTitle:NSLocalizedString(@"local.ModifyTheEmail", @"")];
        }
            break;
        case ChangeUITTeamDissolve:
            [self setNaviTitle:NSLocalizedString(@"local.Authentication", @"")];
            break;
        case ChangeUITTeamTransfer:
            [self setNaviTitle:NSLocalizedString(@"local.Authentication", @"")];
            break;
    }
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, Interval(58)+kTopHeight, kWidth, ZOOM_SCALE(55)) font:RegularFONT(18) textColor:PWTextBlackColor text:NSLocalizedString(@"local.tip.AuthenticationTip", @"")];
    tipLab.numberOfLines = 2;
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
    NSDictionary *phoneDict = @{@"icon":@"icon_phone",@"phone":userManager.curUserInfo.mobile,@"tip":NSLocalizedString(@"local.VerifyIdentityByPhoneCode", @"")};
    NSDictionary *passwordDict = @{@"icon":@"icon_minecode",@"phone":NSLocalizedString(@"local.PasswordAuthenticationl", @""),@"tip":NSLocalizedString(@"local.VerifyIdentityByPassword", @"")};
    
    ChangeCardItem *phoneItem = [[ChangeCardItem alloc]initWithFrame:CGRectZero data:phoneDict];
    phoneItem.itemClick=^(){
         [self itemPhoneClick];
    };
    [self.view addSubview:phoneItem];
    [phoneItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(tipLab.mas_bottom).offset(Interval(96));
        make.height.offset(Interval(35)+ZOOM_SCALE(45));
    }];
    ChangeCardItem *passItem = [[ChangeCardItem alloc]initWithFrame:CGRectZero data:passwordDict];
    passItem.itemClick = ^(){
        [self itemPassWordClick];
    };
    [self.view addSubview:passItem];
    passItem.tag = TagPasswordItem;
    [passItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(phoneItem.mas_bottom).offset(Interval(20));
        make.height.offset(Interval(35)+ZOOM_SCALE(45));
    }];
}

- (void)itemPhoneClick{
        VerifyCodeVCType type;
        switch (self.type) {
            case ChangeUITPhoneNumber:
                [[[[ZhugeIOMineHelper new] eventGetVerifyCode] attrSceneChangeMobile] track];
                type = VerifyCodeVCTypeUpdateMobile;
                break;
            case ChangeUITPassword:
                [[[[ZhugeIOMineHelper new] eventGetVerifyCode] attrSceneChangePwd] track];
                type = VerifyCodeVCTypeChangePassword;
                break;
            case ChangeUITEmail:
                [[[[ZhugeIOMineHelper new] eventGetVerifyCode] attrSceneChangeEmail] track];
                type = VerifyCodeVCTypeUpdateEmail;
                break;
            case ChangeUITTeamDissolve:
                [[[[ZhugeIOMineHelper new] eventGetVerifyCode] attrSceneVerify] track];
                type =VerifyCodeVCTypeTeamDissolve;
                break;
            case ChangeUITTeamTransfer:
                [[[[ZhugeIOMineHelper new] eventGetVerifyCode] attrSceneVerify] track];
                type =VerifyCodeVCTypeTeamTransfer;
                break;
        }
    VerificationCodeNetWork *code = [[VerificationCodeNetWork alloc]init];
    [code VerificationCodeWithType:type phone:@"" uuid:@"" successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            VerifyCodeVC *codeVC = [[VerifyCodeVC alloc]init];
            codeVC.type = type;
            codeVC.phoneNumber = userManager.curUserInfo.mobile;
            codeVC.isShowCustomNaviBar = YES;
            if (self.type ==ChangeUITTeamTransfer ) {
                codeVC.teamMemberID =self.memberID;
            }
            [self.navigationController pushViewController:codeVC animated:YES];
        }else{
            [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}
- (void)itemPassWordClick{
    PassWordVerifyType type;
    switch (self.type) {
        case ChangeUITPhoneNumber:
            type = PassWordVerifyUpdateMobile;
            break;
        case ChangeUITPassword:
            type = PassWordVerifyChangePassword;
            break;
        case ChangeUITEmail:
            type = PassWordVerifyUpdateEmail;
            break;
        case ChangeUITTeamDissolve:
            type =PassWordVerifyTypeTeamDissolve;
            break;
        case ChangeUITTeamTransfer:
            type =PassWordVerifyTypeTeamTransfer;

            break;
    }
    PasswordVerifyVC *pass =[[PasswordVerifyVC alloc]init];
    pass.phoneNumber = userManager.curUserInfo.mobile;
    pass.isShowCustomNaviBar = YES;
    pass.type = type;
    if (self.type ==ChangeUITTeamTransfer ) {
        pass.teamMemberID =self.memberID;
    }
    [self.navigationController pushViewController:pass animated:YES];
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
