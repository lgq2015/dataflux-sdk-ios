//
//  VerificationCodeNetWork.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/6.
//  Copyright © 2019 hll. All rights reserved.
//

#import "VerificationCodeNetWork.h"
@interface VerificationCodeNetWork()
@property (nonatomic,copy) PWResponseSuccessBlock successBlock;   //-> 回掉
@property (nonatomic,copy) PWResponseFailBlock failBlock;
@end
@implementation VerificationCodeNetWork
- (void)VerificationCodeWithType:(VerifyCodeVCType)type phone:(NSString *)phone uuid:(NSString *)uuid successBlock:(PWResponseSuccessBlock)successBlock
                       failBlock:(PWResponseFailBlock)failBlock{
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    NSString *phoneText = phone.length>0?phone:userManager.curUserInfo.mobile;
    NSString *t;
    switch (type) {
        case VerifyCodeVCTypeLogin:
            t =@"login";
             [self getVerifyCodeWithPhone:phoneText to:t];
            break;
        case VerifyCodeVCTypeFindPassword:
            if( [phone validateEmail]){
                [self getCodeWithEmail:phone];
                break;
            }else{
                  t = @"forgotten_password";
             [self getVerifyCodeWithPhone:phoneText to:t];
                break;
            }
            
        case VerifyCodeVCTypeChangePassword:
            t = @"forgotten_password";
            [self getVerifyCodeWithTokenPhone:phoneText to:t];
            break;
        case VerifyCodeVCTypeUpdateEmail:
            t = @"update_email";
            [self getVerifyCodeWithTokenPhone:phoneText to:t];
            break;
        case VerifyCodeVCTypeUpdateMobile:
            t = @"update_mobile";
            [self getVerifyCodeWithTokenPhone:phoneText to:t];
            break;
        case VerifyCodeVCTypeUpdateMobileNewMobile:
            [self getCodeUpdateMobileNewMobileWithPhone:phone uuid:uuid];
            break;
        case VerifyCodeVCTypeTeamDissolve:
            t = @"team_cancel";
            [self getVerifyCodeWithTokenPhone:phoneText to:t];
            break;
        case VerifyCodeVCTypeTeamTransfer:
            t = @"owner_transfer";
            [self getVerifyCodeWithTokenPhone:phoneText to:t];
            break;
    }
   
    
}
- (void)getVerifyCodeWithPhone:(NSString *)phone to:(NSString *)t{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data": @{@"to":phone,@"t":t}};
    [PWNetworking requsetWithUrl:PW_sendAuthCodeUrl withRequestType:NetworkPostType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        self.successBlock ?  self.successBlock(response): nil;
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)getCodeUpdateMobileNewMobileWithPhone:(NSString *)phone uuid:(NSString *)uuid{
    [SVProgressHUD show];
     NSDictionary *param = @{@"data":@{@"username":phone,@"uType":@"mobile",@"uuid":uuid}};
    [PWNetworking requsetHasTokenWithUrl:PW_verifycodesend withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        self.successBlock ?  self.successBlock(response): nil;
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)getCodeWithEmail:(NSString *)email{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data":@{@"to":email,@"t":@"forgotten_password"}};
    [PWNetworking requsetWithUrl:PW_sendEmail withRequestType:NetworkPostType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        self.successBlock ?  self.successBlock(response): nil;
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)getVerifyCodeWithTokenPhone:(NSString *)phone to:(NSString *)t{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data": @{@"to":phone,@"t":t}};
    [PWNetworking requsetHasTokenWithUrl:PW_sendAuthCodeUrl withRequestType:NetworkPostType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        self.successBlock ?  self.successBlock(response): nil;
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
@end
