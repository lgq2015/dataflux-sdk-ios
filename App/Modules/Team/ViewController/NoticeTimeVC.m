//
//  ViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NoticeTimeVC.h"
#import "NotiRuleModel.h"
#import "TouchLargeButton.h"
#import "HYTimePickerView.h"

@interface NoticeTimeVC ()<TimePickerViewDelegate>
@property (nonatomic, strong) TouchLargeButton *startBtn;
@property (nonatomic, strong) TouchLargeButton *endBtn;
@end

@implementation NoticeTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.noticeTime", @"");
    [self createUI];
}
-(void)createUI{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, kWidth, ZOOM_SCALE(65))];
    contentView.backgroundColor = PWWhiteColor;
    [self.view addSubview:contentView];
    UILabel *startLab = [PWCommonCtrl lableWithFrame:CGRectMake(64, 8, ZOOM_SCALE(60), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#595860"] text:NSLocalizedString(@"local.startTime", @"")];
    [contentView addSubview:startLab];
    
    UILabel *endLab = [PWCommonCtrl lableWithFrame:CGRectMake(kWidth-64-ZOOM_SCALE(60), 8, ZOOM_SCALE(60), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#595860"] text:NSLocalizedString(@"local.endTime", @"")];
    [contentView addSubview:endLab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake((kWidth-ZOOM_SCALE(14))/2.0, CGRectGetMaxY(startLab.frame)+3, ZOOM_SCALE(14), ZOOM_SCALE(3))];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [contentView addSubview:line];
    [contentView addSubview:self.startBtn];
    [contentView addSubview:self.endBtn];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(startLab.mas_bottom).offset(6);
        make.centerX.mas_equalTo(startLab);
        make.height.offset(ZOOM_SCALE(22));
        make.width.offset(ZOOM_SCALE(115));
    }];
    [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(endLab.mas_bottom).offset(6);
        make.centerX.mas_equalTo(endLab);
        make.height.offset(ZOOM_SCALE(22));
        make.width.offset(ZOOM_SCALE(115));
    }];
    if (self.model == nil) {
        self.model = [[NotiRuleModel alloc]init];
        self.model.startTime = @"00:00";
        self.model.endTime = @"23:59";
    }else{
        self.startBtn.selected = YES;
        [self.startBtn setTitle:self.model.startTime forState:UIControlStateSelected];
        self.endBtn.selected = YES;
        [self.endBtn setTitle:self.model.endTime forState:UIControlStateSelected];
    }
    
}
-(TouchLargeButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [[TouchLargeButton alloc]init];
        [_startBtn setTitle:NSLocalizedString(@"local.pleaseSelectStartTime", @"") forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor colorWithHexString:@"#C7C7CC"] forState:UIControlStateNormal];
        [_startBtn setTitleColor:PWTextColor forState:UIControlStateSelected];
        _startBtn.titleLabel.font = RegularFONT(16);
        [_startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}
-(TouchLargeButton *)endBtn{
    if (!_endBtn) {
        _endBtn = [[TouchLargeButton alloc]init];
        [_endBtn setTitle:NSLocalizedString(@"local.pleaseSelectEndTime", @"") forState:UIControlStateNormal];
        [_endBtn setTitleColor:[UIColor colorWithHexString:@"#C7C7CC"] forState:UIControlStateNormal];
        [_endBtn setTitleColor:PWTextColor forState:UIControlStateSelected];
        [_endBtn setTitleColor:PWTextColor forState:UIControlStateHighlighted];
        _endBtn.titleLabel.font = RegularFONT(16);
        [_endBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBtn;
}
- (void)startBtnClick{
    NSString *selectedHour,*selectedMin;
     NSArray *time = [self.model.startTime componentsSeparatedByString:@":"];
    selectedHour = [time firstObject];
    selectedMin = [time lastObject];
    
    HYTimePickerView *picker = [[HYTimePickerView alloc] initDatePackerWithStartHour:@"00" endHour:@"24" period:1 selectedHour:selectedHour selectedMin:selectedMin tag:33];
    picker.delegate = self;
    [picker show];
}
- (void)endBtnClick{
    NSString *selectedHour,*selectedMin;
    NSArray *time = [self.model.endTime componentsSeparatedByString:@":"];
    selectedHour = [time firstObject];
    selectedMin = [time lastObject];
    HYTimePickerView *picker = [[HYTimePickerView alloc] initDatePackerWithStartHour:@"00" endHour:@"24" period:1 selectedHour:selectedHour selectedMin:selectedMin tag:44];
    picker.delegate = self;
    [picker show];
}
-(void)timePickerViewDidSelectRow:(NSString *)time tag:(NSInteger)tag{
    if (tag == 33) {
        self.model.startTime = time;
        self.startBtn.selected = YES;
        [self.startBtn setTitle:time forState:UIControlStateSelected];
    }else{
        self.model.endTime = time;
        self.endBtn.selected = YES;
        [self.endBtn setTitle:time forState:UIControlStateSelected];
    }
    if (self.timeBlock) {
        self.timeBlock(self.model.startTime, self.model.endTime);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
