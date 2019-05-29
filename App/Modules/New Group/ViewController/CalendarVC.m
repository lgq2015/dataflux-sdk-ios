//
//  CalendarVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarVC.h"
#import "LTSCalendarManager.h"
#import "CountListModel.h"

@interface CalendarVC ()<LTSCalendarEventSource>{
    NSMutableDictionary *eventsByDate;
}
@property (nonatomic, strong) LTSCalendarManager *manager;
@property (nonatomic, strong) NSMutableArray *loadMonth;
@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
    [self loadCalendarDot];
    // Do any additional setup after loading the view.
}
- (void)createNav{
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight+25)];
    [self.view addSubview:nav];
    nav.backgroundColor = PWWhiteColor;
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(18) textColor:PWBlackColor text:@"日历"];
    title.textAlignment = NSTextAlignmentCenter;
    [nav addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(nav);
        make.bottom.mas_equalTo(nav.mas_bottom).offset(-20);
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+24.5, kWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [nav addSubview:line];
}
- (void)createUI{
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, kTopHeight+37, kWidth, 30)];
    [self.view addSubview:self.manager.weekDayView];
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame)-kTabBarHeight)];
    [self.view addSubview:self.manager.calenderScrollView];
    [self loadCalendarDot];
    
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)loadCalendarDot{
    eventsByDate = [NSMutableDictionary new];
    NSDate *currentDate = [NSDate date];
    NSArray *dateary= [currentDate getDateMonthFirstLastDayTimeStamp];
    [self loadMoreCalendarDotWithStartTime:dateary[0] endTime:dateary[1]];
}
- (void)loadMoreCalendarDotWithStartTime:(NSNumber *)start endTime:(NSNumber *)end{
    
    WeakSelf
    [[PWHttpEngine sharedInstance]getCalendarDotWithStartTime:start EndTime:end callBack:^(id o) {
        CountListModel *model = (CountListModel *)o;
        if (model.isSuccess) {
            NSArray *dotAry = model.count_list;
            [dotAry enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *key =[NSString stringWithFormat:@"%ld",[obj longValueForKey:@"timestamp" default:0]];
                eventsByDate[key] =[NSNumber numberWithLong:[obj longValueForKey:@"count" default:0]];
            }];
            [weakSelf.manager reloadAppearanceAndData];
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
- (void)calendarDidScrolledYear:(NSInteger)year month:(NSInteger)month currentDate:(NSDate *)currentDate{
    DLog(@"year == %ld  month == %ld",(long)year,(long)month);
    NSArray *dateary= [currentDate getDateMonthFirstLastDayTimeStamp];
    DLog(@"dateary == %@",dateary);
    //待处理 避免重复的请求
    [self loadMoreCalendarDotWithStartTime:dateary[0] endTime:dateary[1]];
}
- (void)calendarDidSelectedDate:(NSDate *)date{
    DLog(@"sel date == %@ weekday == %ld",date, (long)[date weekday]);
    if ([date isToday]) {
        self.manager.calenderScrollView.arrorView.backTodayBtn.hidden = YES;
    }else{
        self.manager.calenderScrollView.arrorView.backTodayBtn.hidden = NO;
    }
    NSString *week;
    switch ((long)[date weekday]) {
        case 1:
            week = @"周日";
            break;
        case 2:
            week = @"周一";
            break;
        case 3:
            week = @"周二";
            break;
        case 4:
            week = @"周三";
            break;
        case 5:
            week = @"周四";
            break;
        case 6:
            week = @"周五";
            break;
        case 7:
            week = @"周六";
            break;
    }
    NSString *dateStr = [NSString stringWithFormat:@"%ld 月 %ld 日 %@",(long)[date month],(long)[date day],week];
    self.manager.calenderScrollView.arrorView.selDateLab.text = dateStr;
}
-(BOOL)calendarHaveEventWithDate:(NSDate *)date{
     NSInteger stamp = [date getTimeStamp];
    DLog(@"DotCurrentDate  == %@ stamp == %ld",date,stamp);
    NSString *key = [NSString stringWithFormat:@"%ld",(long)stamp];
    
    if(eventsByDate[key] && [eventsByDate[key] longValue]>0){
     
        return YES;
    }
    return NO;
}
- (void)calendarDidLoadPageCurrentDate:(NSDate *)date{
    DLog(@"CurrentDate  == %@",date);
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
