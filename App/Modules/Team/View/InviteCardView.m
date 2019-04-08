//
//  InviteCardView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InviteCardView.h"
@interface InviteCardView ()

@end
@implementation InviteCardView
-(instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 0.06;
        self.layer.cornerRadius = 8.0f;
        [self createUIWithDict:dict];
    }
    return self;
}
- (void)createUIWithDict:(NSDictionary *)dict{
   
    self.backgroundColor = PWWhiteColor;
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"icon"]]];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(16));
        make.width.height.offset(ZOOM_SCALE(28));
        make.centerY.mas_equalTo(self);
    }];
    
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:dict[@"title"]];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(22));
        make.centerY.mas_equalTo(icon);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowRadius = 1;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 10;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 10;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
