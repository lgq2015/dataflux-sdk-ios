//
//  OrderStatusWithMoneyCell.m
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "OrderStatusWithMoneyCell.h"
#import "ZTDeleteLabel.h"
#define zt_nowMoneyLabBottom 18
#define zt_titleLabLeftMargin 16

@interface OrderStatusWithMoneyCell()
@property (weak, nonatomic) IBOutlet ZTDeleteLabel *originLab;
@property (weak, nonatomic) IBOutlet UILabel *nowMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation OrderStatusWithMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.preferredMaxLayoutWidth = kWidth - zt_titleLabLeftMargin;
    self.titleLab.font = RegularFONT(18);
    self.originLab.font = RegularFONT(20);
    self.nowMoneyLab.font = RegularFONT(18);
}

- (CGFloat)caculateRowHeight:(FounctionIntroductionModel *)model{
    //    self.model = model;
    [self layoutIfNeeded];
    CGFloat heigth = CGRectGetMaxY(_originLab.frame) + zt_nowMoneyLabBottom;
    return heigth ;
}

@end
