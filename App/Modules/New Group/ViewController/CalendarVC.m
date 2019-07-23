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
#import "CalendarListModel.h"
#import "CalendarIssueModel.h"
#import "IssueDetailsVC.h"
#import "HLSafeMutableArray.h"
#import "CalendarSelView.h"

@interface CalendarVC ()<LTSCalendarEventSource,CalendarSelDelegate>{
    NSMutableDictionary *eventsByDate;
    NSMutableDictionary *dotLoadDate;

}
@property (nonatomic, strong) LTSCalendarManager *manager;
@property (nonatomic, strong) NSMutableArray *loadMonth;
@property (nonatomic, assign) BOOL isLoadTop;
@property (nonatomic, strong) HLSafeMutableArray *calendarList;
@property (nonatomic, strong) CalendarSelView *selView;
@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
    [self loadCalendarDot];
    [self loadCurrentList];
    NSString *nameStr= NSLocalizedString(@"(sdd)issueLevelChanged", @"no");
    DLog(@"nameStr === %@",nameStr);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(issueTeamSwitch:)
                                                 name:KNotificationSwitchTeam
                                               object:nil];

    // Do any additional setup after loading the view.
}
-(NSMutableArray *)calendarList{
    if (!_calendarList) {
        _calendarList = [HLSafeMutableArray new];
    }
    return _calendarList;
}
-(CalendarSelView *)selView{
    if (!_selView) {
        _selView = [[CalendarSelView alloc]initWithTop:kTopHeight+25];
        _selView.disMissClick = ^(){
        };
        _selView.delegate = self;
    }
    return _selView;
}
- (void)issueTeamSwitch:(NSNotification *)notification{
    [self.manager showSingleWeek];
    [eventsByDate removeAllObjects];
    [dotLoadDate removeAllObjects];
    [_calendarList removeAllObjects];
    [self.manager goToDate:[NSDate date]];
    [self loadCalendarDot];
    [self loadCurrentList];
    [self.manager reloadAppearanceAndData];
}
#pragma mark ========== UI ==========
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
    UIButton *changeViewBtn = [[UIButton alloc]init];
    [changeViewBtn setImage:[UIImage imageNamed:@"calendar_navbtn"] forState:UIControlStateNormal];
    [changeViewBtn addTarget:self action:@selector(switchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:changeViewBtn];
    [changeViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(nav).offset(-20);
        make.right.mas_equalTo(nav).offset(-13);
        make.width.height.offset(28);
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+24.5, kWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [nav addSubview:line];
}
- (void)switchBtnClick{
    if (self.selView.isShow) {
        [self.selView disMissView];
    }else{
    [self.selView showInView:[UIApplication sharedApplication].keyWindow];
    }
}
- (void)createUI{
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, kTopHeight+26, kWidth, 30)];
    [self.view addSubview:self.manager.weekDayView];
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame)-kTabBarHeight)];
    [self.view addSubview:self.manager.calenderScrollView];
    [self loadCalendarDot];
    
    self.automaticallyAdjustsScrollViewInsets = false;
}
#pragma mark ========== NETWORKING ==========
- (void)loadCalendarDot{
    eventsByDate = [NSMutableDictionary new];
    dotLoadDate = [NSMutableDictionary new];
    NSDate *currentDate = [NSDate date];
    NSString *start = [[currentDate beginningOfMonth] getUTCTimeStr];
    [dotLoadDate addEntriesFromDictionary:@{start:@1}];
    
    [self loadMoreCalendarDotWithStartTime:start endTime:[currentDate getUTCTimeStr]];
}
- (void)loadMoreCalendarDotWithStartTime:(NSString *)start endTime:(NSString *)end {
    
    WeakSelf
    [[PWHttpEngine sharedInstance]getCalendarDotWithStartTime:start EndTime:end callBack:^(id o) {
        CountListModel *model = (CountListModel *)o;
        if (model.isSuccess) {
            NSArray *dotAry = model.count_list;
            [dotAry enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                NSString *key =[obj stringValueForKey:@"DATE" default:0];
    
                eventsByDate[key] =[NSNumber numberWithLong:[obj longValueForKey:@"count" default:0]];
            }];
            [weakSelf.manager reloadAppearanceAndData];
        }else{
          
        }
    }];
}
- (void)loadCurrentList{
    self.isLoadTop = YES;
    NSDate *currentDate = [NSDate date];
    NSString *start = [[currentDate beginningOfMonth] getUTCTimeStr];
    [self loadListWithStartTime:start endTime:[currentDate getUTCTimeStr] loadNew:YES];
    [self.manager endRefreshing];

}
- (void)loadListWithStartTime:(NSString *)start endTime:(NSString *)end loadNew:(BOOL)new{
    [self.manager.calenderScrollView showLoadFooterView];
    [[PWHttpEngine sharedInstance] getCalendarListWithStartTime:start EndTime:end pageMarker:-1 orderMethod:@"desc" callBack:^(id response) {
        [self.manager endRefreshing];
        CalendarListModel *model = (CalendarListModel *)response;
        if (model.isSuccess) {
            __block NSString *tempTitle;
            __block NSMutableArray *group = [NSMutableArray new];
            __block NSMutableArray *calendarList = [NSMutableArray new];
            
            [model.list enumerateObjectsUsingBlock:^(CalendarIssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.groupTitle isEqualToString:tempTitle]) {
                    [group addObject:obj];
                }else{
                    tempTitle = obj.groupTitle;
                    if (group.count>0) {
                        [calendarList addObject:[NSArray arrayWithArray:[group copy]]];
                        [group removeAllObjects];
                    }
                    [group addObject:obj];
                }
                if (idx == model.list.count-1) {
                    [calendarList addObject:[NSArray arrayWithArray:[group copy]]];
                }
            }];
            CalendarIssueModel *model2;
            if (calendarList.count>0) {
                model2 = calendarList[0][0];
            }
            
            if (![model2.dayDate isToday] && new) {
                CalendarIssueModel *model1 = [CalendarIssueModel new];
                model1.groupTitle = [[NSDate date] getCalenarTimeStr];
                model1.dayDate = [NSDate date];
                model1.typeText = @"今日无情报";
                model1.seq= -1;
                [calendarList insertObject:@[model1] atIndex:0];
            }
            if (model.pageSize>model.count) {
                [self.manager.calenderScrollView showNomoreDatasFooter];
            }else{
                self.manager.calenderScrollView.tableView.tableFooterView = nil;
            }
            
             [self.calendarList removeAllObjects];
             [self.calendarList addObjectsFromArray:[calendarList copy]];
             [self.manager tablewViewDatasAddBeforeRemove:self.calendarList];
            if (model.list.count<2) {
                [self loadMoreList];
            }
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
#pragma mark ========== footerrefreshing ==========
- (void)loadMoreList{
    NSArray *array = [self.manager.calenderScrollView.calendarList lastObject];
    CalendarIssueModel *model =  [array lastObject];
    [[PWHttpEngine sharedInstance]getCalendarListWithStartTime:@"" EndTime:@"" pageMarker:model.seq orderMethod:@"desc" callBack:^(id response) {
        [self.manager endRefreshing];
        CalendarListModel *model = (CalendarListModel *)response;
        if (model.isSuccess) {
            if( model.list.count>0){
            __block NSMutableArray *calendarList = [self.manager.calenderScrollView.calendarList mutableCopy];
            
            __block NSMutableArray *group = [[calendarList lastObject] mutableCopy];
            CalendarIssueModel *issueModel = [group lastObject];
            __block NSString *tempTitle = issueModel.groupTitle;
            [model.list enumerateObjectsUsingBlock:^(CalendarIssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.groupTitle isEqualToString:tempTitle]) {
                    if (idx == 0) {
                        [calendarList removeLastObject];
                    }
                    [group addObject:obj];
                }else{
                    tempTitle = obj.groupTitle;
                    if (group.count>0 ) {
                        if (idx !=0) {
                            [calendarList addObject:[NSArray arrayWithArray:[group mutableCopy]]];
                        }
                        [group removeAllObjects];
                    }
                    [group addObject:obj];
                }
                if (idx == model.list.count-1) {
                    [calendarList addObject:[NSArray arrayWithArray:[group mutableCopy]]];
                }
            }];
           
            
            
         
                //刷新完成，执行后续代码
                [self.calendarList removeAllObjects];
                [self.calendarList addObjectsFromArray:calendarList];
                [self.manager tablewViewDatasAddBeforeRemove:calendarList];

                
            if (model.count<model.pageSize) {
                [self.manager.calenderScrollView showNomoreDatasFooter];
            }
            }else{
                [self.manager.calenderScrollView showNomoreDatasFooter];
            }
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}

#pragma mark ========== LTSCalendarEventSource ==========
- (void)calendarDidScrolledYear:(NSInteger)year month:(NSInteger)month firstDay:(NSDate *)first lastDay:(NSDate *)last currentDate:(NSDate *)currentDate{
    DLog(@"year == %ld  month == %ld",(long)year,(long)month);
    NSDate *today = [NSDate date];
    if (month>[today month]) {
        if (year>=[today year]) {
            return;
        }
    }
    NSArray *dateary= [currentDate getDateMonthFirstLastDayTimeStamp];
    DLog(@"dateary == %@",dateary);
    // 避免重复的请求
    if ([dotLoadDate containsObjectForKey:dateary[0]]) {
        return;
    }
    [dotLoadDate addEntriesFromDictionary:@{dateary[0]:@1}];
    [self loadMoreCalendarDotWithStartTime:[first getUTCTimeStr] endTime:[currentDate getUTCTimeStr]];
}
- (void)calendarDidSelectedDate:(NSDate *)date firstDay:(NSDate *)first lastDay:(NSDate *)last{
    
    DLog(@"sel date == %@ weekday == %ld",date, (long)[date weekday]);
    if ([date isToday]) {
        self.manager.calenderScrollView.arrorView.backTodayBtn.hidden = YES;
    }else{
        self.manager.calenderScrollView.arrorView.backTodayBtn.hidden = NO;
    }
    self.manager.calenderScrollView.arrorView.selDateLab.text = [date getCalenarTimeStr];
    __block BOOL isHas = NO;
    WeakSelf
    
    [[self.manager.calenderScrollView.calendarList copy] enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CalendarIssueModel *model =obj[0];
        if ([model.groupTitle isEqualToString:[date getCalenarTimeStr]]) {
            isHas = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.manager.calenderScrollView.isUser = NO;

                 [weakSelf.manager.calenderScrollView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:idx] atScrollPosition:UITableViewScrollPositionTop animated:YES];

            });

            *stop = YES;
        }
    }];
    if (!isHas) {
        if ([date isToday]) {
            [self loadCurrentList];
        }else{
            if ([date isToday]) {
                [self loadCurrentList];
            }else{
                self.isLoadTop = NO;
        [self loadListWithStartTime:[first getUTCTimeStr] endTime:[last getUTCTimeStr] loadNew:NO];
            }
    }
    }
}
-(BOOL)calendarHaveEventWithDate:(NSDate *)date{
  
    NSString *key = [date getTimeStr];
    
    if(eventsByDate[key] && [eventsByDate[key] longValue]>0){

        return YES;
    }
    return NO;
}


-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CalendarIssueModel *model = self.manager.calenderScrollView.calendarList[indexPath.section][indexPath.row];
    if (model.issueId && model.issueId.length>0) {
        [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSDictionary *content = PWSafeDictionaryVal(response, @"content");
                IssueListViewModel *detailModel = [[IssueListViewModel alloc]initWithDictionary:content];
                IssueDetailsVC *detail = [[IssueDetailsVC alloc]init];
                detail.model = detailModel;
                [self.navigationController pushViewController:detail animated:YES];
            }
        } failBlock:^(NSError *error) {
            [error errorToast];
        }];
    }
}
- (void)tableViewLoadMoreData{
    [self loadMoreList];
}
- (void)tableViewLoadHeaderData{
    [self loadTopDatas];
}
- (void)loadTopDatas{
    __block NSMutableArray *ary = [self.manager.calenderScrollView.calendarList mutableCopy];
    if (self.isLoadTop) {
        NSDate *currentDate = [NSDate date];
        NSString *start = [[currentDate beginningOfMonth] getUTCTimeStr];
        [[PWHttpEngine sharedInstance] getCalendarListWithStartTime:start EndTime:[currentDate getUTCTimeStr] pageMarker:-1 orderMethod:@"desc" callBack:^(id response) {
            [self.manager endRefreshing];
            CalendarListModel *model = (CalendarListModel *)response;
            if (model.isSuccess) {
                if (model.list.count>0) {
                    [ary removeObjectAtIndex:0];
                    [ary insertObject:model.list atIndex:0];
                    [self.calendarList removeAllObjects];
                    [self.calendarList addObjectsFromArray:ary];
                    [self.manager tablewViewDatasAddBeforeRemove:ary];
                }
            }
        }];
    }else{
        NSMutableArray *first = [ary firstObject];
        CalendarIssueModel *firstmodel = [first firstObject];
        WeakSelf
        [[PWHttpEngine sharedInstance] getCalendarListWithStartTime:@"" EndTime:@"" pageMarker:firstmodel.seq orderMethod:@"asc" callBack:^(id response) {
            [self.manager endRefreshing];
            CalendarListModel *model = (CalendarListModel *)response;
            if (model.isSuccess) {
                if (model.list.count>0) {
                    __block NSString *tempTitle = firstmodel.groupTitle;
                    __block NSMutableArray *group = [first mutableCopy];
                    [model.list enumerateObjectsUsingBlock:^(CalendarIssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.groupTitle isEqualToString:tempTitle]) {
                            if(idx == 0){
                                [ary removeObjectAtIndex:0];
                            }
                            [group insertObject:obj atIndex:0];
                        }else{
                            tempTitle = obj.groupTitle;
                            if (group.count>0 ) {
                                if (idx !=0) {
                                    [ary insertObject:[NSArray arrayWithArray:[group copy]] atIndex:0];
                                }
                                [group removeAllObjects];
                            }
                            [group insertObject:obj atIndex:0];
                        }
                        if (idx == model.list.count-1) {
                            [ary insertObject:[NSArray arrayWithArray:[group copy]] atIndex:0];
                        }
                    }];
                    if (model.pageSize>model.count) {
                        self.isLoadTop = YES;
                        CalendarIssueModel *model1 = [CalendarIssueModel new];
                        model1.groupTitle = [[NSDate date] getCalenarTimeStr];
                        model1.dayDate = [NSDate date];
                        model1.typeText = @"今日无情报";
                        model1.seq= -1;
                        [ary insertObject:@[model1] atIndex:0];
                    }
                    NSInteger section = ary.count-self.manager.calenderScrollView.calendarList.count>0?ary.count-self.manager.calenderScrollView.calendarList.count-1:0;
                    NSArray *rowAry =ary[section];
                    CalendarIssueModel *issuemodel = rowAry[0];
                    NSInteger row = rowAry.count-1;
                    
                    if ([issuemodel.groupTitle isEqualToString:firstmodel.groupTitle]) {
                        row = rowAry.count -first.count>0?rowAry.count -first.count-1:0;
                    }
                   
                    [self.calendarList removeAllObjects];
                    [self.calendarList addObjectsFromArray:ary];
                    [self.manager tablewViewDatasAddBeforeRemove:ary];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.manager.calenderScrollView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                }
                
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
    }

}
- (void)backToToday{
    //待处理  dot获取优化（2.之前的数据没有数据后 不请求 3.第一次请求请求当前显示所有）
    if(self.calendarList.count>0){
        CalendarIssueModel *model = [self.calendarList firstObject][0];
        if (![model.groupTitle isEqualToString:[[NSDate date] getCalenarTimeStr]]) {
            [self loadCurrentList];
        }
    }
}
#pragma mark ========== CalendarSelDelegate ==========
-(void)selectCalendarViewType:(CalendarViewType )type{
    [userManager setCurrentIssueSortType:type];
    if(self.manager.calenderScrollView.viewType != type){
        self.manager.calenderScrollView.viewType = type;
        [self.manager.calenderScrollView backToday];
        [self.manager showSingleWeek];
        [eventsByDate removeAllObjects];
        [dotLoadDate removeAllObjects];
        [_calendarList removeAllObjects];
        [self.manager goToDate:[NSDate date]];
        [self loadCalendarDot];
        [self loadCurrentList];
        [self.manager reloadAppearanceAndData];
    }
    [self.selView disMissView];
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
