//
//  ZTPopCommentToolView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTPopCommentToolView.h"
#import <Masonry.h>
@interface ZTPopCommentToolView()
@property (nonatomic, strong)UIButton *photoBtn;
@property (nonatomic, strong)UIButton *atBtn;
@property (nonatomic, strong)UIButton *sendBtn;
@end
@implementation ZTPopCommentToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self s_UI];
    }
    return self;
}

- (void)s_UI{
    [self addSubview:self.photoBtn];
    [self addSubview:self.atBtn];
    [self addSubview:self.sendBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@44);
    }];
    [self.atBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoBtn);
        make.width.height.equalTo(self.photoBtn);
        make.left.equalTo(self.photoBtn.mas_right);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.height.equalTo(self.atBtn);
    }];
}

#pragma mark ---lazy---
- (UIButton *)photoBtn{
    if (!_photoBtn){
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    return _photoBtn;
}
- (UIButton *)atBtn{
    if (!_atBtn){
        _atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_atBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    return _atBtn;
}
- (UIButton *)sendBtn{
    if (!_sendBtn){
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor redColor];
    }
    return _sendBtn;
}
@end
