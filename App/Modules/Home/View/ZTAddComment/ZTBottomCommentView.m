//
//  ZTBottomCommentView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTBottomCommentView.h"
#import "ZTPopCommentView.h"
#import <Masonry.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface ZTBottomCommentView()<UITextFieldDelegate>
@property (nonatomic, strong)UIButton *commentBtn;
@property (nonatomic, strong)UIImageView *arrowImageView;
@property (nonatomic, copy)UILabel *commentTextLab;
@property (nonatomic, strong)ZTPopCommentView *popCommentView;

@end
@implementation ZTBottomCommentView
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
    [self addSubview:self.commentTextLab];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@100);
    }];
    [self.commentTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentBtn.mas_right).offset(10);
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.height.equalTo(@36);
    }];
    
}

#pragma mark ---lazy--
- (UIButton *)commentBtn{
    if (!_commentBtn){
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.backgroundColor = [UIColor redColor];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    return _commentBtn;
}

- (UILabel *)commentTextLab{
    if (!_commentTextLab){
        _commentTextLab = [[UILabel alloc] init];
        _commentTextLab.text = @"添加评论";
        _commentTextLab.textColor = [UIColor grayColor];
        _commentTextLab.userInteractionEnabled = YES;
        _commentTextLab.layer.cornerRadius = 4;
        _commentTextLab.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickComentlab)];
        [_commentTextLab addGestureRecognizer:tap];
    }
    return _commentTextLab;
}

- (void)clickComentlab{
    _popCommentView = [[ZTPopCommentView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, 200)];
    _popCommentView.oldData = self.olddata;
}
- (void)setOlddata:(NSString *)olddata{
    _olddata = olddata;
    _commentTextLab.text = olddata;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
