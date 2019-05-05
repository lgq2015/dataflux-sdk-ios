//
//  ZTChangeTeamNavView.m
//  123
//
//  Created by tao on 2019/5/1.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTChangeTeamNavView.h"
#import <Masonry.h>
#define TitleMaxW 200.0
@interface ZTChangeTeamNavView()
@property (nonatomic, copy)NSString *titleString;
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, assign)CGFloat navViewLeftBtnW;
@end
@implementation ZTChangeTeamNavView

- (instancetype)initWithTitle:(NSString *)titleString font:(UIFont *)font{
    _font = font;
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
        self.navViewLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
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
}
#pragma mark ---lazy---
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
        self.navViewLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
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
@end
