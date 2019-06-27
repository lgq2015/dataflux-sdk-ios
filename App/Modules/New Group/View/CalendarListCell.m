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
    self.titleLable = [[YYLabel alloc]initWithFrame:CGRectMake(Interval(45), 0, kWidth-ZOOM_SCALE(130), ZOOM_SCALE(20))];
    self.titleLable.numberOfLines = 0;
    self.titleLable.font = RegularFONT(12);
    self.titleLable.textColor = PWTextBlackColor;
    [self addSubview:self.titleLable];
    self.timeLabel = [[YYLabel alloc]initWithFrame:CGRectMake(kWidth-Interval(20)-ZOOM_SCALE(50), 0, ZOOM_SCALE(50), ZOOM_SCALE(17))];
    self.timeLabel.centerY = self.titleLable.centerY;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = RegularFONT(12);
    self.timeLabel.textColor = PWSubTitleColor;
    [self addSubview:self.timeLabel];
  
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
    BOOL isHidden = [model.typeText isEqualToString:@"今日无情报"];
   
    self.timeLabel.hidden = isHidden;
    self.dotView.hidden = isHidden;
    self.lineView.hidden = isHidden;
    self.titleLable.text = model.typeText;
    self.timeLabel.text = model.timeText;
    self.contentTextView.text = model.contentText;
    //[[NSAttributedString alloc]initWithString:model.contentText];
    CGFloat calendarContentH = model.calendarContentH?model.calendarContentH :ZOOM_SCALE(44);
    if (model.titleH>0) {
        self.titleLable.height = model.titleH;
        self.titleLable.frame = CGRectMake(Interval(45), 0, CGRectGetMinX(self.timeLabel.frame)-Interval(45), ZOOM_SCALE(20));
        self.titleLable.height = model.titleH;
        self.titleLable.textAlignment = NSTextAlignmentLeft;
    }else{
        self.titleLable.frame = CGRectMake(0, 0, kWidth, ZOOM_SCALE(20));
        self.titleLable.textAlignment = NSTextAlignmentCenter;
    }
    self.contentTextView.frame = CGRectMake(Interval(45), CGRectGetMaxY(self.titleLable.frame)+8, kWidth-Interval(61), calendarContentH);
    self.contentTextView.height = calendarContentH;
   
    switch (model.state) {
        case IssueStateWarning:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.statesLabel.text = @"警告";
            break;
        case IssueStateSeriousness:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.statesLabel.text = @"严重";
            break;
        case IssueStateCommon:
            self.dotView.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            self.statesLabel.text = @"提示";
            break;
        case IssueStateRecommend:
            self.statesLabel.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.statesLabel.text = @"已恢复";

            break;
        case IssueStateLoseeEfficacy:
            self.statesLabel.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.statesLabel.text = @"失效";
            break;
    }
    self.lineView.height = model.calendarContentH +Interval(28)+model.titleH;
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
