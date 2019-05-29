//
//  IgnoreItemView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/21.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IgnoreItemView : UIView
@property (nonatomic, copy) void(^itemClick)(void);
- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
