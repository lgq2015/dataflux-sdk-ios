//
//  PWTransition.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWTransitionProtocol.h"

@interface PWTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property(nonatomic, assign) BOOL isPush;//是否是push，反之则是pop

@property(nonatomic, assign) NSTimeInterval animationDuration;//动画时长
@end
