//
//  UIColor+Gradual.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Gradual)
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
+ (CAGradientLayer *)setGradualChangingColorWithFrame:(CGRect )frame fromColor:(NSString *)fromHexColorStr mediumColor:(NSString *)mediumColor toColor:(NSString *)toHexColorStr isDefault:(BOOL)isDefault;
@end

NS_ASSUME_NONNULL_END
