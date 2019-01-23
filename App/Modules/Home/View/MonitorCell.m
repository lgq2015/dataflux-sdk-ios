//
//  MonitorCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MonitorCell.h"
#import "MonitorListModel.h"
@interface MonitorCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *warningLab;
@property (nonatomic, strong) UILabel *subLab;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UILabel *timeLab;

@end
@implementation MonitorCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += Interval(16);
    frame.size.width -= Interval(32);
    frame.origin.y += Interval(12);
    frame.size.height -= Interval(12);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
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
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.warningLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(Interval(6));
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.height.offset(ZOOM_SCALE(28));
        make.width.offset(ZOOM_SCALE(115));
    }];
    self.titleLab.numberOfLines = 0;
    if (self.model.attrs) {
        self.titleLab.preferredMaxLayoutWidth = kWidth-ZOOM_SCALE(115)-Interval(47);
    }else{
        self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(78);
    }
//    self.titleLab.preferredMaxLayoutWidth = kWidth-ZOOM_SCALE(155);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(Interval(3));
        make.left.equalTo(self.stateLab.mas_left);
        if(self.model.attrs){
            make.right.mas_equalTo(self.warningLab.mas_left).offset(-Interval(15));
        }else{
            make.right.mas_equalTo(self.contentView).offset(-Interval(21));
        }
   if (!self.model.suggestion) {
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(11));
    }
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(8));
        make.left.mas_equalTo(self.stateLab.mas_left);
        make.right.mas_equalTo(self.contentView).offset(-17);
        make.height.offset(ZOOM_SCALE(18));
        make.bottom.mas_equalTo(self.contentView).offset(-Interval(11));
    }];
}
- (void)setModel:(MonitorListModel *)model{
    _model = model;
//    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.stateLab.mas_right).offset(Interval(28));
//        make.centerY.mas_equalTo(self.stateLab.mas_centerY);
//        make.right.mas_equalTo(self.contentView).offset(-15);
//        make.height.offset(ZOOM_SCALE(20));
//    }];
//    [self.warningLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(Interval(4));
//        make.right.mas_equalTo(self.contentView).offset(-20);
//        make.height.offset(ZOOM_SCALE(28));
//        make.width.offset(ZOOM_SCALE(115));
//    }];
//    self.titleLab.numberOfLines = 2;
//    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.stateLab.mas_bottom).offset(Interval(8));
//        make.left.equalTo(self.stateLab.mas_left);
//        if(self.model.attrs){
//            make.right.mas_equalTo(self.warningLab.mas_left).offset(-Interval(26));
//        }else{
//            make.right.mas_equalTo(self.contentView).offset(-Interval(21));
//        }
////        if (!self.model.suggestion) {
//            make.bottom.mas_equalTo(self.contentView).offset(-Interval(11));
////        }
//    }];
//    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(8));
//        make.left.mas_equalTo(self.stateLab.mas_left);
//        make.right.mas_equalTo(self.contentView).offset(-17);
//        make.height.offset(ZOOM_SCALE(18));
//        make.bottom.mas_equalTo(self.contentView).offset(-Interval(11));
//    }];
    switch (self.model.state) {
        case 1:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"严重";
            break;
        case 2:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.stateLab.text = @"警告";
            break;
        case 3:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已解决";
            break;
        case 4:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
    if (self.model.attrs) {
        self.titleLab.preferredMaxLayoutWidth = kWidth-ZOOM_SCALE(115)-Interval(47);
    }else{
        self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(78);
    }
    self.timeLab.text = self.model.time;
    
    self.warningLab.text = self.model.attrs;
    self.titleLab.text = self.model.title;
   
   
    self.subLab.text = self.model.suggestion;
    DLog(@"%f",self.contentView.height);
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _timeLab.textColor = [UIColor colorWithHexString:@"C7C7CC"];
        [self.contentView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor colorWithRed:36/255.0 green:41/255.0 blue:44/255.0 alpha:1/1.0];
        _titleLab.numberOfLines = 0;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
- (UILabel *)warningLab{
    if (!_warningLab) {
        _warningLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _warningLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:20];;
        _warningLab.textColor = PWBlueColor;
        [self.contentView addSubview:_warningLab];
    }
    return _warningLab;
}
-(UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _subLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _subLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
        [self.contentView addSubview:_subLab];
    }
    return _subLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(22), Interval(15), ZOOM_SCALE(50), ZOOM_SCALE(24))];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self.contentView addSubview:_stateLab];
    }
    return _stateLab;
}
- (CGFloat)heightForModel:(MonitorListModel *)model{
    [self setModel:model];
    [self layoutIfNeeded];
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+30;
    return cellHeight;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
