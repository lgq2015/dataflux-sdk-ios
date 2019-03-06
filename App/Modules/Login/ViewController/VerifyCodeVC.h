//
//  VerifyCodeVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSUInteger, VerifyCodeVCType){
    VerifyCodeVCTypeLogin,
    VerifyCodeVCTypeFindPassword,
    VerifyCodeVCTypeChangePassword,
    VerifyCodeVCTypeUpdateEmail,
    VerifyCodeVCTypeUpdateMobile,
    VerifyCodeVCTypeUpdateMobileNewMobile,
    VerifyCodeVCTypeTeamDissolve,
    VerifyCodeVCTypeTeamTransfer,
};
NS_ASSUME_NONNULL_BEGIN

@interface VerifyCodeVC : RootViewController
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) VerifyCodeVCType type;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *teamMemberID;
@end

NS_ASSUME_NONNULL_END
