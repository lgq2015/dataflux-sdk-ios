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
    UIButton *_rightBtn;
}
- (instancetype)initWithController:(RootViewController *)controller {
    _controller = controller;
    
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, kNavBarHeight)];
    self.backgroundColor = [UIColor clearColor];
    
    // 最顶部的状态栏
    _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kNavBarHeight)];
    _statusBar.backgroundColor = [UIColor clearColor];
    [self addSubview:_statusBar];
    
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kWidth, kNavBarHeight)];
    _navigationBar.backgroundColor = [UIColor clearColor];
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
-(UIButton *)rightBtn{
    return _rightBtn;
}
#pragma mark ========== draw ==========
- (void)addBackBtn {
    // 不能添加多个
    UIView *srcBack = [_navigationBar viewWithTag:TagBackBtn];
    if (srcBack)
        return;
    
    UIImage *background = [UIImage imageNamed:@"icon_back"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(doBackPrev) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:background forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 20);
    [_navigationBar addSubview:button];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doBackPrev)];
    [self addGestureRecognizer:tap];
    _backBtn = button;
}
- (void)addNavRightBtnWithImage:(NSString *)imageName{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 0, 60, 44)];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(7, -20, 7, -7);
    [_navigationBar addSubview:rightBtn];
    _rightBtn = rightBtn;
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
    _navigationBar.userInteractionEnabled = YES;
    [_navigationBar addSubview:line];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil){
        //转换坐标
        CGPoint tempPoint = [self.backBtn convertPoint:point fromView:self];
        CGPoint rightPoint = [self.rightBtn convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.backBtn.bounds, tempPoint)){
            //返回按钮
            return _backBtn;
        }
        if (CGRectContainsPoint(self.rightBtn.bounds, rightPoint)) {
            return _rightBtn;
        }
    }
    return view;
   
}
- (void)doBackPrev{
    if (_controller)
        [_controller backBtnClicked];
}
- (void)rightBtnClick{
    if (_controller)
        [_controller rightBtnClick];
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
        _titleLabel.font = MediumFONT(18);
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
    if (_rightBtn) _rightBtn = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
