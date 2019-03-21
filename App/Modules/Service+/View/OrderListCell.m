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
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号：%@",_model.orderId];
    self.orderTitleLab.text = _model.commodityPackageName;
    NSString *timeStr = [NSString yearMonthDayDateUTC:_model.updateTime formatter:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    self.orderTimeLab.text = timeStr;
}
-(void)layoutSubviews{
    [self.orderTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.top.mas_equalTo(self.contentView).offset(Interval(17));
        make.height.offset(ZOOM_SCALE(17));
    }];
    [self.orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.centerY.mas_equalTo(self.orderTimeLab);
        make.height.offset(ZOOM_SCALE(20));
        make.right.mas_equalTo(self.orderTimeLab).offset(-Interval(10));
    }];
    [self.orderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderNumLab);
        make.top.mas_equalTo(self.orderNumLab.mas_bottom);
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
    }];
}
-(UILabel *)orderNumLab{
    if (!_orderNumLab) {
        _orderNumLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTitleColor text:@""];
        [self.contentView addSubview:_orderNumLab];
    }
    return _orderNumLab;
}
-(UILabel *)orderTimeLab{
    if (!_orderTimeLab) {
        _orderTimeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:[UIColor colorWithHexString:@"#C7C7CC"] text:@""];
        [self.contentView addSubview:_orderTimeLab];
    }
    return _orderTimeLab;
}
-(UILabel *)orderTitleLab{
    if (!_orderTitleLab) {
        _orderTitleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:@""];
        [self.contentView addSubview:_orderTitleLab];
    }
    return _orderTitleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
