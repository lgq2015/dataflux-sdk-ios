//
//  HistoryTableView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HistoryTableView.h"
@interface HistoryTableView()
@end
@implementation HistoryTableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
}
- (void)setUpUI{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
