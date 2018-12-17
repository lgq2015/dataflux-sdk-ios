//
//  PWScrollPageView.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/17.
//  Copyright © 2018 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWScrollSegmentView.h"
#import "PWContentView.h"
@interface PWScrollPageView : UIView
typedef void(^ExtraBtnOnClick)(UIButton *extraBtn);
@property (copy, nonatomic) ExtraBtnOnClick extraBtnOnClick;
- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(PWSegmentStyle *)segmentStyle childVcs:(NSArray *)childVcs parentViewController:(UIViewController *)parentViewController;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadChildVcsWithNewChildVcs:(NSArray *)newChildVcs;
@end
