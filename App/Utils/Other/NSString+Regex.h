//
//  NSString+Regex.h
//  App
//
//  Created by tao on 2019/4/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Regex)
//匹配A标签
- (NSMutableAttributedString *)zt_convertLink:(UIFont *)font textColor:(UIColor *)color;
//获取多行文字高度
- (CGFloat)zt_getHeight:(UIFont *)zt_font width:(CGFloat)width;
//A标签替换后的文本
- (NSString *)zt_convertLinkTextString;
//获取单行文字宽度
- (CGFloat)calculateStringWidth:(NSString *)str withFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
