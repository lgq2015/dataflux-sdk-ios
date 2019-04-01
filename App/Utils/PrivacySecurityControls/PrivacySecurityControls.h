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

@interface PrivacySecurityControls : NSObject
@property (nonatomic, copy) void(^refuseBlock)(void);

- (NSInteger)getPrivacyStatusIsGrantedWithType:(PrivacyType)type controller:(UIViewController *)controller;
@end


