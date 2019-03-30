//
//  PrivacySecurityControls.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM (NSInteger, PrivacyType){
    PrivacyTypeAVCaptureDevice,
    PrivacyTypePHPhotoLibrary,
    PrivacyTypeUserNotification,
};
NS_ASSUME_NONNULL_BEGIN

@interface PrivacySecurityControls : NSObject
- (NSInteger)getPrivacyStatusIsGrantedWithType:(PrivacyType)type controller:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
