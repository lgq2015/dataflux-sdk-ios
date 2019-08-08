//
//  OrderListCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "OrderListCell.h"
#import "OrderListModel.h"
@interface OrderListCell ()
@property (nonatomic, strong) UILabel *orderNumLab;
@property (nonatomic, strong) UILabel *orderTimeLab;
@property (nonatomic, strong) UILabel *orderTitleLab;
@end
@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    frame.origin.y += Interval(4);
    frame.size.height -= Interval(4);
    [super setFrame:frame];
}
-(void)setModel:(OrderListModel *)model{
    _model = model;
    self.orderNumLab.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"local.OrderNumber", @""),_model.orderId];
    self.orderTitleLab.text = _model.commodityPackageName;
    NSString *timeStr = [NSString yearMonthDayDateUTC:_model.updateTime formatter:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    self.orderTimeLab.text = timeStr;
}
-(void)layoutSubviews{
  
    [self.orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(Interval(15));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(Interval(-16));
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.orderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderNumLab);
        make.top.mas_equalTo(self.orderNumLab.mas_bottom).offset(Interval(19));
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
    }];
    [self.orderTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.orderTitleLab);
        make.height.offset(ZOOM_SCALE(17));
        make.top.mas_equalTo(self.orderTitleLab.mas_bottom).offset(Interval(5));
    }];
}
-(UILabel *)orderNumLab{
    if (!_orderNumLab) {
        _orderNumLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTitleColor text:@""];
        [self.contentView addSubview:_orderNumLab];
    }
    return _orderNumLab;
}
-(UILabel *)orderTimeLab{
    if (!_orderTimeLab) {
        _orderTimeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:[UIColor colorWithHexString:@"#C7C7CC"] text:@""];
        [self.contentView addSubview:_orderTimeLab];
    }
    return _orderTimeLab;
}
-(UILabel *)orderTitleLab{
    if (!_orderTitleLab) {
        _orderTitleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@""];
        [self.contentView addSubview:_orderTitleLab];
    }
    return _orderTitleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
