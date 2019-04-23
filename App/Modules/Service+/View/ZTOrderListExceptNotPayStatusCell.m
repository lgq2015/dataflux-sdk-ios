//
//  ZTOrderListExceptNotPayStatusCell.m
//  App
//
//  Created by tao on 2019/4/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTOrderListExceptNotPayStatusCell.h"
#define zt_timeLabBottom 24
#define zt_titleLabLeftMargin 15
#define zt_titleLabRightMargin 8
#define zt_cellMargin 12
@interface ZTOrderListExceptNotPayStatusCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLab;
@end
@implementation ZTOrderListExceptNotPayStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.preferredMaxLayoutWidth = kWidth- zt_titleLabLeftMargin - zt_titleLabRightMargin;
    //适配
    self.titleLab.font = RegularFONT(18);
    self.orderNumLab.font = RegularFONT(14);
    self.payStatusLab.font = RegularFONT(16);
    self.timeLab.font = RegularFONT(12);
}

-(void)setFrame:(CGRect)frame{
    frame.origin.y += zt_cellMargin;
    frame.size.height -= zt_cellMargin;
    [super setFrame:frame];
}

//计算cell内容的总高度
- (CGFloat)caculateRowHeight:(FounctionIntroductionModel *)model{
    //    self.model = model;
    [self layoutIfNeeded];
    CGFloat heigth = CGRectGetMaxY(_timeLab.frame) + zt_timeLabBottom + zt_cellMargin;
    return heigth ;
}

@end
