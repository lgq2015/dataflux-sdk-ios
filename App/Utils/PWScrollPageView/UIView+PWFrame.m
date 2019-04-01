//
//  UIView+PWFrame.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/16.
//  Copyright © 2018 hll. All rights reserved.
//

#import "UIView+PWFrame.h"

@implementation UIView (PWFrame)
- (CGFloat)pw_height
{
    return self.frame.size.height;
}

- (CGFloat)pw_width
{
    return self.frame.size.width;
}

- (void)setPw_height:(CGFloat)pw_height {
    CGRect frame = self.frame;
    frame.size.height = pw_height;
    self.frame = frame;
}
- (void)setPw_width:(CGFloat)pw_width {
    CGRect frame = self.frame;
    frame.size.width = pw_width;
    self.frame = frame;
}

- (CGFloat)pw_x
{
    return self.frame.origin.x;
}

- (void)setPw_x:(CGFloat)pw_x {
    CGRect frame = self.frame;
    frame.origin.x = pw_x;
    self.frame = frame;
}


- (CGFloat)pw_y
{
    return self.frame.origin.y;
}


- (void)setPw_y:(CGFloat)pw_y {
    CGRect frame = self.frame;
    frame.origin.y = pw_y;
    self.frame = frame;
}


- (void)setPw_centerX:(CGFloat)pw_centerX {
    CGPoint center = self.center;
    center.x = pw_centerX;
    self.center = center;
}

- (CGFloat)pw_centerX
{
    return self.center.x;
}


- (void)setPw_centerY:(CGFloat)pw_centerY {
    CGPoint center = self.center;
    center.y = pw_centerY;
    self.center = center;
}

- (CGFloat)pw_centerY
{
    return self.center.y;
}

@end
