//
//  WebItemView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebItemView : UIView
@property (nonatomic, copy) void(^itemClick)(NSInteger tag);

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
