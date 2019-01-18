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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MonitorListModel *)model{
    int state =1;
    switch (state) {
        case 1:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            break;
        case 2:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            break;
        case 3:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            break;
        case 4:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            break;
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(self.stateLab.mas_right).offset(Interval(28));
        make.centerY.equalTo(self.stateLab.mas_centerY);
        make.right.mas_equalTo(self).offset(-15);
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.warningLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(Interval(4));
        make.right.mas_equalTo(self).offset(-20);
        make.height.offset(ZOOM_SCALE(28));
        make.width.offset(ZOOM_SCALE(110));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(Interval(8));
        make.left.equalTo(self.stateLab.mas_left);
        if(self.model){
            make.right.mas_offset(self.warningLab.mas_left).offset(-Interval(31));
        }else{
            make.right.mas_equalTo(self).offset(-Interval(21));
        }
        if (!self.model) {
            make.bottom.mas_equalTo(self).offset(-Interval(11));
        }
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.warningLab.mas_bottom).offset(Interval(8));
        make.left.mas_equalTo(self).offset(12);
        make.right.mas_equalTo(self).offset(-17);
        make.bottom.mas_equalTo(self).offset(-Interval(11));
    }];
   
    
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _timeLab.textColor = [UIColor colorWithHexString:@"C7C7CC"];
        [self addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _titleLab.textColor = [UIColor colorWithRed:36/255.0 green:41/255.0 blue:44/255.0 alpha:1/1.0];
        _titleLab.numberOfLines = 2;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (UILabel *)warningLab{
    if (!_warningLab) {
        _warningLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _warningLab.font =  [UIFont fontWithName:@"PingFang-SC-Bold" size:20];
        _warningLab.textColor = WarningTextColor;
        [self addSubview:_warningLab];
    }
    return _warningLab;
}
-(UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _subLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _subLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
        [self addSubview:_subLab];
    }
    return _subLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(22), Interval(15), ZOOM_SCALE(50), ZOOM_SCALE(24))];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [self addSubview:_stateLab];
    }
    return _stateLab;
}
- (CGFloat)heightForModel:(NSDictionary *)model{
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
