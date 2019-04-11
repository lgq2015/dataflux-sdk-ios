//
//  UIViewController+ChangeNavBarColor.m
//  App
//
//  Created by tao on 2019/4/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UIViewController+ChangeNavBarColor.h"

@implementation UIViewController (ChangeNavBarColor)
- (void)changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView criticalValue:(CGFloat)value {
    CGFloat offsetY = scrollView.contentOffset.y;
    UIImageView *shadowImg = [self seekLineImageViewOn:self.navigationController.navigationBar];
    self.navigationController.navigationBar.hidden = offsetY <= 0 ? YES : NO;
    NSLog(@"offsetY-----%f",offsetY);
    shadowImg.hidden = offsetY <= 0 ? YES : NO;
    if (offsetY > 0) {
        CGFloat alpha = offsetY / value > 1.0f ? 1 : (offsetY / value);
        // 背景色
        UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:alpha], NSFontAttributeName:[UIFont systemFontOfSize:20]}];
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
- (void)zt_changeNavColorStart {
    self.navigationController.navigationBar.translucent = YES;
    UIImageView *shadowImg = [self seekLineImageViewOn:self.navigationController.navigationBar];
    shadowImg.hidden = YES;
}

- (void)zt_changeNavColorReset {
    self.navigationController.navigationBar.translucent = NO;
    UIImageView *shadowImg = [self seekLineImageViewOn:self.navigationController.navigationBar];
    shadowImg.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
// 查找导航栏下的横线
- (UIImageView *)seekLineImageViewOn:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) return (UIImageView *)view;
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self seekLineImageViewOn:subview];
        if (imageView) return imageView;
    }
    return nil;
}
@end
