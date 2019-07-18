//
//  NotiRuleCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NotiRuleCell.h"
#import "TouchLargeButton.h"
#import "NotiRuleModel.h"
#import "IssueSourceManger.h"
@interface NotiRuleCell()
@property (nonatomic, strong) UILabel *ruleNameLab;
@property (nonatomic, strong) UILabel *subscribeLab;
@property (nonatomic, strong) TouchLargeButton *subscribeBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *subContentView;
@property (nonatomic, strong) UILabel *notiWayLab;
@property (nonatomic, strong) UILabel *dingNoti;
@property (nonatomic, strong) UILabel *customNoti;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *weekLab;
@end
@implementation NotiRuleCell
-(void)setFrame:(CGRect)frame{
    frame.size.height -= Interval(12);
    [super setFrame:frame];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    self.subscribeBtn = [[TouchLargeButton alloc]init];
    [self.subscribeBtn setTitle:@"订阅规则" forState:UIControlStateNormal];
    [self.subscribeBtn setTitle:@"取消订阅" forState:UIControlStateSelected];
    [self.subscribeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
    [self.subscribeBtn addTarget:self action:@selector(subscribeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.subscribeBtn.titleLabel.font = RegularFONT(13);
    [self.contentView addSubview:self.subscribeBtn];
    [self.subscribeBtn sizeToFit];
    CGFloat btnWidth = self.subscribeBtn.frame.size.width;
    self.subscribeBtn.frame = CGRectMake(kWidth-16-btnWidth, 17, btnWidth, ZOOM_SCALE(20));
    self.subscribeLab.frame = CGRectMake(CGRectGetMinX(self.subscribeBtn.frame)-12-ZOOM_SCALE(40), 17, ZOOM_SCALE(40), ZOOM_SCALE(20));
    self.ruleNameLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(14), ZOOM_SCALE(222), ZOOM_SCALE(20)) font:RegularFONT(18) textColor:PWTextBlackColor text:@""];
    self.ruleNameLab.numberOfLines = 0;
    [self.contentView addSubview:self.ruleNameLab];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ruleNameLab.mas_bottom).offset(14);
        make.left.right.width.mas_equalTo(self.contentView);
        make.height.offset(SINGLE_LINE_WIDTH);
    }];
    
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_condition"]];
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ruleNameLab);
        make.top.mas_equalTo(line.mas_bottom).offset(14);
        make.width.height.offset(ZOOM_SCALE(20));
    }];
    UILabel *conditionLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"条件"];
    conditionLab.tag = 22;
    [self.contentView addSubview:conditionLab];
    [conditionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(8);
        make.centerY.height.mas_equalTo(icon);
        make.width.offset(40);
    }];
   
}

-(UILabel *)subscribeLab{
    if (!_subscribeLab) {
        _subscribeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#39D1AA"] text:@"已订阅"];
        _subscribeLab.textAlignment = NSTextAlignmentCenter;
        _subscribeLab.layer.cornerRadius = 3.;//边框圆角大小
        _subscribeLab.layer.masksToBounds = YES;
        _subscribeLab.layer.borderWidth = 1;//边框宽度
        _subscribeLab.layer.borderColor = [UIColor colorWithHexString:@"#39D1AA"].CGColor;
        [self.contentView addSubview:_subscribeLab];
    }
    return _subscribeLab;
}
-(UIView *)subContentView{
    if (!_subContentView) {
        _subContentView = [[UIView alloc]init];
        _subContentView.backgroundColor = PWWhiteColor;
        [self.contentView addSubview:_subContentView];
        NSArray *iconAry = @[@"icon_noti",@"icon_ding",@"icon_customcallbacks",@"icon_time",@"icon_weekc"];
        NSArray *titleAry = @[@"通知方式",@"钉钉通知",@"自定义回调",@"时间",@"周期"];
        NSArray *labAry = @[self.notiWayLab,self.dingNoti,self.customNoti,self.timeLab,self.weekLab];
        UIView *temp = nil;
        for (NSInteger i=0; i<iconAry.count; i++) {
            UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconAry[i]]];
            [_subContentView addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.ruleNameLab);
                if (temp == nil) {
                    make.top.mas_equalTo(_subContentView).offset(14);
                }else{
                    make.top.mas_equalTo(temp.mas_bottom).offset(ZOOM_SCALE(15));
                }
                make.width.height.offset(ZOOM_SCALE(20));
            }];
            UILabel *conditionLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:titleAry[i]];
            [self.contentView addSubview:conditionLab];
            [conditionLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(icon.mas_right).offset(8);
                make.centerY.height.mas_equalTo(icon);
                make.width.offset(ZOOM_SCALE(80));
            }];
            id lab = labAry[i];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(ZOOM_SCALE(150));
                make.top.mas_equalTo(icon);
                make.right.mas_equalTo(_subContentView).offset(-10);
            }];
            temp = icon;
        }
    }
    return _subContentView;
}
-(void)setModel:(NotiRuleModel *)model{
    _model = model;
    self.ruleNameLab.text = model.name;
    self.subscribeBtn.selected = model.subscribed;
    self.subscribeLab.hidden = !model.subscribed;
    self.ruleNameLab.height = model.titleHeight;
   
    
    UILabel *con = [self.contentView viewWithTag:22];
    UIView *upContentView = [self createUpView];
    [upContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(con.mas_bottom).offset(6);
        make.left.mas_equalTo(self.contentView).offset(16);
        make.right.mas_equalTo(self.contentView).offset(-16);
         if ([model.rule.tags allKeys].count == 0) {
        make.height.offset(ZOOM_SCALE(108));
         }else{
           make.height.offset(ZOOM_SCALE(139));
         }
    }];
    [self.subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upContentView.mas_bottom).offset(16);
        make.left.right.width.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
  
    self.dingNoti.text = model.dingtalkAddress.count>0?@"已开启":@"未开启";
    self.customNoti.text = model.customAddress.count>0?@"已开启":@"未开启";
    self.timeLab.text = [NSString stringWithFormat:@"%@:%@",model.startTime,model.endTime];
    NSMutableString *notiMethod = [NSMutableString new];
    if (self.model.appNotification) {
        [notiMethod appendString:@"App"];
    }
    if (self.model.emailNotification) {
        if (notiMethod.length>0) {
            [notiMethod appendString:@"、邮件"];
        }else{
            [notiMethod appendString:@"邮件"];
        }
    }
    self.notiWayLab.text = notiMethod;
    NSArray *week = [model.weekday componentsSeparatedByString:@","];
   
    NSMutableString *weekStr = [NSMutableString new];
    NSString *weeks;
    for (NSInteger i=0; i<week.count; i++) {
        NSInteger day = [week[i] integerValue];
        switch (day) {
            case 0:
                weeks =NSLocalizedString(@"local.Monday", @"");
                break;
           case 1:
                weeks =NSLocalizedString(@"local.Tuesday", @"");
                break;
            case 2:
                weeks =NSLocalizedString(@"local.Wednesday", @"");

                break;
            case 3:
                weeks =NSLocalizedString(@"local.Thursday", @"");

                break;
            case 4:
                weeks =NSLocalizedString(@"local.Friday", @"");

                break;
            case 5:
                weeks =NSLocalizedString(@"local.Saturday", @"");

                break;
            case 6:
                weeks =NSLocalizedString(@"local.Sunday", @"");
                break;
        }
        [weekStr appendFormat:@"、%@",weeks];
    }
    self.weekLab.text  =  [weekStr substringFromIndex:1];
    [self createRuleUI];
    
    [self layoutSubviews];
}
- (UIView *)createUpView{
    UIView *upContentView = [[UIView alloc]init];
    upContentView.backgroundColor = [UIColor colorWithHexString:@"#F9FBFF"];
    upContentView.tag = 99;
    [[self.contentView viewWithTag:99] removeFromSuperview];
    [self.contentView addSubview:upContentView];
    NSArray *titleAry;
    if ([self.model.rule.tags allKeys].count == 0) {
        titleAry = @[@"云账号",@"类型",@"等级"];
    }else{
        titleAry = @[@"标签",@"云账号",@"类型",@"等级"];
    }
    NSMutableArray *labAry = [NSMutableArray new];
    UIView *temp = nil;
    [upContentView removeAllSubviews];
    for (NSInteger i=0; i<titleAry.count; i++) {
        UILabel *lab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:titleAry[i]];
        lab.tag = i+50;
        [upContentView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp==nil) {
                make.top.mas_equalTo(upContentView).offset(16);
            }else{
                make.top.mas_equalTo(temp.mas_bottom).offset(14);
            }
            make.left.mas_equalTo(upContentView).offset(26);
            make.height.offset(ZOOM_SCALE(17));
            make.width.offset(ZOOM_SCALE(45));
        }];
        temp = lab;
        [labAry addObject:lab];
    }
    NSInteger index = 0;
    UILabel *referenceLab = labAry[index];
    if (labAry.count==4) {
        NSString *key =  [self.model.rule.tags allKeys][0];
        NSString *value = [self.model.rule.tags stringValueForKey:key default:@""];
        
        UILabel *tagLab =  [self tagLabWithText:[value isEqualToString:@""]?key:[NSString stringWithFormat:@"%@:%@",key,value]];
        [upContentView addSubview:tagLab];
        CGFloat width = tagLab.frame.size.width;
        [tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(upContentView).offset(ZOOM_SCALE(150)-16);
            make.height.offset(ZOOM_SCALE(24));
            make.width.offset(width+6);
            make.centerY.mas_equalTo(referenceLab);
        }];
        index = 1;
        referenceLab = labAry[index];
    }
    if(self.model.rule.issueSource.count == 0){
        
        UILabel *sourceLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#595860"] text:@"全部云账号"];
        [upContentView addSubview:sourceLab];
        [sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(upContentView).offset(ZOOM_SCALE(150)-16);
            make.height.offset(ZOOM_SCALE(24));
            make.width.offset(ZOOM_SCALE(60));
            make.centerY.mas_equalTo(referenceLab);
        }];
    }else{
        NSDictionary *source = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameAndProviderWithID:[self.model.rule.issueSource firstObject]];
        NSString *icon,*sourceName;
        if (source) {
            NSString *type = [source stringValueForKey:@"provider" default:@""];
            sourceName = [source stringValueForKey:@"name" default:@""];
            if ([type isEqualToString:@"carrier.corsairmaster"]){
                icon = @"icon_foresight_small";
            }else if([type isEqualToString:@"aliyun"]) {
                 icon = @"icon_alis";
            }else if([type isEqualToString:@"qcloud"]){
                icon = @"icon_tencent_small";
            }else if([type isEqualToString:@"aws"]){
                icon = @"icon_aws_small";
            }else if([type isEqualToString:@"ucloud"]){
                icon = @"icon_tencent_small";
            }else if ([type isEqualToString:@"domain"]){
                icon = @"icon_domainname_small";
            }else if([type isEqualToString:@"carrier.corsair"]){
                icon =@"icon_mainframe_small";
            }else if([type isEqualToString:@"carrier.alert"]){
                icon = @"message_docks";
            }else if ([type isEqualToString:@"aliyun.finance"]){
                icon = @"icon_alis";
            }else if ([type isEqualToString:@"aliyun.cainiao"]){
                icon = @"cainiao_s";
            }
        }
        UIImageView *sourceIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
        [upContentView addSubview:sourceIcon];
        [sourceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(upContentView).offset(ZOOM_SCALE(150)-16);
            make.width.offset(ZOOM_SCALE(27));
            make.height.offset(ZOOM_SCALE(19));
            make.centerY.mas_equalTo(referenceLab);
        }];
        UILabel *nameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#595860"] text:sourceName];
        [upContentView addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sourceIcon.mas_right).offset(4);
            make.centerY.mas_equalTo(sourceIcon);
            make.height.offset(ZOOM_SCALE(16));
            make.right.mas_equalTo(upContentView).offset(-16);
        }];
    }
    index ++;
    referenceLab = labAry[index];
    NSString *typeStr = @"";
    if (self.model.rule.type.count == 0 || self.model.rule.type.count == 5) {
        typeStr = @"全部类型";
    }else{
        for (NSInteger i=0; i<self.model.rule.type.count; i++) {
            if ([self.model.rule.type[i] isEqualToString:@"alarm"]) {
            typeStr= [typeStr stringByAppendingString:@"、监控"];
            }else if ([self.model.rule.type[i]  isEqualToString:@"security"]){
               typeStr= [typeStr stringByAppendingString:@"、安全"];
            }else if ([self.model.rule.type[i]  isEqualToString:@"expense"]){
                typeStr= [typeStr stringByAppendingString:@"、费用"];

            }else if ([self.model.rule.type[i]  isEqualToString:@"optimization"]){
                typeStr= [typeStr stringByAppendingString:@"、优化"];
            }else{
                typeStr= [typeStr stringByAppendingString:@"、提醒"];
            }
        }
        typeStr = [typeStr substringFromIndex:1];
    }
    UILabel *typeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#595860"] text:typeStr];
    [upContentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(upContentView).offset(ZOOM_SCALE(150)-16);
        make.height.offset(ZOOM_SCALE(24));
        make.right.mas_equalTo(upContentView).offset(-16);
        make.centerY.mas_equalTo(referenceLab);
    }];
    index ++;
    referenceLab = labAry[index];
    if (self.model.rule.level.count == 0 || self.model.rule.level.count == 3) {
        UILabel *sourceLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#595860"] text:@"全部等级"];
        [upContentView addSubview:sourceLab];
        [sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(upContentView).offset(ZOOM_SCALE(150)-16);
            make.height.offset(ZOOM_SCALE(24));
            make.width.offset(ZOOM_SCALE(60));
            make.centerY.mas_equalTo(referenceLab);
        }];
    }else{
        UIView *levelTemp = nil;
        for (NSInteger i=0; i<self.model.rule.level.count; i++) {
            NSString *levelStr;
            UIColor *levelColor;
            if ([self.model.rule.level[i] isEqualToString:@"danger"]) {
                levelColor= [UIColor colorWithHexString:@"FC7676"];
                levelStr = @"严重";
            }else if([self.model.rule.level[i] isEqualToString:@"warning"]){
                levelColor= [UIColor colorWithHexString:@"FFC163"];
                levelStr = @"警告";
            }else{
                levelColor= [UIColor colorWithHexString:@"599AFF"];
                levelStr = @"提示";
            }
            UILabel *levelLab= [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:PWWhiteColor text:levelStr];
                                levelLab.backgroundColor = levelColor;
            levelLab.layer.cornerRadius = 4.0;
            levelLab.textAlignment = NSTextAlignmentCenter;
            levelLab.layer.masksToBounds = YES;
            [upContentView addSubview:levelLab];
            [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                make.left.mas_equalTo(upContentView).offset(ZOOM_SCALE(150)-16);
                }else{
                    make.left.mas_equalTo(levelTemp.mas_right).offset(10);
                }
                make.height.offset(ZOOM_SCALE(20));
                make.width.offset(ZOOM_SCALE(45));
                make.centerY.mas_equalTo(referenceLab);
            }];
            levelTemp = levelLab;
        }
    }
    return upContentView;
}
- (void)createRuleUI{
    
    
}
-(UILabel *)tagLabWithText:(NSString *)text{
    UILabel *tagLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#595860"] text:text];
    tagLab.textAlignment = NSTextAlignmentCenter;
    tagLab.backgroundColor = [UIColor colorWithHexString:@"#EBF0FF"];
    tagLab.layer.masksToBounds = YES;
    tagLab.layer.cornerRadius = 2.;
    [tagLab sizeToFit];
    return tagLab;
}
-(UILabel *)notiWayLab{
    if (!_notiWayLab) {
        _notiWayLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextBlackColor text:@""];
        [self.subContentView addSubview:_notiWayLab];
    }
    return _notiWayLab;
}
-(UILabel *)dingNoti{
    if (!_dingNoti) {
        _dingNoti = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextBlackColor text:@""];
        [self.subContentView addSubview:_dingNoti];
    }
    return _dingNoti;
}
-(UILabel *)customNoti{
    if (!_customNoti) {
        _customNoti = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextBlackColor text:@""];
        [self.subContentView addSubview:_customNoti];
    }
    return _customNoti;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextBlackColor text:@""];
        [self.subContentView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)weekLab{
    if (!_weekLab) {
        _weekLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextBlackColor text:@""];
        _weekLab.numberOfLines = 0;
        [self.subContentView addSubview:_weekLab];
    }
    return _weekLab;
}
- (void)subscribeBtnClick{
    if (self.subscribeBtn.selected) {
        [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] unsubscribeNotificationRuleWithID:self.model.ruleId callBack:^(id response) {
             [SVProgressHUD dismiss];
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                self.subscribeBtn.selected = !self.subscribeBtn.selected;
                self.subscribeLab.hidden = YES;
                [SVProgressHUD showSuccessWithStatus:@"通知规则订阅取消成功"];
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];

    }else{
        [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] subscribeNotificationRuleWithID:self.model.ruleId callBack:^(id response) {
            [SVProgressHUD dismiss];
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                self.subscribeLab.hidden = NO;
                self.subscribeBtn.selected = !self.subscribeBtn.selected;
                [SVProgressHUD showSuccessWithStatus:@"通知规则订阅成功"];
            }else{
                if ([model.errorCode isEqualToString:@"home.team.notificationRuleAlreadySubscribe"]) {
                   [SVProgressHUD showSuccessWithStatus:@"通知规则订阅成功"];
                    self.subscribeLab.hidden = NO;
                    self.subscribeBtn.selected = !self.subscribeBtn.selected;
                }else{
                [iToast alertWithTitleCenter:model.errorMsg];
                }
            }
        }];
    }
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
