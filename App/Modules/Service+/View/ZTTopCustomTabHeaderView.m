//
//  ZTTopCustomTabHeaderView.m
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTTopCustomTabHeaderView.h"
@interface ZTTopCustomTabHeaderView()
@property (nonatomic, copy)NSString *time;
@property (nonatomic, strong)UILabel *statusLab;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UILabel *moneyLab;
@property (nonatomic, strong)UILabel *timeLab;
@property (nonatomic, strong)UIButton *payBtn;
@property (nonatomic, strong)UIImageView *bgImageView;
@end

@implementation ZTTopCustomTabHeaderView

- (void)setOrderStatusType:(OrderStatusType)orderStatusType{
    _orderStatusType = orderStatusType;
    [self createUI];
}
- (void)createUI{
    [self removeAllSubviews];
    [self addSubview:self.bgImageView];
    switch (_orderStatusType) {
        case talking_status:
            [self createTalkingUI];
            break;
        case cancel_status:
            [self createCancelUI];
            break;
        case notPay_status:
            [self notPayUI];
            break;
        case payed_status:
            [self payedUI];
            break;
        default:
            break;
    }
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark ======创建子控件=========
//洽谈中子控件
- (void)createTalkingUI{
    [self addSubview:self.statusLab];
    [self addSubview:self.cancelBtn];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.top.equalTo(self).offset(80);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.top.equalTo(self).offset(114);
        make.width.offset(ZOOM_SCALE(80));
        make.height.offset(ZOOM_SCALE(28));
    }];
}
//取消订单子控件
- (void)createCancelUI{
    [self addSubview:self.statusLab];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.top.equalTo(self).offset(80);
    }];
}
//待支付子控件
- (void)notPayUI{
    [self addSubview:self.statusLab];
    [self addSubview:self.moneyLab];
    [self addSubview:self.payBtn];
    [self addSubview:self.cancelBtn];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.top.equalTo(self).offset(80);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLab.mas_left);
        make.top.equalTo(self.statusLab.mas_bottom).offset(3);
    }];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.centerY.equalTo(self.moneyLab.mas_centerY);
        make.width.offset(ZOOM_SCALE(80));
        make.height.offset(ZOOM_SCALE(28));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLab.mas_centerY);
        make.right.equalTo(self.payBtn.mas_left).offset(-23);
        make.width.equalTo(self.payBtn.mas_width);
        make.height.equalTo(self.payBtn.mas_height);
        make.left.mas_greaterThanOrEqualTo(self.moneyLab.mas_right).offset(5);
    }];
    [self.moneyLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.cancelBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}
//已完成子控件
- (void)payedUI{
    [self addSubview:self.statusLab];
    [self addSubview:self.timeLab];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.top.equalTo(self).offset(80);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLab.mas_left);
        make.top.equalTo(self.statusLab.mas_bottom).offset(8);
    }];
    
}


#pragma mark --lazy---
- (UILabel *)statusLab{
    if (!_statusLab){
        _statusLab = [[UILabel alloc] init];
        _statusLab.font = RegularFONT(20);
        _statusLab.textColor = [UIColor whiteColor];
    }
    NSString *status = @"";
    switch (_orderStatusType) {
        case talking_status:
            status = @"洽谈中";
            break;
        case cancel_status:
            status = @"订单取消";
            break;
        case notPay_status:
            status = @"待支付";
            break;
        case payed_status:
            status = @"已完成";
            break;
            
        default:
            break;
    }
    _statusLab.text = status;
    return _statusLab;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#140F26"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = RegularFONT(14);
        _cancelBtn.layer.cornerRadius = 14;
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        
    }
    return _cancelBtn;
}
- (UILabel *)moneyLab{
    if (!_moneyLab){
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = RegularFONT(28);
        _moneyLab.textColor = [UIColor whiteColor];
        _moneyLab.text = @"¥90,000,000";
    }
    return _moneyLab;
}
- (UIButton *)payBtn{
    if (!_payBtn){
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.titleLabel.font = RegularFONT(14);
        _payBtn.backgroundColor = [UIColor colorWithHexString:@"#FAC34F"];
        _payBtn.layer.cornerRadius = 14;
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        
    }
    return _payBtn;
}
- (UILabel *)timeLab{
    if (!_timeLab){
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = RegularFONT(14);
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.text = @"2018-11-09 11:11";
    }
    return _timeLab;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView){
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"order_status_top"];
    }
    return _bgImageView;
}
@end
