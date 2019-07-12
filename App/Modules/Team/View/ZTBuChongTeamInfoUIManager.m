//
//  ZTBuChongTeamInfoUIManager.m
//  App
//
//  Created by tao on 2019/5/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTBuChongTeamInfoUIManager.h"
#define BuquanTeamInfoViewH 150.0

@interface ZTBuChongTeamInfoUIManager()
@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View
@property (nonatomic,strong) UIView * buquanTeamInfoView;//!<补全团队信息
@property (nonatomic, strong) UILabel *topTileLab;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView * line;
@property (nonatomic, copy)ClickBuChongBlock clickBuChongBlock;
@end
@implementation ZTBuChongTeamInfoUIManager
+ (instancetype)shareInstance{
    static ZTBuChongTeamInfoUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZTBuChongTeamInfoUIManager alloc] init];
    });
    return instance;
}


#pragma mark --添加主控件--
-(void)s_UI{
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self.buquanTeamInfoView];
    [self.buquanTeamInfoView addSubview:self.topTileLab];
    [self.buquanTeamInfoView addSubview:self.line];
    [self.buquanTeamInfoView addSubview:self.messageLab];
    [self.buquanTeamInfoView addSubview:self.cancelBtn];
    [self p_hideFrame];
    [self s_childUI];
}

//隐藏
-(void)p_hideFrame{
    _buquanTeamInfoView.frame =CGRectMake(0,kHeight, kWidth, BuquanTeamInfoViewH);
}

//展示
-(void)p_disFrame{
    _buquanTeamInfoView.frame =CGRectMake(0,kHeight-BuquanTeamInfoViewH, kWidth, BuquanTeamInfoViewH);
}
#pragma mark - 布局子控件
- (void)s_childUI{
    [self.topTileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buquanTeamInfoView);
        make.left.equalTo(self.buquanTeamInfoView);
        make.right.equalTo(self.buquanTeamInfoView);
        make.height.equalTo(@56);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTileLab.mas_bottom);
        make.left.equalTo(self.topTileLab.mas_left);
        make.right.equalTo(self.topTileLab.mas_right);
        make.height.equalTo(@1);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom);
        make.left.equalTo(self.line);
        make.right.equalTo(self.line);
        make.height.equalTo(@44);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLab.mas_bottom).offset(6);
        make.left.equalTo(self.messageLab);
        make.right.equalTo(self.messageLab);
        make.height.equalTo(@44);
    }];
}
#pragma mark - 展示
- (void)show:(ClickBuChongBlock)clickBuChongBlock{
    _clickBuChongBlock = clickBuChongBlock;
    [self s_UI];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_disFrame];
        self->_buquanTeamInfoView.alpha = 1;
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
        self.buquanTeamInfoView.alpha = 0;
        self.backgroundGrayView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.buquanTeamInfoView removeFromSuperview];
            self.buquanTeamInfoView = nil;
            [self.backgroundGrayView removeFromSuperview];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [UIView commitAnimations];
}

#pragma mark -  按钮交互事件

#pragma mark --lazy--
-(UIWindow *)window{
    if (!_window) {
        _window = [[[UIApplication sharedApplication]delegate]window];
    }
    return _window;
}
-(UIView *)buquanTeamInfoView{
    if (!_buquanTeamInfoView) {
        _buquanTeamInfoView = [[UIView alloc]init];
        _buquanTeamInfoView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }
    return _buquanTeamInfoView;
}
-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,0, kWidth, kHeight);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_backgroundGrayView addGestureRecognizer:tap];
        
    }
    return _backgroundGrayView;
}

- (UILabel *)topTileLab{
    if (!_topTileLab){
        _topTileLab = [[UILabel alloc] init];
        _topTileLab.text = @"此功能需要补充完整团队信息方可使用";
        _topTileLab.font = RegularFONT(14);
        _topTileLab.backgroundColor = [UIColor whiteColor];
        _topTileLab.textColor = [UIColor colorWithHexString:@"#8E8E93"];
        _topTileLab.textAlignment = NSTextAlignmentCenter;
    }
    return _topTileLab;
}
- (UIView *)line{
    if (!_line){
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }
    return _line;
}
- (UILabel *)messageLab{
    if (!_messageLab){
        _messageLab = [[UILabel alloc] init];
        _messageLab.textColor = [UIColor colorWithHexString:@"#2A7AF7"];
        _messageLab.font = RegularFONT(17);
        _messageLab.text = @"补充团队信息";
        _messageLab.backgroundColor = [UIColor whiteColor];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.userInteractionEnabled = YES;
        __weak typeof(self) weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf dismiss];
            weakSelf.clickBuChongBlock();
        }];
        [_messageLab addGestureRecognizer:tap];
    }
    return _messageLab;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:NSLocalizedString(@"local.cancel", @"") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = RegularFONT(17);
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#140F26"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
