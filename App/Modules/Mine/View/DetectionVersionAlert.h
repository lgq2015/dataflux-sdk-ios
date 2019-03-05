//
//  DetectionVersionAlert.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CancleBtnTag  100
#define UpdateBtnTag  200
NS_ASSUME_NONNULL_BEGIN

@interface DetectionVersionAlert : UIView
@property (nonatomic, copy) void(^itemClick)(void);
-(instancetype)initWithReleaseNotes:(NSString *)releaseNotes Version:(NSString *)version;

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
