//
//  ZTShareView.m
//  123
//
//  Created by tao on 2019/4/5.
//  Copyright © 2019 shitu. All rights reserved.
//
#define zt_platform_itemH 93
#define zt_platform_cancelBtnH 60
#define zt_cancel_topline_margin 15 //处理分割线距离上方的大小
#define zt_shareViewH zt_platform_itemH * 2
#import "ZYSocialUIManager.h"
#import "ZTOpenUrl.h"
@interface ZYSocialUIManager()
@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View
@property (nonatomic,strong) UIView * shareView;//!<分享背景
@property (nonatomic,strong) UIButton * cancelShare;//!<取消
@property (nonatomic,strong) NSMutableArray * titleArr;
@property (nonatomic,strong) NSMutableArray * imageArr;
@property (nonatomic, assign) SharePlatformType sharePlatformType;//!<分享功能区分
@property (nonatomic, copy)ShareBlock shareBlock;
@end

@implementation ZYSocialUIManager
+ (instancetype)shareInstance{
    static ZYSocialUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYSocialUIManager alloc] init];
    });
    return instance;
}

#pragma mark --添加主控件--
-(void)s_UI{
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self.cancelShare];
    [self.window addSubview:self.shareView];
    [self createKeyboardToolsButton:self.titleArr image:self.imageArr LableColor:[UIColor grayColor]];
    [self p_hideFrame];
}
//隐藏
-(void)p_hideFrame{
    _shareView.frame =CGRectMake(0,kHeight, kWidth, (zt_shareViewH + zt_cancel_topline_margin));
    _cancelShare.frame = CGRectMake(0, kHeight, kWidth, zt_platform_cancelBtnH);
}

//展示
-(void)p_disFrame{
    _cancelShare.frame = CGRectMake(0, kHeight-zt_platform_cancelBtnH, kWidth, zt_platform_cancelBtnH);
    _shareView.frame =CGRectMake(0,kHeight-(zt_shareViewH + zt_platform_cancelBtnH + zt_cancel_topline_margin), kWidth, zt_shareViewH + zt_cancel_topline_margin);
}
#pragma mark - 展示按钮UI布局
-(void)createKeyboardToolsButton:(NSArray *)itmeArr image:(NSArray *)imageArr LableColor:(UIColor *)color
{
    for (NSInteger r = 0; r < itmeArr.count; r++) {
        UIControl * con = [_shareView viewWithTag:401+r];
        UIImageView * img = [con viewWithTag:601+r];
        UILabel * lab = [con viewWithTag:501+r];
        [img removeFromSuperview];
        [lab removeFromSuperview];
        [con removeFromSuperview];
        img = nil;
        lab = nil;
        con = nil;
    }
    CGFloat _hig = 44;
    NSInteger maxCol = 4;
    for (NSInteger i = 0; i < itmeArr.count; i++) {
        NSInteger row = i / maxCol;
        NSInteger col = i % maxCol;
        CGFloat itemW = kWidth / maxCol;
        CGFloat itemH = zt_platform_itemH;
        CGFloat margin = 0;
        CGFloat x= (itemW+margin)*col;
        CGFloat y =(itemH+margin)*row;
        UIControl *control = [[UIControl alloc]init];
        control.frame = CGRectMake(x, y, itemW, itemH);
        control.tag = 401+i;
        [control addTarget:self action:@selector(shareNewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:control];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((itemW-_hig)/2, 20, _hig, _hig)];
        imageView.tag = 601+i;
        imageView.image= [UIImage imageNamed:imageArr[i]];
        [control addSubview:imageView];
        
        UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (_hig+30), control.bounds.size.width, (24/2))];
//        titleLable.textColor = color;
        titleLable.text = itmeArr[i];
        titleLable.font = [UIFont systemFontOfSize:(24/2)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.tag = 501+i;
        [control addSubview:titleLable];
    }
}
#pragma mark - 展示
- (void)showWithPlatformSelectionBlock:(ShareBlock)shareBlock{
    _shareBlock = shareBlock;
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        [self testInit];
    }
    [self s_UI];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        [self p_disFrame];
        self->_shareView.alpha = 1;
        self->_cancelShare.alpha = 1;
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
    [UIView animateWithDuration:0.3 animations:^{
        [self p_hideFrame];
        self.alpha = 0;
        self.shareView.alpha = 0;
        self.cancelShare.alpha = 0;
        self.backgroundGrayView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.shareView = nil;
            [self.shareView removeFromSuperview];
            [self.backgroundGrayView removeFromSuperview];
            [self.cancelShare removeFromSuperview];
            [self removeFromSuperview];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [UIView commitAnimations];
}

#pragma mark - Click点击分享
-(void)shareNewClick:(UIButton *)btn{
    NSString * titleStr = _titleArr[btn.tag - 401];
    if ([titleStr isEqualToString:@"朋友圈"]) {
        self.sharePlatformType = WechatTimeLine_PlatformType;
    }else if ([titleStr isEqualToString:@"微信"]){
        self.sharePlatformType = WechatSession_PlatformType;
    }else if ([titleStr isEqualToString:@"QQ"]){
        self.sharePlatformType = QQ_PlatformType;
    }else if ([titleStr isEqualToString:@"QQ空间"]){
        self.sharePlatformType = Qzone_PlatformType;
    }else if ([titleStr isEqualToString:NSLocalizedString(@"local.dingding", @"")]){
        self.sharePlatformType = Dingding_PlatformType;
    }else{
        self.sharePlatformType = System_PlatformType;
    }
    _shareBlock(self.sharePlatformType);
    [self dismiss];
}
#pragma mark - 判断是否有分享的三方app
-(BOOL)isQQ{
    return [ZTOpenUrl isAppOpenStr:@"mqqapi://"];
}
- (BOOL)isWX{
    return [ZTOpenUrl isAppOpenStr:@"weixin://"];
}
- (BOOL)isDing{//待定
    return [ZTOpenUrl isAppOpenStr:@"dingtalk://"];
}
#pragma mark --初始化--
-(UIWindow *)window{
    if (!_window) {
        _window = [[[UIApplication sharedApplication]delegate]window];
    }
    return _window;
}
-(UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]init];
        _shareView.backgroundColor = [UIColor whiteColor];
    }
    return _shareView;
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
-(UIButton *)cancelShare{
    if (!_cancelShare) {
        _cancelShare = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_cancelShare setImage:[UIImage imageNamed:@"tool_bird_11"] forState:UIControlStateNormal];
        [_cancelShare setTitle:NSLocalizedString(@"local.cancel", @"") forState:UIControlStateNormal];
        [_cancelShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelShare.backgroundColor = [UIColor whiteColor];
        [_cancelShare addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        CALayer * leftBorder = [CALayer layer];
        leftBorder.frame = CGRectMake(0, 1,kWidth,1);
        leftBorder.backgroundColor = [UIColor grayColor].CGColor;
        [_cancelShare.layer addSublayer:leftBorder];
    }
    return _cancelShare;
}
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]init];
        if (self.isWX == YES) {
            [_titleArr addObject:@"微信"];
            [_titleArr addObject:@"朋友圈"];
        }
        if (self.isQQ == YES) {
            [_titleArr addObject:@"QQ"];
            [_titleArr addObject:@"QQ空间"];
            
        }
        if (self.isDing == YES) {
            [_titleArr addObject:NSLocalizedString(@"local.dingding", @"")];
        }
        [_titleArr addObject:@"系统分享"];
    }
    return _titleArr;
}
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc]init];
        if (self.isWX == YES == YES) {
            [_imageArr addObject:@"zysocial_wechat"];
            [_imageArr addObject:@"zysocial_wechat_timeline"];
        }
        if (self.isQQ == YES) {
            [_imageArr addObject:@"zysocial_qq"];
            [_imageArr addObject:@"zysocial_qzone"];
        }
        if (self.isDing == YES) {
            [_imageArr addObject:@"zysocial_dingding"];
        }
        [_imageArr addObject:@"zysocial_system"];
    }
    return _imageArr;
}
-(void)testInit{
    if (!_titleArr) {
        [self.titleArr addObject:@"微信"];
        [self.titleArr addObject:@"朋友圈"];
        [self.titleArr addObject:@"QQ"];
        [self.titleArr addObject:@"QQ空间"];
        [self.titleArr addObject:NSLocalizedString(@"local.dingding", @"")];
        
        [self.imageArr addObject:@"zysocial_wechat"];
        [self.imageArr addObject:@"zysocial_wechat_timeline"];
        [self.imageArr addObject:@"zysocial_qq"];
        [self.imageArr addObject:@"zysocial_qzone"];
        [self.imageArr addObject:@"zysocial_dingding"];
    }
    
}
@end
