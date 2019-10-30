//
//  EchartListView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "EchartListView.h"

@implementation EchartListView
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self) {
        self= [super init];
        [self createListWithDict:dict];
    }
    return self;
}
- (void)createListWithDict:(NSDictionary *)dict{
    if([dict[@"body"] isKindOfClass:NSArray.class]){
        NSArray *body = dict[@"body"];
        UIView *temp = nil;
        for (NSInteger i=0;i<body.count;i++) {
            NSString *string =  [body[i] isKindOfClass:[NSString class]]?body[i]:((NSNumber *)body[i]).description;
            UIView *dot = [[UIView alloc]init];
            dot.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
            dot.layer.cornerRadius = 4.0f;
            [self addSubview:dot];
            UILabel *equityLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTitleColor text:string];
            
            [self addSubview:equityLab];
            
            [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(Interval(16));
                if (temp == nil) {
                    make.top.mas_equalTo(self).offset(5);
                }else{
                    make.top.mas_equalTo(temp.mas_bottom).offset(ZOOM_SCALE(16));
                }
                make.width.height.offset(ZOOM_SCALE(8));
            }];
            temp = dot;
            [equityLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(dot.mas_right).offset(Interval(8));
                make.centerY.mas_equalTo(dot);
                make.height.offset(ZOOM_SCALE(20));
                if (i==body.count-1) {
                    make.bottom.mas_equalTo(self).offset(-Interval(16));
                }
            }];
        }
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
