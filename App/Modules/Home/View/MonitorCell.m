//
//  MonitorCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MonitorCell.h"
@interface MonitorCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *warningLab;
@property (nonatomic, strong) UILabel *subLab;
@property (nonatomic, strong) UILabel *stateLab;

@end
@implementation MonitorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(NSDictionary *)model{
    int state =1;
    switch (state) {
        case 1:
            self.stateLab.layer.borderColor = [UIColor colorWithHexString:@"F15533"].CGColor;
            self.stateLab.textColor = PWDestructiveBtnColor;
            break;
        case 2:
            self.stateLab.layer.borderColor = [UIColor colorWithHexString:@"35B34A"].CGColor;
            self.stateLab.textColor = [UIColor colorWithHexString:@"35B34A"];
            break;
        case 3:
            self.stateLab.layer.borderColor = [UIColor colorWithHexString:@"F5C501"].CGColor;
            self.stateLab.textColor = [UIColor colorWithHexString:@"F5C501"];
            break;
        case 4:
            self.stateLab.layer.borderColor = [UIColor colorWithHexString:@"9B9EA0"].CGColor;
            self.stateLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
            break;
    }
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(13);
        make.right.mas_equalTo(self).offset(17);
        make.width.offset(ZOOM_SCALE(48));
        make.height.offset(ZOOM_SCALE(22));

    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(13);
        make.left.mas_equalTo(self).offset(12);
        make.right.equalTo(self.stateLab.mas_left).offset(-Interval(31));
        make.height.offset(ZOOM_SCALE(44));
    }];
    [self.warningLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(Interval(9));
        make.left.mas_equalTo(self).offset(12);
        make.right.mas_equalTo(self).offset(-17);
        make.height.offset(ZOOM_SCALE(25));
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.warningLab.mas_bottom).offset(Interval(8));
        make.left.mas_equalTo(self).offset(12);
        make.right.mas_equalTo(self).offset(-17);
        make.height.offset(ZOOM_SCALE(17));
    }];
    
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
        _warningLab.font =  [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
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
        _stateLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _stateLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _stateLab.layer.cornerRadius = 4.;//边框圆角大小
        _stateLab.layer.masksToBounds = YES;
        _stateLab.layer.borderWidth = 1;//边框宽度
        [self addSubview:_stateLab];
    }
    return _stateLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
