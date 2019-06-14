//
//  IssueCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueCell.h"
#import "IssueListViewModel.h"
#import "RightTriangleView.h"
#import "IssueSourceManger.h"
#import "IssueListManger.h"
#import "SelectObject.h"
@interface IssueCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) RightTriangleView *triangleView;
@property (nonatomic, strong) UILabel *chatTimeLab;
//情报源名称 情报源头像
@property (nonatomic, strong) UIImageView *sourceIcon;
@property (nonatomic, strong) UILabel *sourcenNameLab;
//类别名称 类别头像
@property (nonatomic, strong) UILabel *issTypeLab;
@property (nonatomic, strong) UIImageView *issIcon;

//标记状态 标记用户头像
@property (nonatomic, strong) UILabel *markStatusLab;
@property (nonatomic, strong) UIImageView *markUserIcon;

@end
@implementation IssueCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += Interval(16);
    frame.size.width -= Interval(32);
    frame.size.height -= Interval(12);
    [super setFrame:frame];
}

-(void)layoutSubviews{
    [self createUI];
}

- (void)createUI{
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(Interval(16));
        make.centerY.mas_equalTo(self.stateLab.mas_centerY);
        make.right.mas_equalTo(self).offset(-15);
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.sourcenNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourceIcon.mas_right).offset(Interval(10));
        make.centerY.mas_equalTo(self.sourceIcon);
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self.issTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-Interval(15));
        make.centerY.mas_equalTo(self.stateLab);
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.issIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.issTypeLab.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.issTypeLab);
        make.height.width.offset(ZOOM_SCALE(18));
    }];
    [self.markUserIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-16);
        make.width.height.offset(ZOOM_SCALE(18));
        make.centerY.mas_equalTo(self.sourcenNameLab);
    }];
    
//    [self.markStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.markUserIcon.mas_right).offset(Interval(10));
//        make.centerY.mas_equalTo(self.markUserIcon);
//        make.height.offset(ZOOM_SCALE(18));
//    }];
    self.titleLab.numberOfLines = 0;
  
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sourceIcon.mas_bottom).offset(Interval(10));
        make.left.equalTo(self.stateLab.mas_left);
        make.right.mas_equalTo(self).offset(-Interval(21));
    }];

    [self.chatTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.right.mas_equalTo(self).offset(-17);
        make.height.offset(ZOOM_SCALE(18));
        make.bottom.offset(-Interval(11));
    }];
    self.chatTimeLab.text = self.model.chatTime;
    
    UILabel *sublab  = [[UILabel alloc]initWithFrame:CGRectZero];
    sublab.font = RegularFONT(12);
    sublab.textColor = PWTextBlackColor;
    sublab.tag = 22;
    [[self viewWithTag:22] removeFromSuperview];
    [self addSubview:sublab];
    
    [sublab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.chatTimeLab.mas_left).offset(-10);
        make.height.offset(ZOOM_SCALE(18));
        make.bottom.offset(-Interval(11));
    }];
    if (_model.isCallME) {
        NSString *str = [NSString stringWithFormat:@"[有人@我] %@",self.model.issueLog];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange range = [str rangeOfString:@"[有人@我]"];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FE563E"] range:range];
        sublab.attributedText = attrStr;
    }else{
    sublab.text = self.model.issueLog;
    }
}
- (void)setModel:(IssueListViewModel *)model{
    _model = model;
  SelectObject *selObj =  [[IssueListManger sharedIssueListManger] getCurrentSelectObject];
    if (selObj.issueSortType == IssueSortTypeCreate) {
    self.timeLab.text = [NSString stringWithFormat:@"产生时间：%@",[self.model.time accurateTimeStr]];
    }else{
    self.timeLab.text = [NSString stringWithFormat:@"更新时间：%@",[self.model.updataTime accurateTimeStr]];
    }

    switch (self.model.state) {
        case IssueStateWarning:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.stateLab.text = @"警告";
            break;
        case IssueStateSeriousness:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"严重";
            break;
        case IssueStateCommon:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            self.stateLab.text = @"提示";
            break;
        case IssueStateRecommend:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已恢复";
            self.timeLab.text =@"";
            //[NSString stringWithFormat:@"恢复时间：%@",[self.model.time accurateTimeStr]];

            break;
        case IssueStateLoseeEfficacy:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
 
    NSString *title,*icon;
    if ([model.type isEqualToString:@"alarm"]) {
        title = @"监控";
        icon = @"alarm_g";
    }else if ([model.type isEqualToString:@"security"]){
        title = @"安全";
        icon = @"security_g";
    }else if ([model.type isEqualToString:@"expense"]){
        title = @"费用";
        icon = @"expense_g";
    }else if ([model.type isEqualToString:@"optimization"]){
        title = @"优化";
        icon = @"optimization_g";
    }else{
        title = @"提醒";
        icon = @"misc_g";
    }
    self.issTypeLab.text = title;
    self.issIcon.image = [UIImage imageNamed:icon];
    self.sourceIcon.image = [UIImage imageNamed:self.model.icon];
    self.sourcenNameLab.text = self.model.sourceName;
//    [self.markUserIcon sd_setImageWithURL:[NSURL URLWithString:model.markUserIcon] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
//    self.markStatusLab.text = model.markStatusStr;
   
   self.markUserIcon.hidden = model.assignedToAccountInfo ? NO:YES;
    if (model.assignedToAccountInfo) {
        NSString *pwAvatar;
        NSDictionary *tags = PWSafeDictionaryVal(model.assignedToAccountInfo, @"tags");
        if (tags) {
           pwAvatar = [tags stringValueForKey:@"pwAvatar" default:@""];
        }
        [self.markUserIcon sd_setImageWithURL:[NSURL URLWithString:pwAvatar] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
    }
    self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(78);
    
    self.titleLab.text = self.model.title;
     [self.sourcenNameLab sizeToFit];
    CGSize size =self.sourcenNameLab.frame.size;
    [self.sourcenNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(size.width);
    }];
    [self.markStatusLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-5);
    }];
    self.triangleView.hidden =self.model.isRead == YES?YES:NO;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (RightTriangleView *)triangleView{
    if (!_triangleView) {
        _triangleView = [[RightTriangleView alloc]initWithFrame:CGRectMake(kWidth-40, 0, 8, 8)];
        
        [self addSubview:_triangleView];
    }
    return _triangleView;
}
-(UIImageView *)issIcon{
    if (!_issIcon) {
        _issIcon = [[UIImageView alloc]init];
        [self addSubview:_issIcon];
    }
    return _issIcon;
}
-(UILabel *)issTypeLab{
    if (!_issTypeLab) {
        _issTypeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWSubTitleColor text:@""];
        [self addSubview:_issTypeLab];
    }
    return _issTypeLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.font = RegularFONT(12);
        _timeLab.textColor = [UIColor colorWithHexString:@"C7C7CC"];
        [self addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = RegularFONT(16);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor colorWithRed:36/255.0 green:41/255.0 blue:44/255.0 alpha:1/1.0];
        _titleLab.numberOfLines = 0;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)markStatusLab{
    if (!_markStatusLab) {
        _markStatusLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWTitleColor text:@""];
        [self addSubview:_markStatusLab];
    }
    return _markStatusLab;
}
-(UIImageView *)markUserIcon{
    if (!_markUserIcon) {
        _markUserIcon = [[UIImageView alloc]init];
        _markUserIcon.layer.cornerRadius = ZOOM_SCALE(9);
        _markUserIcon.layer.masksToBounds = YES;
        [self addSubview:_markUserIcon];
    }
    return _markUserIcon;
}
-(UIImageView *)sourceIcon{
    if (!_sourceIcon) {
        _sourceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(15), Interval(24)+ZOOM_SCALE(24), ZOOM_SCALE(29), ZOOM_SCALE(20))];
        [self addSubview:_sourceIcon];
    }
    return _sourceIcon;
}
-(UILabel *)sourcenNameLab{
    if (!_sourcenNameLab) {
        _sourcenNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:@""];
        [self addSubview:_sourcenNameLab];
    }
    return _sourcenNameLab;
}
-(UILabel *)chatTimeLab{
    if (!_chatTimeLab) {
        _chatTimeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTextBlackColor text:@""];
        [self addSubview:_chatTimeLab];
    }
    return _chatTimeLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(15), Interval(14), ZOOM_SCALE(50), ZOOM_SCALE(24))];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  RegularFONT(14);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self addSubview:_stateLab];
    }
    return _stateLab;
}
- (CGFloat)heightForModel:(IssueListViewModel *)model{
   
    [self setModel:model];
    [self layoutIfNeeded];
    CGFloat cellHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+12;
    
    return cellHeight;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent: event];
    self.backgroundColor = PWWhiteColor;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = PWWhiteColor;
}
@end
