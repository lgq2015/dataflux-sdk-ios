//
//  IssueBoardInitialView.m
//  IssueBoard
//
//  Created by 胡蕾蕾 on 2018/8/17.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "IssueBoardInitialView.h"

@interface IssueBoardInitialView ()
@property (nonatomic, strong) UILabel *tipsTitle;
@property (nonatomic, strong) UILabel *tipsContent;
@property (nonatomic, strong) UIButton *serverConnectbtn;
@end

@implementation IssueBoardInitialView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.06;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
}
- (void)setUpUI{
    
       self.tipsTitle.text = @"覆盖主流四大云平台";
       self.tipsContent.text = @"多维度赋予您专业的诊断和分析";
    
    NSArray *btnImag = @[@"icon_ali_small",@"icon_aws_small",@"icon_tencent_small",@"icon_ucloud_small"];
    NSArray *iconNames = @[@"阿里云",@"AWS",@"腾讯云",@"UCloud"];
    for (int i=0; i<4; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(22+i*81), ZOOM_SCALE(64), ZOOM_SCALE(56), ZOOM_SCALE(38))];
        imgView.tag = i+10;
        UILabel *iconName = [[UILabel alloc]initWithFrame:CGRectMake(ZOOM_SCALE(22+i*81), ZOOM_SCALE(114), ZOOM_SCALE(56), ZOOM_SCALE(20))];
        iconName.textAlignment  = NSTextAlignmentCenter;
        iconName.font = [UIFont systemFontOfSize:14];
        iconName.textColor = PWTitleColor;
        iconName.text = iconNames[i];
        iconName.tag = i+60;
        imgView.image = [UIImage imageNamed:btnImag[i]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [[self viewWithTag:i+10] removeFromSuperview];
        [[self viewWithTag:i+60] removeFromSuperview];
        [self addSubview:imgView];
        [self addSubview:iconName];
    }
    NSArray *datas = @[@{@"icon":@"icon_monitor",@"title":@"监控",@"subTitle":@"为您监控资源或系统的异常状态事件"},@{@"icon":@"icon_safe",@"title":@"安全",@"subTitle":@"为您检测存在的安全隐患，提供合理建议"},@{@"icon":@"icon_expense",@"title":@"费用",@"subTitle":@"为您优化消费结构，节省开支"},@{@"icon":@"icon_optimize",@"title":@"优化",@"subTitle":@"为您提供云产品应用构架和性能的优化"},@{@"icon":@"icon_caution",@"title":@"提醒",@"subTitle":@"为您提供资源变动通知，定期推送多维度的报告"}];
    UIView *temp = nil;
    for (NSDictionary *dict in datas) {
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"icon"]]];
        [self addSubview:icon];
        icon.contentMode = UIViewContentModeScaleToFill;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == nil) {
                make.top.mas_equalTo(self.tipsContent.mas_bottom).offset(ZOOM_SCALE(16));
            }else{
                make.top.mas_equalTo(temp.mas_bottom).offset(ZOOM_SCALE(36));
            }
            make.left.mas_equalTo(self).offset(Interval(11));
            make.width.height.offset(ZOOM_SCALE(28));
        }];
        UILabel *title = [[UILabel alloc]init];
        title.text = dict[@"title"];
        title.font = RegularFONT(18);
        title.textColor = PWTextBlackColor;
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(Interval(10));
            make.centerY.mas_equalTo(icon);
            make.width.offset(100);
            make.height.offset(ZOOM_SCALE(25));
        }];
        UILabel *subTitle = [[UILabel alloc]init];
        subTitle.text = dict[@"subTitle"];
        subTitle.font =   RegularFONT(13);
        subTitle.textColor = [UIColor colorWithHexString:@"8E8E93"];
        [self addSubview:subTitle];
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(title.mas_bottom).offset(ZOOM_SCALE(5));
            make.left.mas_equalTo(title.mas_left);
            make.height.offset(ZOOM_SCALE(18));
            make.right.mas_equalTo(self).offset(-Interval(15));
        }];
        temp = icon;
    }
    [self.serverConnectbtn setBackgroundColor:PWBlueColor];
    
}
-(UILabel *)tipsContent{
    if (!_tipsContent) {
      _tipsContent = [[UILabel alloc]initWithFrame:CGRectMake(Interval(10), ZOOM_SCALE(148), ZOOM_SCALE(300), ZOOM_SCALE(27))];
      _tipsContent.numberOfLines = 1;
      _tipsContent.font =   RegularFONT(16);
      _tipsContent.textColor = PWTextBlackColor;
      [self addSubview:_tipsContent];
    }
    return _tipsContent;
}
-(UILabel *)tipsTitle{
    if (!_tipsTitle) {
        _tipsTitle = [[UILabel alloc]initWithFrame:CGRectMake(Interval(10), ZOOM_SCALE(19), ZOOM_SCALE(296), ZOOM_SCALE(27))];
        _tipsTitle.font =  RegularFONT(18);
        [self addSubview:_tipsTitle];
    }
    return _tipsTitle;
}
-(UIButton *)serverConnectbtn{
    if (!_serverConnectbtn) {
        _serverConnectbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(542), self.width, ZOOM_SCALE(44))];
        [_serverConnectbtn setTitle:@"立即配置情报源" forState:UIControlStateNormal];
        [_serverConnectbtn setTitleColor: PWWhiteColor forState:UIControlStateNormal];
       
        [[_serverConnectbtn titleLabel] setFont:[UIFont systemFontOfSize:16]];
        [_serverConnectbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_serverConnectbtn];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_serverConnectbtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _serverConnectbtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _serverConnectbtn.layer.mask = maskLayer;
    }
    return _serverConnectbtn;
}
-(void)btnClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(serverConnectClick)]) {
        [self.delegate serverConnectClick];
    }
}
#pragma mark ========== 点击效果 ==========
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowRadius = 1;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 5;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
