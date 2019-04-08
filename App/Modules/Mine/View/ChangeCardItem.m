//
//  ChangeCardItem.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChangeCardItem.h"

@implementation ChangeCardItem

-(instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.06;
        [self createUI:data];
    }
    return self;
}
- (void)createUI:(NSDictionary *)data{
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:data[@"icon"]];
  
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(24));
        make.width.height.offset(ZOOM_SCALE(36));
        make.centerY.mas_equalTo(self);
    }];
    NSString *phone =data[@"phone"];
    if (phone.length==11) {
        phone =[NSString stringWithFormat:@"%@******%@",[phone substringToIndex:3],[phone substringFromIndex:9]];
    }
    UILabel *phoneLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:[UIColor colorWithHexString:@"595860"] text:phone];
    [self addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(26));
        make.top.mas_equalTo(self).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:[UIFont systemFontOfSize:14] textColor:textColorNormalState text:data[@"tip"]];
    [self addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLab.mas_left);
        make.top.mas_equalTo(phoneLab.mas_bottom).offset(Interval(4));
        make.height.offset(ZOOM_SCALE(20));
    }];
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextbig"]];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-Interval(24));
        make.width.offset(ZOOM_SCALE(12));
        make.height.offset(ZOOM_SCALE(24));
        make.centerY.mas_equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
    [self addGestureRecognizer:tap];
    
}
- (void)itemClick:(UITapGestureRecognizer *)tap{
    if (self.itemClick) {
        self.itemClick();
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowRadius = 1;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 5;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
