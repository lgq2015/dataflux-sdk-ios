//
//  ZYSocialManager.h
//  微信分享
//
//  Created by tao on 2019/4/7.
//  Copyright © 2019 shitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYSocialUIManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYSocialManager : NSObject
@property (nonatomic,strong)NSString *webpageUrl;
@property (nonatomic,strong)UIViewController *showVC;
- (instancetype)initWithTitle:(NSString *)title descr:(NSString *)descr thumImage:(UIImage *)thumImage;
- (void)shareToPlatform:(SharePlatformType)type;
@end

NS_ASSUME_NONNULL_END
