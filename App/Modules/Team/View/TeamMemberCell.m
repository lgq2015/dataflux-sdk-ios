//
//  TeamMemberCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamMemberCell.h"
#import "MemberInfoModel.h"
@interface TeamMemberCell()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *phoneBtn;
@end
@implementation TeamMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MemberInfoModel *)model{
    _model = model;
    self.titleLab.text = _model.name;
    NSString *img = [_model.tags stringValueForKey:@"pwAvatar" default:@""];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
}
-(void)layoutSubviews{
    self.backgroundColor = PWWhiteColor;
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(16));
        make.width.height.mas_equalTo(ZOOM_SCALE(40));
        make.centerY.mas_equalTo(self);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(Interval(13));
        make.height.offset(ZOOM_SCALE(22));
        make.centerY.mas_equalTo(self.iconImgView);
    }];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-Interval(16));
        make.width.height.offset(ZOOM_SCALE(36));
        make.centerY.mas_equalTo(self);
    }];
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.layer.cornerRadius = ZOOM_SCALE(20);
        _iconImgView.layer.masksToBounds = YES;
        [self addSubview:_iconImgView];
    }
    return _iconImgView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:[UIColor colorWithHexString:@"#373D41"] text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [[UIButton alloc]init];
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"team_phone"] forState:UIControlStateNormal];
        [self addSubview:_phoneBtn];
    }
    return _phoneBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
