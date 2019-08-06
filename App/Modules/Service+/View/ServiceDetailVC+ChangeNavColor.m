//
//  ServiceDetailVC+ChangeNavColor.m
//  App
//
//  Created by tao on 2019/4/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ServiceDetailVC+ChangeNavColor.h"

@implementation ServiceDetailVC (ChangeNavColor)
- (void)changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView criticalValue:(CGFloat)value {
    CGFloat offsetY = scrollView.contentOffset.y;
    DLog(@"offsetY-----%f",offsetY);
    if (offsetY > 2) {
        CGFloat alpha = offsetY / value > 1.0f ? 1 : (offsetY / value);
        // 背景色
        self.topNavBar.backgroundColor = [color colorWithAlphaComponent:alpha];
        // 字体颜色
        self.topNavBar.titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        // 返回按钮颜色
        self.topNavBar.backBtn.alpha = alpha;
        // 分割线
        self.topNavBar.lineView.alpha = alpha;
        // 白色返回按钮
        self.whiteBackBtn.alpha = 1 - alpha;
    }else{
        self.topNavBar.backgroundColor = [UIColor clearColor];
        self.topNavBar.titleLabel.textColor = [UIColor clearColor];
        self.topNavBar.backBtn.alpha = 0.01;
        self.topNavBar.lineView.alpha = 0.01;
        self.whiteBackBtn.alpha = 1.0;
    }
}
- (void)zt_changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView {
    // 默认临界值为30
    [self changeColor:color scrolllView:scrollView criticalValue:30];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
