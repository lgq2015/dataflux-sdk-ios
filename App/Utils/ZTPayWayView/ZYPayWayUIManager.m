//
//  ZYPayWayUIManager.m
//  App
//
//  Created by tao on 2019/4/22.
//  Copyright © 2019 hll. All rights reserved.
//
#define zt_platform_itemH 93
#define zt_platform_cancelBtnH 60
#define zt_cancel_topline_margin 15 //处理分割线距离上方的大小
#define zt_payWayViewH zt_platform_itemH * 2
#import "ZYPayWayUIManager.h"
@interface ZYPayWayUIManager()
@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View
@property (nonatomic,strong) UIView * payWayView;//!<分享背景
@property (nonatomic, strong) UILabel *payWayLab;
@property (nonatomic, strong) UILabel *zhifubaoLab;
@property (nonatomic, strong) UILabel *contactsaleLab;
@property (nonatomic, strong) UIButton *zhifubaoBtn;
@property (nonatomic, strong) UIButton *contactsaleBtn;
@property (nonatomic, strong) UIButton *surePayBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy)PayWayBlock payWayBlock;
@end
@implementation ZYPayWayUIManager
+ (instancetype)shareInstance{
    static ZYPayWayUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYPayWayUIManager alloc] init];
    });
    return instance;
}


#pragma mark --添加主控件--
-(void)s_UI{
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self.payWayView];
    [self.payWayView addSubview:self.payWayLab];
    [self p_hideFrame];
    [self s_childUI];
}

//隐藏
-(void)p_hideFrame{
    _payWayView.frame =CGRectMake(0,kHeight, kWidth, 300);
}

//展示
-(void)p_disFrame{
    _payWayView.frame =CGRectMake(0,kHeight-300, kWidth, 300);
}
#pragma mark - 布局子控件
- (void)s_childUI{
    [self.payWayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payWayView.mas_left).offset(16);
        make.top.equalTo(self.payWayView.mas_top).offset(52);
    }];
    [self.zhifubaoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payWayLab.mas_left);
        make.top.equalTo(self.payWayLab.mas_bottom).offset(27);
    }];
}
#pragma mark - 展示
- (void)showWithPayWaySelectionBlock:(PayWayBlock)payWayBlock{
    _payWayBlock = payWayBlock;
    [self s_UI];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_disFrame];
        self->_payWayView.alpha = 1;
        self->_backgroundGrayView.alpha = 0.8;
    } completion:^(BOOL finished) {
        if (finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];

    [UIView commitAnimations];
}
-(void)dismiss{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_hideFrame];
        self.alpha = 0;
        self.payWayView.alpha = 0;
        self.backgroundGrayView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.payWayView = nil;
            [self.payWayView removeFromSuperview];
            [self.backgroundGrayView removeFromSuperview];
            [self removeFromSuperview];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [UIView commitAnimations];
}

#pragma mark - Click点击分享
-(void)shareNewClick:(UIButton *)btn{
//    NSString * titleStr = _titleArr[btn.tag - 401];
//    if ([titleStr isEqualToString:@"朋友圈"]) {
//        self.sharePlatformType = WechatTimeLine_PlatformType;
//    }else if ([titleStr isEqualToString:@"微信"]){
//        self.sharePlatformType = WechatSession_PlatformType;
//    }else if ([titleStr isEqualToString:@"QQ"]){
//        self.sharePlatformType = QQ_PlatformType;
//    }else if ([titleStr isEqualToString:@"QQ空间"]){
//        self.sharePlatformType = Qzone_PlatformType;
//    }else if ([titleStr isEqualToString:@"钉钉"]){
//        self.sharePlatformType = Dingding_PlatformType;
//    }else{
//        self.sharePlatformType = System_PlatformType;
//    }
//    _shareBlock(self.sharePlatformType);
    [self dismiss];
}

#pragma mark --lazy--
-(UIWindow *)window{
    if (!_window) {
        _window = [[[UIApplication sharedApplication]delegate]window];
    }
    return _window;
}
-(UIView *)payWayView{
    if (!_payWayView) {
        _payWayView = [[UIView alloc]init];
        _payWayView.backgroundColor = [UIColor whiteColor];
    }
    return _payWayView;
}
-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,0, kWidth, kHeight);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_backgroundGrayView addGestureRecognizer:tap];
        
    }
    return _backgroundGrayView;
}
- (UILabel *)payWayLab{
    if (!_payWayLab){
        _payWayLab = [[UILabel alloc] init];
        _payWayLab.font = [UIFont systemFontOfSize:20];
        _payWayLab.text = @"支付方式";
    }
    return _payWayLab;
}
- (UILabel *)zhifubaoLab{
    if (!_zhifubaoLab){
        _zhifubaoLab = [[UILabel alloc] init];
    }
    return _zhifubaoLab;
}
- (UILabel *)contactsaleLab{
    if (!_contactsaleLab){
        _contactsaleLab = [[UILabel alloc] init];
    }
    return _contactsaleLab;
}
- (UIButton *)zhifubaoBtn{
    if (!_zhifubaoBtn){
        _zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _zhifubaoBtn;
}
- (UIButton *)contactsaleBtn{
    if (!_contactsaleBtn){
        _contactsaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _contactsaleBtn;
}
- (UIButton *)surePayBtn{
    if (!_surePayBtn){
        _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _surePayBtn;
}
- (UIButton *)closeBtn{
    if (!_closeBtn){
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _closeBtn;
}
@end
