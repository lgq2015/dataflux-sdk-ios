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
//@property (nonatomic, strong) UIImageView *iconImgView;
//@property (nonatomic, strong) UILabel *titleLab;
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
    self.beizhuLab.text = _model.inTeamNote;
    NSString *img = [_model.tags stringValueForKey:@"pwAvatar" default:@""];
    UIImageView *iconImgView = [[UIImageView alloc]init];
    iconImgView.layer.cornerRadius = ZOOM_SCALE(20);
    iconImgView.layer.masksToBounds = YES;
    iconImgView.tag = 33;
    [[self.contentView viewWithTag:33] removeFromSuperview];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (model.isMultiChoice) {
            make.left.mas_equalTo(self.contentView).offset(Interval(47));
        }else{
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
        }
        make.width.height.mas_equalTo(ZOOM_SCALE(40));
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.contentView sendSubviewToBack:iconImgView];
    

    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:[UIColor colorWithHexString:@"#373D41"] text:@""];
    titleLab.tag = 34;
    [[self.contentView viewWithTag:34] removeFromSuperview];
    [self.contentView addSubview:titleLab];
    titleLab.text = _model.name;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImgView.mas_right).offset(Interval(13));
        make.height.offset(ZOOM_SCALE(22));
        make.centerY.mas_equalTo(iconImgView);
        make.width.lessThanOrEqualTo([NSNumber numberWithFloat:ZOOM_SCALE(190)]);
    }];
    [self.beizhuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-Interval(10));
        make.left.mas_greaterThanOrEqualTo(titleLab.mas_right).offset(0);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-13);
        make.centerY.mas_equalTo(iconImgView);
        make.width.lessThanOrEqualTo([NSNumber numberWithFloat:ZOOM_SCALE(110)]);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(SINGLE_LINE_WIDTH);
        make.left.mas_equalTo(self.contentView).offset(ZOOM_SCALE(40)+Interval(16));
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    [self.adminLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImgView).offset(ZOOM_SCALE(31));
        make.centerX.mas_equalTo(iconImgView);
        make.width.offset(ZOOM_SCALE(40));
        make.height.offset(ZOOM_SCALE(14));
    }];
    [iconImgView bringSubviewToFront:self.adminLab];
    self.adminLab.hidden = _model.isAdmin || _model.isSpecialist?NO:YES;
    [titleLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.beizhuLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    if (model.isSpecialist){
        [iconImgView setImage:[UIImage imageNamed:@"professor_wang_header"]];
    }else{
        [iconImgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
    }
    if (model.isMultiChoice) {
        UIImageView *selImage = [[UIImageView alloc]init];
        selImage.tag = 55;
        [[self.contentView viewWithTag:55] removeFromSuperview];
        [self.contentView addSubview:selImage];
        [selImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.width.height.offset(20);
            make.centerY.mas_equalTo(self.contentView);
        }];
        selImage.userInteractionEnabled = YES;
        if(model.isSelect){
            selImage.image = [UIImage imageNamed:@"team_success"];
        }else{
            selImage.image = [UIImage imageNamed:@"icon_noSelect"];
        }
       
    }
    if (!_model.isAdmin) {
        [_model.teamRoles enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *roleId = [obj stringValueForKey:@"id" default:@""];
            NSString *name = [obj stringValueForKey:@"name" default:@""];
            if ([roleId isEqualToString:@"tmro-buildIn-admin"]) {
                self.adminLab.text = name;
                self.adminLab.hidden = NO;
                *stop = YES;
            }
        }];
    }
}
-(void)layoutSubviews{
   
}

-(UILabel *)adminLab{
    if (!_adminLab) {
        _adminLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(10) textColor:PWWhiteColor text:@""];
        _adminLab.textAlignment = NSTextAlignmentCenter;
        _adminLab.layer.cornerRadius = 2.0f;
        _adminLab.layer.masksToBounds = YES;
        _adminLab.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_adminLab];
    }
  
    if (_model.isAdmin){
        _adminLab.backgroundColor = [UIColor colorWithHexString:@"#F97B00"];
        _adminLab.text =  NSLocalizedString(@"local.owner", @"");
    }else{
        _adminLab.backgroundColor = PWBlueColor;
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
//- (UIImageView *)iconImgView{
//    if (!_iconImgView) {
//        _iconImgView = [[UIImageView alloc]init];
//        _iconImgView.layer.cornerRadius = ZOOM_SCALE(20);
//        _iconImgView.layer.masksToBounds = YES;
//        [self.contentView addSubview:_iconImgView];
//    }
//    return _iconImgView;
//}
//-(UILabel *)titleLab{
//    if (!_titleLab) {
//        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:[UIColor colorWithHexString:@"#373D41"] text:@""];
//        [self.contentView addSubview:_titleLab];
//    }
//    return _titleLab;
//}

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
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)setTeamMemberSelect:(BOOL)isSelect{
   UIImageView *selImage= [self.contentView viewWithTag:55];
    if(isSelect){
        selImage.image = [UIImage imageNamed:@"team_success"];
    }else{
        selImage.image = [UIImage imageNamed:@"icon_noSelect"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
