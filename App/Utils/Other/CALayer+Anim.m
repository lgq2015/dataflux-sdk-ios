//
//  CALayer+Anim.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CALayer+Anim.h"

@implementation CALayer (Anim)
/*
 *  摇动
 */
-(void)shake{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 5;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = 0.3f;
    
    //重复
    kfa.repeatCount = 2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}
@end
