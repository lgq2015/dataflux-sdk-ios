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
};
NS_ASSUME_NONNULL_BEGIN

@interface VerifyCodeVC : RootViewController
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) VerifyCodeVCType type;
@end

NS_ASSUME_NONNULL_END
