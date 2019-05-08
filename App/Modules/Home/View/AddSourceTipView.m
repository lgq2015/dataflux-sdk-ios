//
//  AddSourceTipView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddSourceTipView.h"
@interface AddSourceTipView ()
@property (nonatomic, assign) AddSourceTipType type;
@end
@implementation AddSourceTipView

-(instancetype)initWithFrame:(CGRect)frame type:(AddSourceTipType)type{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.type = type;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = PWWhiteColor;
    NSString *iconName = self.type == AddSourceTipTypeSuccess?@"icon_succeed":@"home_warn";
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(Interval(55));
        make.width.height.offset(ZOOM_SCALE(55));
        make.centerX.mas_equalTo(self);
    }];
    NSString *tipStr = self.type == AddSourceTipTypeSuccess?@"添加成功":@"您添加的云平台诊断云服务数量已达上限";
    UILabel *titlelab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:tipStr];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titlelab];
 
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(icon.mas_bottom).offset(Interval(32));
        make.height.offset(ZOOM_SCALE(25));
        make.left.right.mas_equalTo(self);
    }];
    
    if (self.type != AddSourceTipTypeTeam) {
        NSString *subStr = self.type == AddSourceTipTypeSuccess?@"我们将在几分钟内开始为您诊断":@"升级团队即可添加更多云服务";
        UILabel *subtitle = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWSubTitleColor text:subStr];
        subtitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:subtitle];
        [subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titlelab.mas_bottom).offset(Interval(16));
            make.right.left.mas_equalTo(self);
            make.height.offset(ZOOM_SCALE(20));
        }];
    }
    NSString *btntitle;
    if (self.type == AddSourceTipTypeTeam) {
        btntitle = @"去购买";
    }else if(self.type == AddSourceTipTypeSuccess){
        btntitle = @"我知道了";
    }else{
        btntitle =@"升级团队";
    }
    UIButton *commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:btntitle];
    [self addSubview:commitBtn];
    [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titlelab.mas_bottom).offset(Interval(130));
        make.left.mas_equalTo(self).offset(Interval(16));
        make.right.mas_equalTo(self).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
    
}
- (void)commitBtnClick{
    if (self.btnClick) {
        self.btnClick();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
