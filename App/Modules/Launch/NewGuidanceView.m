//
//  NewGuidanceView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NewGuidanceView.h"
@interface NewGuidanceView()
@property (nonatomic, strong) UIView *contentView;
@end
@implementation NewGuidanceView
-(instancetype)init{
    if (self) {
        self= [super init];
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.userInteractionEnabled = YES;
   
    //kTopHeight+16
    UIImageView *infoSourceImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_first1"]];
    [self addSubview:infoSourceImg];
    [infoSourceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kTopHeight+18);
        make.right.mas_equalTo(self).offset(5);
        make.width.offset(ZOOM_SCALE(82));
        make.height.offset(ZOOM_SCALE(37));
    }];
    UIImageView *contentImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_firsttext"]];
    [self addSubview:contentImg];
    [contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoSourceImg.mas_bottom).offset(6);
        make.right.mas_equalTo(self).offset(-22);
        make.width.offset(ZOOM_SCALE(327));
        make.height.offset(ZOOM_SCALE(245));
    }];
    UIImageView *subBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_firstsubbtn"]];
    [self addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.offset(ZOOM_SCALE(210));
        make.height.offset(ZOOM_SCALE(95));
        make.bottom.mas_equalTo(self).offset(-60-kTabBarHeight);
    }];
    subBtn.userInteractionEnabled = YES;
     [subBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
}
- (void)showInView:(UIView *)view{
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
}
- (void)disMissView{
    [self removeFromSuperview];
    [_contentView removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
