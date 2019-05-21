//
//  IssueDtealsBV.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueDtealsBV.h"
@interface IssueDtealsBV()
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, copy)   UILabel *commentTextLab;
@property (nonatomic, strong) UIImageView *typeIcon;
@end
@implementation IssueDtealsBV
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    [self addSubview:self.commentBtn];
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    topLine.tag = 33;
    [[self viewWithTag:33] removeFromSuperview];
    [self addSubview:topLine];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, kWidth, 0.5)];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    bottomLine.tag = 34;
    [[self viewWithTag:34] removeFromSuperview];
    
    [self addSubview:bottomLine];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickComentlab)];
    [self addGestureRecognizer:tap];
    self.typeIcon.image = [UIImage imageNamed:@"reply_big"];
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down"]];
    arrow.tag = 35;
    [[self viewWithTag:35] removeFromSuperview];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeIcon.mas_right).offset(Interval(6));
        make.centerY.mas_equalTo(self.typeIcon);
        make.width.height.offset(ZOOM_SCALE(18));
    }];
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = PWWhiteColor;
    [self addSubview:contentView];
    [contentView.layer setBorderColor:[UIColor colorWithHexString:@"#E8E8E8"].CGColor];
    [contentView.layer setBorderWidth:1];
    [contentView.layer setCornerRadius:4.0f];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(arrow.mas_right).offset(10);
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.height.offset(ZOOM_SCALE(45));
    }];
    [contentView addSubview:self.commentTextLab];
    [self.commentTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(18);
        make.right.equalTo(contentView).offset(-16);
        make.centerY.equalTo(self);
        make.height.offset(ZOOM_SCALE(45));
    }];
    
}
#pragma mark ========== lazy ==========
-(UIImageView *)typeIcon{
    if (!_typeIcon) {
        _typeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(15), ZOOM_SCALE(19), ZOOM_SCALE(28), ZOOM_SCALE(28))];
        [self addSubview:_typeIcon];
    }
    return _typeIcon;
}

- (UILabel *)commentTextLab{
    if (!_commentTextLab){
        _commentTextLab = [[UILabel alloc] init];
        _commentTextLab.text = @"添加评论";
        _commentTextLab.textColor = [UIColor colorWithHexString:@"#C7C7CC"];
        _commentTextLab.userInteractionEnabled = YES;
        _commentTextLab.backgroundColor = [UIColor whiteColor];
    }
    return _commentTextLab;
}



- (void)setOldStr:(NSString *)oldStr{
    _oldStr = oldStr;
    if (oldStr.length==0) {
        _commentTextLab.text = @"添加评论";
        _commentTextLab.textColor = [UIColor colorWithHexString:@"#C7C7CC"];
    }else{
        _commentTextLab.text = oldStr;
        _commentTextLab.textColor = PWTitleColor;
    }
}

- (void)clickComentlab{
    if (self.delegate && [self.delegate respondsToSelector:@selector(issueDtealsBVClick)]) {
        [self.delegate issueDtealsBVClick];
    }
}
-(void)setImgWithStates:(IssueDealState)states{
    switch (states) {
        case IssueDealStateChat:
            self.typeIcon.image = [UIImage imageNamed:@"reply_g"];
            break;
        case IssueDealStateDeal:
            self.typeIcon.image = [UIImage imageNamed:@"deal_g"];
          
            break;
        case IssueDealStateSolve:
            self.typeIcon.image = [UIImage imageNamed:@"solve_g"];
           
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
