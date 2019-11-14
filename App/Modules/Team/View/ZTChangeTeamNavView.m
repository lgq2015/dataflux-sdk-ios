//
//  ZTChangeTeamNavView.m
//  123
//
//  Created by tao on 2019/5/1.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTChangeTeamNavView.h"
#import "TeamInfoModel.h"
#import "ZYChangeTeamUIManager.h"

#import <Masonry.h>
#define TitleMaxW 250.0
@interface ZTChangeTeamNavView()
@property (nonatomic, copy)NSString *titleString;
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, assign)CGFloat navViewLeftBtnW;
@property (nonatomic, assign)CGFloat offset;

@property (nonatomic, strong) ZYChangeTeamUIManager *changeTeamView;

@end

@implementation ZTChangeTeamNavView

- (instancetype)initWithTitle:(NSString *)titleString font:(UIFont *)font showWithOffsetY:(CGFloat)offset{
    _font = font;
    _offset = offset;
    _titleString = titleString;
    if (self = [super init]){
        [self s_UI];
    }
    return self;
}

- (void)s_UI{
    _navViewLeftBtnW =  [self getMemberNameWidth:_titleString withFont:_font];
    self.navViewLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (_navViewLeftBtnW > TitleMaxW){
        _navViewLeftBtnW = TitleMaxW;
        self.navViewLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    }
    [self.navViewLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.offset(_navViewLeftBtnW);
    }];
    [self.navViewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navViewLeftBtn.mas_centerY);
        make.left.equalTo(self.navViewLeftBtn.mas_right).offset(7);
        make.width.height.offset(self.navViewImageView.bounds.size.width);
        make.right.equalTo(self.mas_right);
    }];
    NSString *titleString;
       if([getTeamState isEqualToString:PW_isTeam]){
           titleString = userManager.teamModel.name;
       }else{
           titleString = NSLocalizedString(@"local.MyTeam", @"");
       }
       
       [self.navViewLeftBtn addTarget:self action:@selector(navLeftBtnclick:) forControlEvents:UIControlEventTouchUpInside];
       self.navViewImageView.userInteractionEnabled = YES;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopArrow:)];
       [self.navViewImageView addGestureRecognizer:tap];
}
- (void)navLeftBtnclick:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    sender.selected = !sender.selected;
    //设置动画
    [UIView animateWithDuration:0.2 animations:^{
        if (sender.selected){
            self.navViewImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            self.navViewImageView.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
        }
    } completion:^(BOOL finished) {
        sender.userInteractionEnabled = YES;
    }];
    //显示
    if (sender.isSelected){
        [self.changeTeamView showWithOffsetY:_offset];
    }else{
        [self.changeTeamView  dismiss];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeTeamViewShow)]) {
        [self.delegate changeTeamViewShow];
    }
}

#pragma mark ---lazy---
-(ZYChangeTeamUIManager *)changeTeamView{
    if (!_changeTeamView) {
        _changeTeamView = [[ZYChangeTeamUIManager alloc]init];
        _changeTeamView.fromVC = self.viewController;
        WeakSelf
        _changeTeamView.dismissedBlock = ^(BOOL isDismissed) {
            if (isDismissed){
                weakSelf.navViewLeftBtn.selected = NO;
                //设置动画
                weakSelf.navViewLeftBtn.userInteractionEnabled = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.navViewImageView.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
                } completion:^(BOOL finished) {
                    weakSelf.navViewLeftBtn.userInteractionEnabled = YES;
                }];
            }
        };
    }
    return _changeTeamView;
}
- (void)tapTopArrow:(UITapGestureRecognizer *)ges{
    [self navLeftBtnclick:self.navViewLeftBtn];
   
}
- (UIButton *)navViewLeftBtn{
    if (!_navViewLeftBtn){
        _navViewLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navViewLeftBtn setTitleColor:[UIColor colorWithHexString:@"#140F26"] forState:UIControlStateNormal];
        [_navViewLeftBtn setTitle:_titleString forState:UIControlStateNormal];
        _navViewLeftBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _navViewLeftBtn.titleLabel.font = _font;
        [self addSubview:_navViewLeftBtn];
    }
    return _navViewLeftBtn;
}
- (UIImageView *)navViewImageView{
    if (!_navViewImageView){
        _navViewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
        [self addSubview:_navViewImageView];
    }
    return _navViewImageView;
}
#pragma mark ===获取显示文字的宽度=======
- (CGFloat)getMemberNameWidth:(NSString *)str withFont:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return ceil(rect.size.width);
}
#pragma mark ===修改标题====
- (void)changeTitle:(NSString *)string{
    [self.navViewLeftBtn setTitle:string forState:UIControlStateNormal];
    _navViewLeftBtnW =  [self getMemberNameWidth:string withFont:self.navViewLeftBtn.titleLabel.font];
    self.navViewLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (_navViewLeftBtnW > TitleMaxW){
        _navViewLeftBtnW = TitleMaxW;
        self.navViewLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    }
    [self.navViewLeftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(_navViewLeftBtnW);
    }];
}
#pragma mark ====获取NavView的frame
- (CGRect)getChangeTeamNavViewFrame:(BOOL)isSwitch{
    CGFloat width = _navViewLeftBtnW + 7 + self.navViewImageView.bounds.size.width;
    CGFloat height = 44;
    if (isSwitch){
        return CGRectMake(20, 0, width, height);
    }else{
        return CGRectMake(0, 0, width, height);
    }
}
- (void)dissMissView{
    [self.changeTeamView dismiss];
}
@end
