//
//  BadgeButton.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BadgeButton.h"
@interface BadgeButton()
@property (nonatomic, strong) UILabel *badgeLab;

@end
@implementation BadgeButton
-(instancetype)init{
    self = [super init];
    if (self) {
        _badgeLab = [[UILabel alloc]init];
        _badgeLab.backgroundColor = RGBACOLOR(251, 85, 85, 1);
        _badgeLab.font = [UIFont systemFontOfSize:10];
        _badgeLab.textColor = [UIColor whiteColor];
        _badgeLab.clipsToBounds = YES;
        _badgeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_badgeLab];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setSubFrame];
}
-(void)setSubFrame{
    CGFloat badgeW,badgeH;
    [self showText];
    if (_isRedBall) {
        badgeW = 8;
        badgeH = 8;
    }else{
        badgeH = 15;
        badgeW =  [_badgeLab sizeThatFits:CGSizeMake(MAXFLOAT, badgeH)].width + 5;
        if (badgeW > 40) {
            badgeW = 40;
        }
        if (badgeW < badgeH) {
            badgeW = badgeH;
        }
        _badgeLab.frame = CGRectMake(0, 0, badgeW, badgeH);
        _badgeLab.layer.cornerRadius = badgeH / 2;
    }
    if (self.imageView.image) {
        CGPoint center = CGPointMake(CGRectGetMaxX(self.imageView.frame), self.imageView.frame.origin.y);
        _badgeLab.center = center;
    }else{
        CGPoint center = CGPointMake(self.bounds.size.width, self.bounds.origin.y);
        _badgeLab.center = center;
    }
}
- (void)setBadgeValue:(NSInteger)badgeValue{
    _badgeValue = badgeValue;
    [self setSubFrame];
}
-(void)showText{
    if (_badgeValue<=0) {
        _badgeLab.hidden = YES;
    }else{
        _badgeLab.hidden = NO;
    }
    if (_isRedBall) {
        _badgeLab.text = @"";
    }else{
        if (_badgeValue>99) {
            _badgeLab.text = @"99+";
        }else{
            _badgeLab.text = [NSString stringWithFormat:@"%ld",(long)_badgeValue];
        }
    }
}
@end
