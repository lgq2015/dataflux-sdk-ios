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
@property (nonatomic, strong) UILabel *adminLab;
@property (nonatomic, strong) UILabel *beizhuLab;
@end
@implementation TeamMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MemberInfoModel *)model{
    _model = model;
    self.titleLab.text = _model.name;
    self.beizhuLab.text = _model.inTeamNote;
    NSString *img = [_model.tags stringValueForKey:@"pwAvatar" default:@""];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
}
-(void)layoutSubviews{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.width.height.mas_equalTo(ZOOM_SCALE(40));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(Interval(13));
        make.height.offset(ZOOM_SCALE(22));
        make.centerY.mas_equalTo(self.iconImgView);
    }];
    [self.beizhuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-Interval(22));
        make.left.mas_greaterThanOrEqualTo(self.titleLab.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-13);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.mas_equalTo(self.titleLab);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    [self.adminLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView).offset(ZOOM_SCALE(31));
        make.centerX.mas_equalTo(self.iconImgView);
        make.width.offset(ZOOM_SCALE(40));
        make.height.offset(ZOOM_SCALE(14));
    }];
    
    self.adminLab.hidden = _model.isAdmin || _model.isSpecialist?NO:YES;
    [self.titleLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.beizhuLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}
-(UILabel *)adminLab{
    if (!_adminLab) {
        NSString *str = @"";
        if (_model.isAdmin){
            str = @"管理员";
        }else{
            str = @"专家";
        }
        _adminLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(10) textColor:PWWhiteColor text:str];
        _adminLab.textAlignment = NSTextAlignmentCenter;
        _adminLab.layer.cornerRadius = 2.0f;
        _adminLab.layer.masksToBounds = YES;
        _adminLab.backgroundColor = PWBlueColor;
        [self.contentView addSubview:_adminLab];
    }
    return _adminLab;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self.contentView addSubview:_line];
    }
    return _line;
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.layer.cornerRadius = ZOOM_SCALE(20);
        _iconImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImgView];
    }
    return _iconImgView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:[UIColor colorWithHexString:@"#373D41"] text:@""];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UILabel *)beizhuLab{
    if (!_beizhuLab){
        _beizhuLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:@""];
        [self.contentView addSubview:_beizhuLab];
    }
    return _beizhuLab;
}
- (void)phoneClick{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClickedOperations) object:nil];
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:0.4];
}
- (void)btnClickedOperations{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.mobile];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
