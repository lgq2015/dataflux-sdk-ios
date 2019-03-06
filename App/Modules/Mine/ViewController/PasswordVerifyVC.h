//
//  PasswordVerifyVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSUInteger, PassWordVerifyType){
    PassWordVerifyChangePassword,
    PassWordVerifyUpdateEmail,
    PassWordVerifyUpdateMobile,
    PassWordVerifyTypeTeamTransfer,
    PassWordVerifyTypeTeamDissolve,
};
NS_ASSUME_NONNULL_BEGIN

@interface PasswordVerifyVC : RootViewController
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) PassWordVerifyType type;
@property (nonatomic, copy) NSString *teamMemberID;
@end

NS_ASSUME_NONNULL_END
