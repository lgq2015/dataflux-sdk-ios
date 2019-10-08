//
//  NaviBarView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
NS_ASSUME_NONNULL_BEGIN

@interface NaviBarView : UIView

@property (retain, nonatomic) UIView *statusBar;    // 状态栏
@property (retain, nonatomic) UIView *navigationBar;    // 导航条
@property (retain, nonatomic) UIButton *rightWishBtn;   // 右侧分享按钮
@property (retain, nonatomic) UIButton *leftMenuBtn;    // 左侧菜单栏
@property (retain, nonatomic) UIButton *backBtn;    // 返回按钮
@property (retain, nonatomic) UILabel *titleLabel;  // 标题
@property(nonatomic, strong)UIView *lineView;   // 底部分割线
@property (retain, nonatomic) UIButton *rightBtn;
- (instancetype)initWithController:(RootViewController *)controller;
- (void)addBackBtn;
// 添加底部分割线
- (void)addBottomSepLine;
// 设置标题
- (void)setNavigationTitle:(NSString *)title;
// 设置导航条透明
- (void)clearNavBarBackgroundColor;
// 右侧添加按钮
- (void)addNavRightBtnWithImage:(NSString *)imageName;
//- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action;
@end

NS_ASSUME_NONNULL_END
