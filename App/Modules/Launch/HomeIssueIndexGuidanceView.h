//
//  HomeIssueIndexGuidanceView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeIssueIndexGuidanceView : UIView
@property (nonatomic, copy) void(^dismissClick)(void);

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
