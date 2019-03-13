//
//  AddIssueSourceTipView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AddIssueSourceTipView : UIView
@property (nonatomic, copy) void(^itemClick)(void);
@property (nonatomic, copy) void(^netClick)(NSURL *url);

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
