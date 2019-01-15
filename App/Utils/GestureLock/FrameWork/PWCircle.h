//
//  PWCircle.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  单个圆的各种状态
 */
typedef NS_ENUM(NSUInteger,CircleState) {
    CircleStateNormal = 1,
    CircleStateSelected,
    CircleStateError,
    CircleStateLastOneSelected,
    CircleStateLastOneError
};
/**
 *  单个圆的用途类型
 */
typedef NS_ENUM(NSUInteger,CircleType) {
    CircleTypeInfo = 1,
    CircleTypeGesture
};

@interface PWCircle : UIView
/**
 *  所处的状态
 */
@property (nonatomic, assign) CircleState state;

/**
 *  类型
 */
@property (nonatomic, assign) CircleType type;

/**
 *  是否有箭头 default is YES
 */
@property (nonatomic, assign) BOOL arrow;

/** 角度 */
@property (nonatomic,assign) CGFloat angle;
@end


