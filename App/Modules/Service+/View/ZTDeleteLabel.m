//
//  ZTDeleteLabel.m
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTDeleteLabel.h"

@implementation ZTDeleteLabel

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    // 取文字的颜色作为删除线的颜色
    [self.textColor set];
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    UIRectFill(CGRectMake(0, h * 0.35, w, 1));
}

@end
