//
//  ZTPopCommentToolView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTPopCommentToolView.h"
@interface ZTPopCommentToolView()

@end
@implementation ZTPopCommentToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self s_UI];
    }
    return self;
}

- (void)s_UI{
    self.backgroundColor = PWWhiteColor;
    [self addSubview:self.photoBtn];
    [self addSubview:self.atBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.mas_equalTo(self);
        make.width.height.offset(ZOOM_SCALE(20));
    }];
    [self.atBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoBtn);
        make.width.height.equalTo(self.photoBtn);
        make.left.mas_equalTo(self.photoBtn.mas_right).offset(14);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.offset(ZOOM_SCALE(40));
        make.height.mas_equalTo(self);
    }];
}

#pragma mark ---lazy---
- (UIButton *)photoBtn{
    if (!_photoBtn){
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setImage:[UIImage imageNamed:@"uploadimg"] forState:UIControlStateNormal];
    }
    return _photoBtn;
}
- (UIButton *)atBtn{
    if (!_atBtn){
        _atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_atBtn setImage:[UIImage imageNamed:@"pw_icon_call_person"] forState:UIControlStateNormal];
    }
    return _atBtn;
}
- (UIButton *)sendBtn{
    if (!_sendBtn){
        _sendBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"发送"];
        _sendBtn.titleLabel.font = RegularFONT(16);
        [self addSubview:_sendBtn];
   
    }
    return _sendBtn;
}
- (void)photoBtnClick{
    
}
- (void)atBtnClick{
    
}
- (void)sendBtnClick{
    
}
@end
