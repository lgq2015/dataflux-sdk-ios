//
//  ZTPopCommentTopView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTPopCommentTopView.h"
#import <Masonry.h>
@interface ZTPopCommentTopView()
@property (nonatomic, strong)UIButton *commentBtn;
@end

@implementation ZTPopCommentTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self s_UI];
    }
    return self;
}

- (void)s_UI{
    [self addSubview:self.commentBtn];
    [self addSubview:self.zhankaiBtn];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@100);
    }];
    [self.zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@44);
    }];
}
#pragma mark ---lazy--
- (UIButton *)commentBtn{
    if (!_commentBtn){
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.backgroundColor = [UIColor redColor];
        [_commentBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"回复" forState:UIControlStateNormal];
    }
    return _commentBtn;
}
- (UIButton *)zhankaiBtn{
    if (!_zhankaiBtn){
        _zhankaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zhankaiBtn.backgroundColor = [UIColor redColor];
        [_zhankaiBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    return _zhankaiBtn;
}
@end
