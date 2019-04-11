//
//  UIViewController+ChangeNavBarColor.h
//  App
//
//  Created by tao on 2019/4/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ChangeNavBarColor)
//监听到滚动行为时 调用
- (void)zt_changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView;
//viewWillAppear 开始时调用
- (void)zt_changeNavColorStart;
//viewWillDisappear 结束时调用
- (void)zt_changeNavColorReset;
@end

NS_ASSUME_NONNULL_END
