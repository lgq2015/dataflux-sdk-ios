//
//  IssueCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueCell.h"
#import "IssueListViewModel.h"
#import "RightTriangleView.h"
@interface IssueCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *warningLab;
@property (nonatomic, strong) UILabel *subLab;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) RightTriangleView *triangleView;
@property (nonatomic, strong) UILabel *serviceLab;
@property (nonatomic, strong) UIView *serviceDot;
@end
@implementation IssueCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += Interval(16);
    frame.size.width -= Interval(32);
    frame.origin.y += Interval(12);
    frame.size.height -= Interval(12);
    [super setFrame:frame];
}
-(void)layoutSubviews{
    [self createUI];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
}
- (void)createUI{
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(Interval(28));
        make.centerY.mas_equalTo(self.stateLab.mas_centerY);
        make.right.mas_equalTo(self).offset(-15);
        make.height.offset(ZOOM_SCALE(20));
    }];
   
   
    if (self.isService) {
        [self.serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-Interval(20));
            make.height.offset(ZOOM_SCALE(20));
            make.centerY.mas_equalTo(self.timeLab);
        }];
        [self.serviceDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.serviceLab.mas_left).offset(-Interval(7));
            make.width.height.offset(8);
            make.centerY.mas_equalTo(self.serviceLab);
        }];
    }else{
    [self.warningLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(Interval(16));
        make.right.mas_equalTo(self).offset(-20);
        make.height.offset(ZOOM_SCALE(28));
        make.width.offset(ZOOM_SCALE(120));
    }];
    }
    self.titleLab.numberOfLines = 0;
  
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(Interval(9));
        make.left.equalTo(self.stateLab.mas_left);
        make.right.mas_equalTo(self).offset(-Interval(21));
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(8));
            make.left.mas_equalTo(self.stateLab.mas_left);
            make.right.mas_equalTo(self).offset(-17);
            make.height.offset(ZOOM_SCALE(18));
            make.bottom.offset(-Interval(11));
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setModel:(IssueListViewModel *)model{
    _model = model;
    switch (self.model.state) {
        case MonitorListStateWarning:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.stateLab.text = @"警告";
            break;
        case MonitorListStateSeriousness:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"严重";
            break;
        case MonitorListStateCommon:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            self.stateLab.text = @"普通";
            break;
        case MonitorListStateRecommend:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已解决";
            break;
        case MonitorListStateLoseeEfficacy:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
    if ([self.model.highlight isEqualToString:@""]) {
        self.warningLab.hidden = YES;
    }else{
        self.warningLab.hidden = NO;
    }
    self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(78);
    self.timeLab.text = [NSString compareCurrentTime:self.model.time];
    
    self.warningLab.text = self.model.highlight;
    self.titleLab.text = self.model.title;
   
   
    self.subLab.text = self.model.issueLog;
    self.triangleView.hidden =self.model.isRead == YES?YES:NO;
    if (self.isService) {
        self.triangleView.hidden = YES;
        self.serviceLab.text = [_model.ticketStatus isEqualToString:@"closed"]?@"已结束":@"服务中";
        self.serviceDot.backgroundColor = [_model.ticketStatus isEqualToString:@"closed"]?[UIColor colorWithHexString:@"#70E1BC"]:[UIColor colorWithHexString:@"#7BAEFF"];
    }
    DLog(@"%f",self.height);
}
-(UIView *)serviceDot{
    if (!_serviceDot) {
        _serviceDot = [[UIView alloc]init];
        _serviceDot.layer.cornerRadius = 4.0f;
        [self addSubview:_serviceDot];
    }
    return _serviceDot;
}
-(UILabel *)serviceLab{
    if (!_serviceLab) {
        _serviceLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTitleColor text:@""];
        _serviceLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_serviceLab];
    }
    return _serviceLab;
}
- (RightTriangleView *)triangleView{
    if (!_triangleView) {
        _triangleView = [[RightTriangleView alloc]initWithFrame:CGRectMake(kWidth-40, 0, 8, 8)];
        
        [self addSubview:_triangleView];
    }
    return _triangleView;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.font = RegularFONT(14);
        _timeLab.textColor = [UIColor colorWithHexString:@"C7C7CC"];
        [self addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = RegularFONT(16);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor colorWithRed:36/255.0 green:41/255.0 blue:44/255.0 alpha:1/1.0];
        _titleLab.numberOfLines = 0;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (UILabel *)warningLab{
    if (!_warningLab) {
        _warningLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _warningLab.font = RegularFONT(20);
        _warningLab.textAlignment = NSTextAlignmentRight;
        _warningLab.textColor = PWBlueColor;
        [self addSubview:_warningLab];
    }
    return _warningLab;
}
-(UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _subLab.font = RegularFONT(12);
        _subLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
        [self addSubview:_subLab];
    }
    return _subLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(22), Interval(17), ZOOM_SCALE(50), ZOOM_SCALE(24))];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  RegularFONT(14);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self addSubview:_stateLab];
    }
    return _stateLab;
}
- (CGFloat)heightForModel:(IssueListViewModel *)model{
    [self layoutSubviews];
    [self setModel:model];
    [self layoutIfNeeded];
    CGFloat cellHeight;
    if ([model.issueLog isEqualToString:@""]) {
        cellHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+12;
    }else{
        cellHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+12;
    }
    return cellHeight;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent: event];
    self.backgroundColor = PWWhiteColor;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = PWWhiteColor;
}
@end
