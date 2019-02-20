//
//  NaviBarView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NaviBarView.h"
#import "RootViewController.h"

#define TagRightMenu -300   // 右侧菜单栏
#define TagRightImg -301  // 右侧图片
#define TagLeftClose -302 // 左边关闭按钮
#define TagBackBtn -303   // 左侧返回按钮
#define TagClose -304 // 关闭按钮
#define kTagLine -22    // 底部线条
@implementation NaviBarView{
    __weak RootViewController *_controller;
    UIView *_statusBar;
    UIView *_navigationBar;
    UIView *_titleView;
    UIButton *_rightWishBtn;
    UIView *_rightMenuView;
    UIButton *_leftMenuBtn;
    UIButton *_leftScanQRCode;  // 左侧二维码扫码
    UIView *_searchBarView;
    UIView *_lineView;
    UIButton *_backBtn;
    UIButton *_closeBtn;
}
- (instancetype)initWithController:(RootViewController *)controller {
    _controller = controller;
    
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, kNavBarHeight)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.zPosition = 999999;
    
    // 最顶部的状态栏
    _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kNavBarHeight)];
    _statusBar.backgroundColor = PWBackgroundColor;
    [self addSubview:_statusBar];
    
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kWidth, kNavBarHeight)];
    _navigationBar.backgroundColor = PWBackgroundColor;
    [self addSubview:_navigationBar];
    
    return self;
}
#pragma mark - get

- (UIView *)navigationBar {
    return _navigationBar;
}

- (UIView *)statusBar {
    return _statusBar;
}

- (UIButton *)rightWishBtn {
    return _rightWishBtn;
}

- (UIButton *)leftMenuBtn {
    return _leftMenuBtn;
}

- (UIButton *)backBtn {
    return _backBtn;
}
#pragma mark ========== draw ==========
- (void)addBackBtn {
    // 不能添加多个
    UIView *srcBack = [_navigationBar viewWithTag:TagBackBtn];
    if (srcBack)
        return;
    
    UIImage *background = [UIImage imageNamed:@"icon_back"];
    UIImage *backgroundOn = [UIImage imageNamed:@"icon_back"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAccessibilityIdentifier:@"TopBackBtn"];
    button.tag = TagBackBtn;
    [button addTarget:self action:@selector(doBackPrev) forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:background forState:UIControlStateNormal];
    [button setImage:backgroundOn forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 20);
    [_navigationBar addSubview:button];
    _backBtn = button;
}
- (void)addBottomSepLine {
    UIView *lineView = [_navigationBar viewWithTag:kTagLine];
    if (lineView) {
        return;
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBar.height - 1, self.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    line.tag = kTagLine;
    _lineView = line;
    [_navigationBar addSubview:line];
}
- (void)doBackPrev{
    if (_controller)
        [_controller backBtnClicked];
}
#pragma mark ========== set ==========
- (void)clearNavBarBackgroundColor {
    _statusBar.backgroundColor = [UIColor clearColor];
    _navigationBar.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    UIView *childView = [self viewWithTag:kTagLine];
    if (childView) [childView removeFromSuperview];
}
- (void)setNavigationTitle:(NSString *)title {
    self.titleLabel.text = title;
}
- (void)setBackImage:(NSString *)imageName {
    UIImage *background = [UIImage imageNamed:imageName];
    UIImage *backgroundOn = [UIImage imageNamed:imageName];
    [_backBtn setImage:background forState:UIControlStateNormal];
    [_backBtn setImage:backgroundOn forState:UIControlStateHighlighted];
}
#pragma mark - lazy

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, kWidth - 120, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = BOLDFONT(18);
        _titleLabel.textColor = PWTextBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_navigationBar addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)dealloc {
    if (_rightMenuView) _rightMenuView = nil;
    if (_rightWishBtn) _rightWishBtn = nil;
    if (_leftMenuBtn) _leftMenuBtn = nil;
    if (_backBtn) _backBtn = nil;
    if (_closeBtn) _closeBtn = nil;
    if (_searchBarView) _searchBarView = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
