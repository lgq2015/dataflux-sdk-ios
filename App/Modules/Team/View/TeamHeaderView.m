//
//  TeamHeaderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamHeaderView.h"


@interface TeamHeaderView()
@property (nonatomic, strong) UILabel *teamNameLab;
@property (nonatomic, strong) UILabel *memberNumLab;
@end
@implementation TeamHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = PWWhiteColor;
    }
    return self;
}
-(void)setTeamName:(NSString *)teamName{
    self.teamNameLab.text = teamName;
}
-(void)setTeamNum:(NSString *)teamNum{
    self.memberNumLab.text = teamNum;
}
-(void)layoutSubviews{
    UIImageView *headerBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"team_header"]];
    headerBg.frame = CGRectMake(0, 0, kWidth, ZOOM_SCALE(153)+kStatusBarHeight);
    [self addSubview:headerBg];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"team_admin"]];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(Interval(45)+kStatusBarHeight);
        make.left.mas_equalTo(self).offset(Interval(13));
        make.width.height.offset(ZOOM_SCALE(18));
    }];
    [self addSubview:self.teamNameLab];
    [self.teamNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(3));
        make.centerY.mas_equalTo(icon);
        make.height.offset(ZOOM_SCALE(28));
        make.right.mas_equalTo(self).offset(-Interval(12));
    }];
    
    CGFloat btnWidth = ZOOM_SCALE(34);
    CGFloat interval = (kWidth-ZOOM_SCALE(34)*4-Interval(30)*2)/3.0;
    UIView *temp;
    NSArray *iconAry = @[@"team_invite",@"team_infos",@"team_record",@"team_management"];
    NSArray *btnName = @[@"邀请成员",@"情报源",@"服务记录",@"团队管理"];
    for (NSInteger i=0; i<iconAry.count; i++) {
        UIImageView *item = [self itemBtnWithIconName:iconAry[i]];
        [self addSubview:item];
        if (temp == nil) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(Interval(30));
                make.top.mas_equalTo(headerBg.mas_bottom).offset(Interval(25));
                make.width.height.offset(btnWidth);
            }];
            temp = item;
        }else{
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(temp.mas_right).offset(interval);
                make.centerY.mas_equalTo(temp);
                make.width.height.offset(btnWidth);
            }];
            temp = item;
        }
        item.tag = 15+i;
        UILabel *name = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(13) textColor:PWTitleColor text:btnName[i]];
        name.textAlignment = NSTextAlignmentCenter;
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(item.mas_bottom).offset(Interval(8));
            make.centerX.mas_equalTo(item);
            make.width.offset(ZOOM_SCALE(55));
            make.height.offset(ZOOM_SCALE(18));
        }];
    }
    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(266)+kStatusBarHeight, kWidth, ZOOM_SCALE(48))];
    itemView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F7"];
    [self addSubview:itemView];
    
    UIImageView *vipIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"team_vip"]];
    [itemView addSubview:vipIcon];
    [vipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(14));
        make.centerY.mas_equalTo(itemView);
        make.width.height.offset(ZOOM_SCALE(24));
    }];
    UILabel *vipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTextBlackColor text:@"尊享权益"];
    [itemView addSubview:vipLab];
    [vipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(vipIcon.mas_right).offset(Interval(3));
        make.centerY.mas_equalTo(vipIcon);
        make.height.offset(ZOOM_SCALE(22));
    }];
    UIView *vipTemp;
    NSArray *vipText = @[@"基础诊断情报源上限：3",@"支持记录团队问题",@"支持团队情报讨论",@"主机诊断上限：5",@"先知监控",@"云平台诊断支持",@"企业级托管服务"];
    for (NSInteger i=0; i<vipText.count; i++) {
        UIView *dot = [[UIView alloc]init];
        dot.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
        dot.layer.cornerRadius = 4.0f;
        [self addSubview:dot];
        UILabel *equityLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTitleColor text:vipText[i]];
        [self addSubview:equityLab];
        if (vipTemp == nil) {
            [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(Interval(16));
                make.top.mas_equalTo(itemView.mas_bottom).offset(Interval(17));
                make.width.height.offset(ZOOM_SCALE(8));
            }];
        }else{
            [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(Interval(16));
                make.top.mas_equalTo(vipTemp.mas_bottom).offset(ZOOM_SCALE(16));
                make.width.height.offset(ZOOM_SCALE(8));
            }];
        }
        vipTemp = dot;
        [equityLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dot.mas_right).offset(Interval(8));
            make.centerY.mas_equalTo(dot);
            make.height.offset(ZOOM_SCALE(20));
        }];
        
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F7"];

    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(15), (48-ZOOM_SCALE(22))/2.0, ZOOM_SCALE(66), ZOOM_SCALE(22)) font:MediumFONT(16) textColor:PWTextBlackColor text:@"我的团队"];
    [view addSubview:title];
    
    [view addSubview:self.memberNumLab];
    [self.memberNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title.mas_right).offset(Interval(20));
        make.centerY.mas_equalTo(title);
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(ZOOM_SCALE(48));
    }];
    
}
-(UIImageView *)itemBtnWithIconName:(NSString *)iconName{
    UIImageView *item = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    item.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemBtnClick:)];
    item.userInteractionEnabled = YES;
    [item addGestureRecognizer:tap];
    return item;
}
- (void)itemBtnClick:(UITapGestureRecognizer *)tap{
    if (self.itemClick) {
        self.itemClick(tap.view.tag);
    }
}
- (UILabel *)teamNameLab{
    if (!_teamNameLab) {
        _teamNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(20) textColor:PWWhiteColor text:@""];
    }
    return _teamNameLab;
}
-(UILabel *)memberNumLab{
    if (!_memberNumLab) {
     _memberNumLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(13) textColor:PWTextBlackColor text:@""];
    }
    return _memberNumLab;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
