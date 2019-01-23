//
//  UIScrollView+UITouch.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UIScrollView class]]) {
        
    }else{
        [[self nextResponder] touchesBegan:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesBegan:touches withEvent:event];
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UIScrollView class]]) {}else{
        [[self nextResponder] touchesMoved:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesMoved:touches withEvent:event];
        }
}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UIScrollView class]]) {
    } else {
        [[self nextResponder] touchesEnded:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesEnded:touches withEvent:event];
        }
    }
}

@end
