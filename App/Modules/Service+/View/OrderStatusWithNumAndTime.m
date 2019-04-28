//
//  OrderStatusWithNumAndTime.m
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//
#import "OrderStatusWithNumAndTime.h"
#define zt_cellMargin 12
@interface OrderStatusWithNumAndTime()
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end

@implementation OrderStatusWithNumAndTime
- (void)setFrame:(CGRect)frame{
    frame.size.height -= zt_cellMargin;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //适配
    self.numLab.font = RegularFONT(16);
    self.timeLab.font = RegularFONT(16);
}



@end
