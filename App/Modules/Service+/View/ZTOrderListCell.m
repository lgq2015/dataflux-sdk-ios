//
//  ZTOrderListCell.m
//  App
//
//  Created by tao on 2019/4/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTOrderListCell.h"
#define zt_moneyLabBottom 28
#define zt_titleLabLeftMargin 15
#define zt_titleLabRightMargin 8
#define zt_cellMargin 12
@interface ZTOrderListCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightNowPayBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payBtnWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payBtnHeightCons;

@end
@implementation ZTOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.preferredMaxLayoutWidth = kWidth- zt_titleLabLeftMargin - zt_titleLabRightMargin;
    self.cancelOrderBtn.layer.borderWidth = 1;
    self.cancelOrderBtn.layer.borderColor = [UIColor colorWithHexString:@"#8E8E93"].CGColor;
    self.cancelOrderBtn.layer.cornerRadius = 4;
    self.rightNowPayBtn.layer.cornerRadius = 4;
    //适配
    self.titleLab.font = RegularFONT(18);
    self.orderNumLab.font = RegularFONT(14);
    self.payStatusLab.font = RegularFONT(16);
    self.timeLab.font = RegularFONT(12);
    self.moneyLab.font = RegularFONT(20);
    self.rightNowPayBtn.titleLabel.font = RegularFONT(14);
    self.cancelOrderBtn.titleLabel.font = RegularFONT(14);
    self.payBtnWidthCons.constant = ZOOM_SCALE(80);
    self.payBtnHeightCons.constant = ZOOM_SCALE(28);
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
    CGFloat heigth = CGRectGetMaxY(_moneyLab.frame) + zt_moneyLabBottom + zt_cellMargin;
    return heigth ;
}
- (IBAction)cancelClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickCancelOrder:)]){
        [_delegate didClickCancelOrder:self];
    }
}
- (IBAction)payClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickPayOrder:)]){
        [_delegate didClickPayOrder:self];
    }
}

@end
