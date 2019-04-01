//
//  VerificationCodeNetWork.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/6.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@interface VerificationCodeNetWork : NSObject
- (void)VerificationCodeWithType:(VerifyCodeVCType)type phone:(NSString *)phone uuid:(NSString *)uuid successBlock:(PWResponseSuccessBlock)successBlock
                             failBlock:(PWResponseFailBlock)failBlock;


@end

