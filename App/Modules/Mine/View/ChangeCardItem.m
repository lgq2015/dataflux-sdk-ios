//
//  ChangeCardItem.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChangeCardItem.h"

@implementation ChangeCardItem
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.06;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
