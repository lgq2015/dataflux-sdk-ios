//
//  NSString+Regex.m
//  App
//
//  Created by tao on 2019/4/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NSString+Regex.h"
#import <RegexKitLite.h>

@implementation NSString (Regex)
- (NSMutableAttributedString *)zt_convertLink:(UIFont *)zt_font textColor:(UIColor *)zt_color{
    NSString *regex_http = @"<a href=(?:.*?)>(.*?)<\\/a>";
    NSString *labelText = self;
    NSArray *array_http = [labelText arrayOfCaptureComponentsMatchedByRegex:regex_http];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor lightGrayColor];
    if ([array_http count]) {
        // 先把html a标签都给去掉
        labelText = [labelText stringByReplacingOccurrencesOfString:@"<a href=(.*?)>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange (0, labelText.length)];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"<\\/a>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange (0, labelText.length)];

         NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:labelText];
        aStr.font = zt_font;
        aStr.color = zt_color;
        for (NSArray *array in array_http) {
            // 获得链接显示文字的range，用来设置下划线
            NSRange range = [labelText rangeOfString:array[1]];
            [aStr setColor:PWDefaultBtnColor range:range];
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            NSString *linkStr = [array.firstObject componentsSeparatedByString:@"\""][1];
            highlight.userInfo = @{@"linkUrl": linkStr};
            [aStr setTextHighlight:highlight range:range];
        }
        return aStr;
    }
   NSMutableAttributedString  * nStr = [[NSMutableAttributedString alloc] initWithData:[labelText dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    nStr.font = zt_font;
    nStr.color = zt_color;
    return nStr;
}
- (CGFloat)zt_getHeight:(UIFont *)zt_font width:(CGFloat)width{
    CGSize infoSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName : zt_font};
    CGRect infoRect =   [self boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    //1.0 解决返回的高度是小数时，布局显示会有误差
    CGFloat height = ceil(infoRect.size.height) + 1.0;
    return height;
}
- (NSString *)zt_convertLinkTextString{
    NSString *regex_http = @"<a href=(?:.*?)>(.*?)<\\/a>";
    NSString *labelText = self;
    NSArray *array_http = [labelText arrayOfCaptureComponentsMatchedByRegex:regex_http];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor lightGrayColor];
    if ([array_http count]) {
        // 先把html a标签都给去掉
        labelText = [labelText stringByReplacingOccurrencesOfString:@"<a href=(.*?)>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange (0, labelText.length)];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"<\\/a>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange (0, labelText.length)];
    }
    return labelText;
}
- (CGFloat)calculateStringWidth:(NSString *)str withFont:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
@end
