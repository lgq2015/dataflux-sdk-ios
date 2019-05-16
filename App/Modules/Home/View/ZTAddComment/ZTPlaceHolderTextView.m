//
//  ZTPlaceHolderTextView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTPlaceHolderTextView.h"
#import <Masonry.h>
#define kWidth [UIScreen mainScreen].bounds.size.width

@interface ZTPlaceHolderTextView()
@property (nonatomic, strong)UILabel *zt_placeHolderLab;
//最后一次变化的高度
@property (nonatomic, assign)CGFloat lastHeight;
@end
@implementation ZTPlaceHolderTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange) name:UITextViewTextDidChangeNotification object:nil];
        [self s_UI];
    }
    return self;
}

- (void)s_UI{
    self.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.zt_placeHolderLab];
    [self.zt_placeHolderLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(6);
    }];
}
#pragma mark --通知回调---
- (void)didChange{
    if (self.text.length > 0){
        self.zt_placeHolderLab.hidden = YES;
    }else{
        self.zt_placeHolderLab.hidden = NO;
    }
    CGFloat h = [self height];
    if (_lastHeight != h){
        NSLog(@"height---%f",h);
        _lastHeight = h;
        if (_zt_delegate && [self.zt_delegate respondsToSelector:@selector(textViewHeigthChange:)]){
            [self.zt_delegate textViewHeigthChange:self];
        }
    }
}

#pragma mark --lazy--
- (UILabel *)zt_placeHolderLab{
    if (!_zt_placeHolderLab){
        _zt_placeHolderLab = [[UILabel alloc] init];
        _zt_placeHolderLab.text = @"输入您的内容";
        _zt_placeHolderLab.font = self.font;
        _zt_placeHolderLab.textColor = [UIColor lightGrayColor];
        _zt_placeHolderLab.hidden = NO;
    }
    return _zt_placeHolderLab;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)height{
    CGFloat height = [self zt_getHeight:self.font width:kWidth - 26];
    return height + 15;
}
- (void)setOldCommentData:(NSString *)oldCommentData{
    _oldCommentData = oldCommentData;
    if (oldCommentData.length > 0){
        self.text = oldCommentData;
        if (self.text.length > 0){
            self.zt_placeHolderLab.hidden = YES;
        }else{
            self.zt_placeHolderLab.hidden = NO;
        }
    }
}
//计算文本高度
- (CGFloat)zt_getHeight:(UIFont *)zt_font width:(CGFloat)width{
    CGSize infoSize = CGSizeMake(width - self.textContainer.lineFragmentPadding * 2 , MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName : zt_font};
    CGRect infoRect =   [self.text boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat height = ceil(infoRect.size.height);
    return height;
}



@end

