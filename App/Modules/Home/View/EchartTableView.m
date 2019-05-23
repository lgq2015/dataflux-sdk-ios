//
//  EchartTableView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "EchartTableView.h"

@implementation EchartTableView
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self) {
        self= [super init];
        
        [self createTableWithData:dict];
    }
    return self;
}
-(void)createTableWithData:(NSDictionary *)data{
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:data[@"title"]];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(16));
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-Interval(16));
    }];
    
    NSArray *header = data[@"header"];
    NSArray *body = data[@"body"];
    UIView *temp = titleLab;
    for (NSInteger i=0; i<body.count; i++) {
        UIView *table = [self createTableWithData:body[i] header:header];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(temp.mas_bottom).offset(Interval(12));
            make.left.mas_equalTo(self).offset(Interval(16));
            make.right.mas_equalTo(self).offset(-Interval(16));
            if (i==body.count-1) {
                make.bottom.mas_equalTo(self).offset(-Interval(12));
            }
        }];
        temp = table;
    }
    if(body.count == 0 && header.count>0){
        UIView *table = [self createTableWithData:@[] header:header];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(temp.mas_bottom).offset(Interval(12));
            make.left.mas_equalTo(self).offset(Interval(16));
            make.right.mas_equalTo(self).offset(-Interval(16));
            make.bottom.mas_equalTo(self).offset(-Interval(12));
        }];
    }

}
-(UIView *)createTableWithData:(NSArray *)date header:(nonnull NSArray *)header{
    UIView *view = [[UIView alloc]init];
    view.layer.shadowOffset = CGSizeMake(0,2);
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius = 8;
    view.layer.shadowOpacity = 0.06;
    view.layer.cornerRadius = 6;
    view.backgroundColor = PWWhiteColor;
    [self addSubview:view];
    UIView *temp = nil;
    for (NSInteger i=0;i<header.count;i++) {
        NSString *headerStr = [header[i] isKindOfClass:NSNull.class]?@"":header[i];
        NSString *dataStr;
        if (date.count>0) {
            dataStr =  [date[i] isKindOfClass:NSNull.class]?@"":date[i];
        }else{
            dataStr = @"";
        }
        NSString *string = [NSString stringWithFormat:@"%@：%@",headerStr,dataStr];
        
        UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextColor text:string];
        title.numberOfLines = 0;
        [view addSubview:title];
        
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
        //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
        NSRange range = [string rangeOfString:[NSString stringWithFormat:@"%@：",header[i]]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = PWTextLight;
        //赋值
        [attribut addAttributes:dic range:range];
        title.attributedText = attribut;
        title.preferredMaxLayoutWidth = kWidth-Interval(60);
//        title.text = string;
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == nil) {
                make.top.mas_equalTo(view).offset(Interval(16));
            }else{
                make.top.mas_equalTo(temp.mas_bottom).offset(Interval(9));
            }
            make.left.mas_equalTo(view).offset(Interval(14));
            make.right.mas_equalTo(view).offset(-Interval(14));
            if(i == header.count-1){
                make.bottom.mas_equalTo(view).offset(-Interval(16));
            }
        }];
        temp = title;
    }
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
