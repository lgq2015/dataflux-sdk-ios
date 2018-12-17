//
//  PWContentView.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/17.
//  Copyright © 2018 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PWScrollSegmentView;

@interface PWContentView : UIView
- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray *)childVcs segmentView:(PWScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
/** 给外界刷新视图的方法 */
- (void)reloadAllViewsWithNewChildVcs:(NSArray *)newChileVcs;
@end
