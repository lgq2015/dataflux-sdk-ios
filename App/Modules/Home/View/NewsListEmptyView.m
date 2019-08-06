//
//  NewsListEmptyView.m
//  PWNewsList
//
//  Created by 胡蕾蕾 on 2018/9/28.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "NewsListEmptyView.h"

static const CGFloat EmptyImage_H = 100.0f;
static const CGFloat EmptyImage_W = 120.0f;
@interface NewsListEmptyView()

@end
@implementation NewsListEmptyView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    if (!_emptyImage) {
        _emptyImage = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - EmptyImage_W)/2, (CGRectGetHeight(self.frame) - EmptyImage_H)/2, EmptyImage_W, EmptyImage_H)];
        _emptyImage.contentMode = UIViewContentModeScaleAspectFit;
        _emptyImage.image = [UIImage imageNamed:@"icon_no_message"];
        [self addSubview:_emptyImage];
    }
    
    if (!_emptyLb) {
        _emptyLb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_emptyImage.frame), CGRectGetWidth(self.frame), 40)];
        _emptyLb.textColor = [UIColor colorWithHexString:@"#999999"];
        _emptyLb.text = NSLocalizedString(@"local.NoList", @"");
        _emptyLb.font = [UIFont systemFontOfSize:14];
        _emptyLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_emptyLb];
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
