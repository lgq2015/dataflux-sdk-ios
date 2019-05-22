//
//  ChatInputHeaderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChatInputHeaderView.h"
@interface ChatInputHeaderView()
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIImageView *stateIcon;
@end
@implementation ChatInputHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = PWWhiteColor;
    [self addSubview:self.commentBtn];
    [self addSubview:self.unfoldBtn];
    [self.stateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.width.height.offset(ZOOM_SCALE(20));
    }];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(self.stateIcon);
        make.left.equalTo(self.stateIcon.mas_right).offset(10);
    }];
    UIButton *arrow = [[UIButton alloc]init];
    [arrow setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [arrow addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentBtn.mas_right).offset(8);
        make.centerY.width.mas_equalTo(self.stateIcon);
        make.width.height.offset(ZOOM_SCALE(16));
    }];
    [self.unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@44);
    }];
}
-(void)setState:(IssueDealState)state{
    switch (state) {
        case IssueDealStateChat:
            self.stateIcon.image = [UIImage imageNamed:@"reply_g"];
            [self.commentBtn setTitle:@"回复" forState:UIControlStateNormal];
            break;
        case IssueDealStateDeal:
            self.stateIcon.image = [UIImage imageNamed:@"deal_g"];
            [self.commentBtn setTitle:@"处理" forState:UIControlStateNormal];
            break;
        case IssueDealStateSolve:
            self.stateIcon.image = [UIImage imageNamed:@"solve_g"];
            [self.commentBtn setTitle:@"解决" forState:UIControlStateNormal];
            break;
    }
}
#pragma mark ========== lazy ==========
- (UIButton *)commentBtn{
    if (!_commentBtn){
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:PWTitleColor forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.titleLabel.font = RegularFONT(14);
    }
    return _commentBtn;
}
- (UIButton *)unfoldBtn{
    if (!_unfoldBtn){
        _unfoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unfoldBtn setImage:[UIImage imageNamed:@"unfold_a"] forState:UIControlStateNormal];
        [_unfoldBtn setImage:[UIImage imageNamed:@"shrink_a"] forState:UIControlStateSelected];
        
    }
    return _unfoldBtn;
}
-(UIImageView *)stateIcon{
    if (!_stateIcon) {
        _stateIcon = [[UIImageView alloc]init];
        [self addSubview:_stateIcon];
    }
    return _stateIcon;
}
#pragma mark ========== Click ==========
- (void)commentBtnClick{
    if (self.changeChatStateClick) {
        self.changeChatStateClick();
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
