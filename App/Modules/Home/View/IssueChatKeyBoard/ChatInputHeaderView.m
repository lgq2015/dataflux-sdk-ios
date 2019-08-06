//
//  ChatInputHeaderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChatInputHeaderView.h"
#import "TouchLargeButton.h"

@interface ChatInputHeaderView()
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) TouchLargeButton *stateIcon;
@property (nonatomic, assign) IssueDealState state;

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

    [self.unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@44);
    }];
   
}

#pragma mark ========== lazy ==========
- (UIButton *)commentBtn{
    if (!_commentBtn){
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitle:NSLocalizedString(@"local.reply", @"") forState:UIControlStateNormal];
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
-(UIButton *)stateIcon{
    if (!_stateIcon) {
        _stateIcon = [[TouchLargeButton alloc]init];
        [_stateIcon addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_stateIcon setImage:[UIImage imageNamed:@"reply_g"] forState:UIControlStateNormal];
        [self addSubview:_stateIcon];
    }
    return _stateIcon;
}
#pragma mark ========== Click ==========
- (void)commentBtnClick{
//    if (self.changeChatStateClick) {
//        self.changeChatStateClick();
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
