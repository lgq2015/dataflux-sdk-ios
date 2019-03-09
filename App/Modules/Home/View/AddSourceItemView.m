//
//  AddSourceItemView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddSourceItemView.h"
@interface AddSourceItemView ()
@property (nonatomic, strong) UILabel *titleLab;

@end
@implementation AddSourceItemView
-(void)setFrame:(CGRect)frame{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0f;
    [super setFrame:frame];
}
-(void)setData:(NSDictionary *)data{
    _data = data;
    UIView *left = nil;
    DLog(@"%@",self.data[@"title"]);
    self.titleLab.text = self.data[@"title"];
    NSArray *array = data[@"datas"];
    for (NSInteger i=0; i<array.count; i++) {
        UIView *button = [self itemView:i];
        [self addSubview:button];
        if (i<4) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (!left) {
                    make.left.mas_equalTo(self).offset(Interval(15));
                }else{
                    make.left.mas_equalTo(left.mas_right).offset(Interval(20));
                }
                make.top.mas_equalTo(self.titleLab.mas_bottom).offset(ZOOM_SCALE(6));
                make.width.offset(button.width);
                make.height.offset(ZOOM_SCALE(80));
            }];
            left = button;
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(Interval(15));
                make.top.mas_equalTo(left.mas_bottom).offset(ZOOM_SCALE(8));
                make.width.offset(button.width);
                make.height.offset(ZOOM_SCALE(80));
            }];
        }
   
    }
}
-(UIView *)itemView:(NSInteger)index{
    NSArray *array = self.data[@"datas"];
    NSDictionary *dict = array[index];
    UIView *item = [[UIView alloc]initWithFrame:CGRectZero];
    item.tag = 1+index;
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(6), ZOOM_SCALE(56), ZOOM_SCALE(38))];
    [item addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(item.mas_centerX);
        make.top.mas_equalTo(item).offset(ZOOM_SCALE(6));
        make.width.offset(ZOOM_SCALE(56));
        make.height.offset(ZOOM_SCALE(38));
    }];
    icon.image = [UIImage imageNamed:dict[@"icon"]];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectZero];
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    name.text = dict[@"name"];
    name.textAlignment = NSTextAlignmentCenter;
    if ([self.data[@"type"] isEqual:@1]) {
        name.textColor = PWTitleColor;
    }else{
        name.textColor = [UIColor colorWithHexString:@"8E8E93"];
    }
    [item addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(item).offset(ZOOM_SCALE(57));
        make.left.mas_equalTo(item);
        make.right.mas_equalTo(item);
        make.height.offset(ZOOM_SCALE(20));
    }];
    CGSize size = [name sizeThatFits:CGSizeZero];
    if (size.width>ZOOM_SCALE(62)) {
        item.frame = CGRectMake(0, 0, size.width, ZOOM_SCALE(80));
    }else{
        item.frame = CGRectMake(0, 0, ZOOM_SCALE(62), ZOOM_SCALE(80));
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
    
    [item addGestureRecognizer:tap];
    return item;
}
- (void)itemClick:(UITapGestureRecognizer *)tap{
    if (self.itemClick) {
        self.itemClick(tap.view.tag-1);
    }
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(22), ZOOM_SCALE(12), 200, ZOOM_SCALE(25))];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        _titleLab.textColor = PWTextBlackColor;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
