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
@property (nonatomic, strong) UIView  *vipProductView;
@end
@implementation TeamHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = PWWhiteColor;
        [self createUI];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = PWWhiteColor;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor = [UIColor colorWithHexString:@"#F2F4F7"];
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = PWWhiteColor;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(Interval(12));
    }];
    CGFloat btnWidth = ZOOM_SCALE(34);
    CGFloat interval = (kWidth-ZOOM_SCALE(34)*4-Interval(30)*2)/3.0;
    UIView *temp;
    NSArray *iconAry = @[@"team_invite",@"team_infos",@"team_management",@"team_record"];
    NSArray *btnName = @[@"邀请成员",@"云服务",@"团队管理",@"服务"];
    for (NSInteger i=0; i<iconAry.count; i++) {
        UIImageView *item = [self itemBtnWithIconName:iconAry[i]];
        [self addSubview:item];
        if (temp == nil) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(Interval(30));
                make.top.mas_equalTo(contentView).offset(Interval(25));
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
        UILabel *name = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWTitleColor text:btnName[i]];
        name.textAlignment = NSTextAlignmentCenter;
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(item.mas_bottom).offset(Interval(8));
            make.centerX.mas_equalTo(item);
            make.width.offset(ZOOM_SCALE(55));
            make.height.offset(ZOOM_SCALE(18));
        }];
    }
   
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(temp).offset(ZOOM_SCALE(18)+Interval(34));
    }];
   
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F7"];

    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(15), (48-ZOOM_SCALE(22))/2.0, ZOOM_SCALE(66), ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWTextBlackColor text:@"我的团队"];
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
        make.top.mas_equalTo(contentView.mas_bottom);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(view);
    }];
}
-(void)setTeamName:(NSString *)teamName{
    self.teamNameLab.text = teamName;
}
-(void)setTeamNum:(NSString *)teamNum{
    self.memberNumLab.text = teamNum;
}
-(void)setTeamProduct:(NSArray *)product{
   
    [self setNeedsUpdateConstraints];
    
    CGFloat height = ZOOM_SCALE(24)*product.count+Interval(18);

    [self.vipProductView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
    }];
    [self.vipProductView removeAllSubviews];
    [self.vipProductView layoutIfNeeded];
    [self layoutIfNeeded];
    UIView *vipTemp;
    for (NSDictionary *dict in product)  {
        NSDictionary *displayString = dict[@"displayString"];
        UIView *dot = [[UIView alloc]init];
        dot.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
        dot.layer.cornerRadius = 4.0f;
        [self.vipProductView addSubview:dot];
        UILabel *equityLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTitleColor text:[displayString stringValueForKey:@"name" default:@""]];
        UILabel *equityLab2 =[PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWBlueColor text:[displayString stringValueForKey:@"value" default:@""]];
        [self.vipProductView addSubview:equityLab];
        [self.vipProductView addSubview:equityLab2];

        if (vipTemp == nil) {
            [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(Interval(16));
                make.top.mas_equalTo(self.vipProductView).offset(Interval(17));
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
        [equityLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(equityLab.mas_right);
            make.centerY.mas_equalTo(equityLab);
            make.height.offset(ZOOM_SCALE(20));
        }];
        if ([displayString stringValueForKey:@"value" default:@""].length>0) {
            equityLab.text = [NSString stringWithFormat:@"%@：",[displayString stringValueForKey:@"name" default:@""]];
        }
        
    }
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
        _teamNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(20) textColor:PWWhiteColor text:@""];
    }
    return _teamNameLab;
}
-(UILabel *)memberNumLab{
    if (!_memberNumLab) {
     _memberNumLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWTextBlackColor text:@""];
    }
    return _memberNumLab;
}
- (UIView *)vipProductView{
    if (!_vipProductView) {
        _vipProductView = [[UIView alloc]init];
        [self addSubview:_vipProductView];
    }
    return _vipProductView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
