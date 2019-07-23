//
//  IssueCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueCell.h"
#import "IssueListViewModel.h"
#import "IssueSourceManger.h"
#import "IssueListManger.h"
#import "SelectObject.h"
#import "TriangleDrawRect.h"
#define TagSourcenFrom  100
@interface IssueCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) TriangleDrawRect *triangleView;
@property (nonatomic, strong) UILabel *chatTimeLab;
//情报源名称 情报源头像
@property (nonatomic, strong) UIImageView *sourceIcon;
@property (nonatomic, strong) UILabel *sourcenNameLab;
//类别名称 类别头像
@property (nonatomic, strong) UILabel *issTypeLab;
@property (nonatomic, strong) UIImageView *issIcon;
//@property (nonatomic, strong) UILabel *issueStateLab;
//标记状态 标记用户头像
@property (nonatomic, strong) UILabel *markStatusLab;
@property (nonatomic, strong) UIImageView *markUserIcon;
@property (nonatomic, strong) UILabel *chatLab;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;
@end
@implementation IssueCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += Interval(16);
    frame.size.width -= Interval(32);
    frame.size.height -= Interval(12);
    [super setFrame:frame];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self createUI];
    }
    return self;
}

- (void)createUI{

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(Interval(10));
        make.centerY.mas_equalTo(self.stateLab.mas_centerY);
        make.right.mas_equalTo(self).offset(-15);
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.sourcenNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourceIcon.mas_right).offset(Interval(10));
        make.centerY.mas_equalTo(self.sourceIcon);
        make.height.offset(ZOOM_SCALE(18));
    }];
    
    self.titleLab.frame = CGRectMake(14, CGRectGetMaxY(self.stateLab.frame)+10, kWidth-60, ZOOM_SCALE(40));

    UILabel *categoryLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(10) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:@"类型："];
    [self addSubview:categoryLab];
    [categoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.offset(ZOOM_SCALE(30));
        make.height.offset(ZOOM_SCALE(14));
    }];
    [self.issTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(categoryLab.mas_right);
        make.centerY.mas_equalTo(categoryLab);
        make.height.offset(ZOOM_SCALE(14));
    }];
    [self.markUserIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-16);
        make.width.height.offset(ZOOM_SCALE(18));
        make.centerY.mas_equalTo(self.issTypeLab);
    }];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.markUserIcon.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.markUserIcon);
        make.height.offset(10);
        make.width.offset(SINGLE_LINE_WIDTH);
    }];
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLab);
        make.height.offset(SINGLE_LINE_WIDTH);
        make.top.mas_equalTo(categoryLab.mas_bottom).offset(10);
    }];
    [self.chatTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-17);
        make.height.offset(ZOOM_SCALE(18));
        make.top.mas_equalTo(categoryLab.mas_bottom).offset(18);
    }];

    [self.chatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(categoryLab.mas_bottom).offset(18);
        make.left.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.chatTimeLab.mas_left).offset(-10);
        make.height.offset(ZOOM_SCALE(18));
    }];
   
}
- (void)setModel:(IssueListViewModel *)model{
    _model = model;
    self.chatTimeLab.text = model.chatTime;
    self.titleLab.height = model.titleHeight;
  SelectObject *selObj =  [[IssueListManger sharedIssueListManger] getCurrentSelectObject];
    if (selObj.issueSortType == IssueSortTypeCreate) {
    self.timeLab.text = [NSString stringWithFormat:@"产生时间：%@",[self.model.time listAccurateTimeStr]];
    }else{
    self.timeLab.text = [NSString stringWithFormat:@"更新时间：%@",[self.model.updataTime listAccurateTimeStr]];
    }
    if (_model.isCallME) {
        NSString *str = [NSString stringWithFormat:@"[有人@我] %@",self.model.issueLog];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange range = [str rangeOfString:@"[有人@我]"];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FE563E"] range:range];
        self.chatLab.attributedText = attrStr;
    }else{
        self.chatLab.text = self.model.issueLog;
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
    self.markUserIcon.hidden = model.assignedToAccountInfo ? NO:YES;
    self.verticalLine.hidden = model.assignedToAccountInfo ? NO:YES;
    self.horizontalLine.hidden = self.model.issueLog.length>0?NO:YES;
    if (model.assignedToAccountInfo) {
        NSString *pwAvatar;
        NSDictionary *tags = PWSafeDictionaryVal(model.assignedToAccountInfo, @"tags");
        if (tags) {
           pwAvatar = [tags stringValueForKey:@"pwAvatar" default:@""];
        }
        [self.markUserIcon sd_setImageWithURL:[NSURL URLWithString:pwAvatar] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
    }
    self.titleLab.text = self.model.title;

     [self.sourcenNameLab sizeToFit];
    CGSize size =self.sourcenNameLab.frame.size;
    self.sourcenNameLab.frame = CGRectMake(kWidth-size.width-46, 19, size.width, ZOOM_SCALE(18));
    self.sourceIcon.frame = CGRectMake(CGRectGetMinX(self.sourcenNameLab.frame)-8-ZOOM_SCALE(27), 0, ZOOM_SCALE(27), ZOOM_SCALE(19));
    self.sourceIcon.centerY = self.sourcenNameLab.centerY;
    [self.markStatusLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-5);
    }];
    [[self viewWithTag:TagSourcenFrom] removeFromSuperview];
    UILabel *sourceFromLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(10) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:[NSString stringWithFormat:@"来源：%@",_model.originName]];
    sourceFromLab.tag =TagSourcenFrom;
    sourceFromLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:sourceFromLab];
    [sourceFromLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.markUserIcon.hidden) {
            make.right.mas_equalTo(self).offset(-14);
        }else{
            make.right.mas_equalTo(self.verticalLine.mas_left).offset(-10);
        }
        make.height.offset(ZOOM_SCALE(14));
        make.centerY.mas_equalTo(self.issTypeLab);
    }];
    self.triangleView.hidden =self.model.isRead == YES?YES:NO;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (TriangleDrawRect *)triangleView{
    if (!_triangleView) {
        _triangleView =[[TriangleDrawRect alloc]initStartPoint:CGPointMake(0, 0) middlePoint:CGPointMake(8, 0) endPoint:CGPointMake(8, 8) color:PWRedColor];
        _triangleView.frame =CGRectMake(kWidth-40, 0, 8, 8);
        
        [self addSubview:_triangleView];
    }
    return _triangleView;
}
-(UIView *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc]initWithFrame:CGRectZero];
        _horizontalLine.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self addSubview:_horizontalLine];
    }
    return _horizontalLine;
}
-(UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine =[[UIView alloc]initWithFrame:CGRectZero];
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self addSubview:_verticalLine];
    }
    return _verticalLine;
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
        _issTypeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(10) textColor:PWBlackColor text:@""];
        [self addSubview:_issTypeLab];
    }
    return _issTypeLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.font = RegularFONT(10);
        _timeLab.textColor = [UIColor colorWithHexString:@"#8E8E93"];
        [self addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = RegularFONT(15);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor colorWithRed:36/255.0 green:41/255.0 blue:44/255.0 alpha:1/1.0];
        _titleLab.numberOfLines = 0;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)chatLab{
    if (!_chatLab) {
        _chatLab  = [[UILabel alloc]initWithFrame:CGRectZero];
        _chatLab.font = RegularFONT(11);
        _chatLab.textColor = PWTextBlackColor;
        [self addSubview:_chatLab];
    }
    return _chatLab;
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
        _chatTimeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(10) textColor:[UIColor colorWithHexString:@"#909095"] text:@""];
        _chatTimeLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_chatTimeLab];
    }
    return _chatTimeLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(14), Interval(19), ZOOM_SCALE(42), ZOOM_SCALE(18))];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  RegularFONT(12);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self addSubview:_stateLab];
    }
    return _stateLab;
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
