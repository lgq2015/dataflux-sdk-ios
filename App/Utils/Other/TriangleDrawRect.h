//
//  TrangleDrawRect.h
//  TextUrlSchemes
//
//  Created by 胡蕾蕾 on 2019/7/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TriangleDrawRect : UIView
- (instancetype)initStartPoint:(CGPoint)startPoint middlePoint:(CGPoint)middlePoint endPoint:(CGPoint)endPoint color:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
