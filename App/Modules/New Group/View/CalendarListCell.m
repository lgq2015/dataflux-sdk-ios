//
//  CalendarListCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarListCell.h"
#import "CalendarIssueModel.h"
@interface CalendarListCell()
@property (nonatomic, strong) YYLabel *titleLable;
@property (nonatomic, strong) YYLabel *noDataLable;
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, strong) YYLabel *statesLabel;
@property (nonatomic, strong) YYLabel *contentTextView;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation CalendarListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.timeLabel == nil) {
            [self createCellUI];
        }
    }
    return self;
}
- (void)createCellUI{
    self.backgroundColor = PWWhiteColor;
    
    self.timeLabel = [[YYLabel alloc]init];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = RegularFONT(12);
    self.timeLabel.textColor = PWSubTitleColor;
    [self addSubview:self.timeLabel];
    self.titleLable = [[YYLabel alloc]initWithFrame: CGRectMake(Interval(45), 0, kWidth-ZOOM_SCALE(66)-Interval(69), ZOOM_SCALE(20))];
    self.titleLable.numberOfLines = 0;
    self.titleLable.font = RegularFONT(12);
    self.titleLable.textColor = [UIColor colorWithHexString:@"#8E8E93"];
    [self addSubview:self.titleLable];
    self.timeLabel.centerY = self.titleLable.centerY;

    self.contentTextView = [[YYLabel alloc]initWithFrame:CGRectMake(Interval(45), Interval(16)+ZOOM_SCALE(24), ZOOM_SCALE(240), ZOOM_SCALE(40))];
    self.contentTextView.font = RegularFONT(15);
    self.contentTextView.numberOfLines = 0;
    self.contentTextView.textColor = PWTitleColor;
    [self addSubview:self.contentTextView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgContentViewClick)];
    [self addGestureRecognizer:tap];
    self.dotView = [[UIView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(16), 0, 14, 14)];
    self.dotView.layer.cornerRadius = 7.0;
    self.dotView.centerY = self.titleLable.centerY;
    self.dotView.backgroundColor = PWBlueColor;
    [self addSubview:self.dotView];
    UIView *whiteDot = [[UIView alloc]initWithFrame:CGRectMake(3,3, 8, 8)];
    whiteDot.layer.cornerRadius = 4.0;
    whiteDot.backgroundColor = PWWhiteColor;
    [self.dotView addSubview:whiteDot];
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 3, SINGLE_LINE_WIDTH, 100)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"C7C7CC"];
    self.lineView.centerX = self.dotView.centerX;
    [self addSubview:self.lineView];
    [self bringSubviewToFront:self.dotView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(CalendarIssueModel *)model{
    _model = model;
    BOOL isHidden = [model.typeText isEqualToString:NSLocalizedString(@"local.NoIssueToday", @"")];
    self.statesLabel.hidden = isHidden;
    self.timeLabel.hidden = isHidden;
    self.titleLable.hidden = isHidden;
    self.dotView.hidden = isHidden;
    self.lineView.hidden = isHidden;
    _noDataLable.hidden = !isHidden;
    self.titleLable.text = model.typeText;
    self.timeLabel.text = model.timeText;
    self.contentTextView.text = model.contentText;
    if (model.isEnd) {
        self.statesLabel.text = NSLocalizedString(@"issue.recovered", @"");
        self.statesLabel.textColor = [UIColor colorWithHexString:@"#54DBAD"];
    }else{
        self.statesLabel.text = NSLocalizedString(@"local.active", @"");
        self.statesLabel.textColor = PWBlueColor;
    }
    CGFloat calendarContentH = model.calendarContentH?model.calendarContentH :ZOOM_SCALE(44);
    if (model.titleSize.height>0) {
        self.titleLable.height = model.titleSize.height;
        self.titleLable.width = model.titleSize.width;
        if (model.isIssue) {
            self.timeLabel.textAlignment = NSTextAlignmentLeft;
           self.timeLabel.frame = CGRectMake(Interval(45), 0, ZOOM_SCALE(32), ZOOM_SCALE(17));
        }else{
        if (model.titleSize.height<=ZOOM_SCALE(17)) {
            self.titleLable.centerY = self.dotView.centerY;
            self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLable.frame)+8, 0, ZOOM_SCALE(32), ZOOM_SCALE(17));
            self.timeLabel.centerY = self.titleLable.centerY;
        }else{
            self.timeLabel.frame = CGRectMake(kWidth-ZOOM_SCALE(84), 0, ZOOM_SCALE(32), ZOOM_SCALE(17));
        }
        }
    }else{
        self.noDataLable.text = model.typeText;
    }
    self.contentTextView.frame = CGRectMake(Interval(45), CGRectGetMaxY(self.titleLable.frame)+8, kWidth-Interval(61), calendarContentH);
    self.contentTextView.height = calendarContentH;
   
    switch (model.state) {
        case IssueStateWarning:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            break;
        case IssueStateSeriousness:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            break;
        case IssueStateCommon:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            break;
        case IssueStateRecommend:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];

            break;
        case IssueStateLoseeEfficacy:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            break;
    }
    self.lineView.height = model.calendarContentH +Interval(28)+model.titleSize.height;
}
-(YYLabel *)statesLabel{
    if (!_statesLabel) {
        _statesLabel =  [[YYLabel alloc]initWithFrame:CGRectMake(kWidth-16-ZOOM_SCALE(36), 0, ZOOM_SCALE(36), ZOOM_SCALE(17))];
        _statesLabel.font = RegularFONT(12);
        _statesLabel.textColor = PWBlueColor;
        _statesLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_statesLabel];
    }
    return _statesLabel;
}
-(YYLabel *)noDataLable{
    if (!_noDataLable) {
        _noDataLable = [[YYLabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(20))];
        _noDataLable.font = RegularFONT(12);
        _noDataLable.textColor = PWTextBlackColor;
        _noDataLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_noDataLable];
    }
    return _noDataLable;
}
-(void)setLineHide:(BOOL)lineHide{
    self.lineView.hidden = lineHide;
}
- (void)bgContentViewClick{
    if (self.CalendarListCellClick) {
        self.CalendarListCellClick();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
