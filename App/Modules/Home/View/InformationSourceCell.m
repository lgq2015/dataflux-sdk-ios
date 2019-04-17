//
//  InformationSourceCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InformationSourceCell.h"
@interface InformationSourceCell()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *stateLab;
@end
@implementation InformationSourceCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += Interval(16);
    frame.size.width -= Interval(32);
    frame.origin.y += Interval(12);
    frame.size.height -= Interval(12);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
    [super setFrame:frame];
}
-(void)setModel:(IssueSourceViewModel *)model{
    _model = model;
    
    switch (_model.state) {
        case SourceStateNotDetected:
            self.stateLab.layer.borderColor = [UIColor colorWithHexString:@"36C4E5"].CGColor;
            self.stateLab.textColor = [UIColor colorWithHexString:@"36C4E5"];
            self.stateLab.text = @"未开始检测";
            break;
        case SourceStateDetected:
            self.stateLab.layer.borderColor = [UIColor colorWithHexString:@"4578FC"].CGColor;
            self.stateLab.textColor = [UIColor colorWithHexString:@"4578FC"];
            self.stateLab.text = @"已纳入检测";
            break;
        case SourceStateAbnormal:
            self.stateLab.layer.borderColor = [UIColor colorWithHexString:@"FC7676"].CGColor;
            self.stateLab.textColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"情报源异常";
            break;
    }
    switch (_model.type) {
        case SourceTypeAli:
            self.iconImgView.image = [UIImage imageNamed:@"icon_ali_big"];
            break;
        case SourceTypeUcloud:
            self.iconImgView.image = [UIImage imageNamed:@"icon_ucloud_big"];
            break;
        case SourceTypeAWS:
            self.iconImgView.image = [UIImage imageNamed:@"icon_aws_big"];
            break;
        case SourceTypeTencent:
            self.iconImgView.image = [UIImage imageNamed:@"icon_tencent_big"];
            break;
        case SourceTypeClusterDiagnose:
            self.iconImgView.image = [UIImage imageNamed:@"icon_foresight_big"];
            break;
        case SourceTypeDomainNameDiagnose:
            self.iconImgView.image = [UIImage imageNamed:@"icon_domainname_big"];
            break;
        case SourceTypeSingleDiagnose:
              self.iconImgView.image = [UIImage imageNamed:@"icon_mainframe_big"];
            break;
        case SourceTypeMessageDock:
            self.iconImgView.image = [UIImage imageNamed:@"message_dock"];
            break;
    }
    self.iconImgView.centerY = self.contentView.centerY;
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(8));
        make.width.offset(ZOOM_SCALE(72));
        make.height.offset(ZOOM_SCALE(46));
        make.centerY.mas_equalTo(self);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(Interval(17));
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(Interval(17));
        make.height.offset(ZOOM_SCALE(25));
        make.right.mas_equalTo(self).offset(-10);
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(6));
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.height.offset(ZOOM_SCALE(20));
        make.width.offset(ZOOM_SCALE(80));
    }];
    self.titleLab.text = self.model.name;
}

-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]init];
        [self addSubview:_iconImgView];
    }
    return _iconImgView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = RegularFONT(18);
        _titleLab.textColor = PWTextBlackColor;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _stateLab.font =  RegularFONT(14);
        _stateLab.layer.cornerRadius = 4.;//边框圆角大小
        _stateLab.layer.masksToBounds = YES;
        _stateLab.layer.borderWidth = 1;//边框宽度
        _stateLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLab];
    }
    return _stateLab;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
