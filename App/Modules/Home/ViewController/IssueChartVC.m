//
//  IssueChartVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartVC.h"
#import "IssueListManger.h"
#import "IssueChartCell.h"
#import "IssueChartListVC.h"
#import "IssueChartEchartCell.h"
#import "IssueChartListCell.h"
#import "IssueReportListView.h"
#import "AlarmChartListModel.h"
#import "HLSafeMutableArray.h"
#import "AlarmItemModel.h"
#import "ReportListModel.h"

@interface IssueChartVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HLSafeMutableArray *dataSource;
@property (nonatomic, strong) NSDictionary *currentChart;
@property (nonatomic, strong) ClassifyModel *reportModel;
@end

@implementation IssueChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [HLSafeMutableArray new];
    self.reportModel = [ClassifyModel new];
    [self createUI];
    [self refreshDataWithIsChangeTeam:YES];
}
- (void)refreshDataWithIsChangeTeam:(BOOL)isChange{
    [self.dataSource removeAllObjects];
       ClassifyModel *crontabModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeCrontab];
       ClassifyModel *taskModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeTask];
       ClassifyModel *alarmModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeAlarm];
//       ClassifyModel *reportModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeReport];
       [self.dataSource addObjectsFromArray:@[crontabModel,taskModel,alarmModel]];
    if (isChange) {
        NSDate *currentdate = [NSDate date];
             NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
             NSDateComponents *datecomps = [[NSDateComponents alloc] init];
            [datecomps setDay:-6];
            NSDate *startcalculatedate = [calendar dateByAddingComponents:datecomps toDate:currentdate options:0];
            NSString *end=[currentdate getUTCTimeStr];
            NSString *start = [startcalculatedate getUTCTimeStr];
           WeakSelf
            [[PWHttpEngine sharedInstance] alarmEchartWithStartTime:start endTime:end callBack:^(id response) {
                AlarmChartListModel *model = response;
                if (model.isSuccess) {
                    if (self.dataSource.count>0) {
                        ClassifyModel *chart = self.dataSource[2];
                        weakSelf.currentChart =[weakSelf getWeekAlarmData:model.list];
                        chart.echartDatas =weakSelf.currentChart;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView reloadData];
                        });
                       }
                }
            }];
        [self getRepprtList];
    }else{
        self.currentChart?alarmModel.echartDatas = self.currentChart:nil;
        self.reportModel? [self.dataSource addObject:self.reportModel]:nil;
        [self.tableView reloadData];
    }
}
-(void)getRepprtList{
    __block ClassifyModel *reportModel = [ClassifyModel new];
    WeakSelf
       dispatch_queue_t queueT = dispatch_queue_create("report.queue", DISPATCH_QUEUE_CONCURRENT);//一个并发队列
       dispatch_group_t grpupT = dispatch_group_create();//一个线程组
   
    dispatch_group_async(grpupT, queueT,^{
        dispatch_group_enter(grpupT);
        [[PWHttpEngine sharedInstance] reportListWithSubType:@"daily_report" pageMarker:-1  callBack:^(id response) {
                   ReportListModel *model = response;
                   if (model.isSuccess) {
                       reportModel.dayAry = model.list;
                   }
                 dispatch_group_leave(grpupT);
               }];
    });
    dispatch_group_async(grpupT, queueT,^{
        dispatch_group_enter(grpupT);
        [[PWHttpEngine sharedInstance] reportListWithSubType:@"service_report" pageMarker:-1  callBack:^(id response) {
                   ReportListModel *model = response;
                   if (model.isSuccess) {
                       reportModel.serviceAry = model.list;
                   }
                 dispatch_group_leave(grpupT);
               }];
    });
    dispatch_group_async(grpupT, queueT,^{
           dispatch_group_enter(grpupT);
           [[PWHttpEngine sharedInstance] reportListWithSubType:@"web_security_report" pageMarker:-1 callBack:^(id response) {
                      ReportListModel *model = response;
                      if (model.isSuccess) {
                          reportModel.webAry = model.list;
                      }
                    dispatch_group_leave(grpupT);
                  }];
       });
    dispatch_group_notify(grpupT, queueT, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger i=0;
            i = reportModel.dayAry.count>0?i+1:i;
            i = reportModel.serviceAry.count>0?i+1:i;
            i = reportModel.webAry.count>0?i+1:i;
            i = i==0?i+1:i;
            reportModel.title = NSLocalizedString(@"local.report", @"");
            reportModel.cellIdentifier = @"IssueChartListCell";
            reportModel.cellHeight = ZOOM_SCALE(54)+i*ZOOM_SCALE(44);
            weakSelf.reportModel = reportModel;
            [weakSelf.dataSource addObject:reportModel];
            [weakSelf.tableView reloadData];
        });
    });
}
-(NSDictionary *)getWeekAlarmData:(NSArray *)allData{
     
    NSMutableArray *datas = [NSMutableArray new];
   
    for (NSInteger i=0; i<7; i++) {
        NSDate *currentdate = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentdate];
        NSDate *startDate = [calendar dateFromComponents:components];
        NSDateComponents *datecomps = [[NSDateComponents alloc] init];
        [datecomps setDay:-i];
        NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:startDate options:0];
        NSMutableArray *item = [NSMutableArray new];
        [item addObject:[calculatedate getMonthDayTimeStr]];
       __block NSString *count = @"0";
        [allData enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AlarmItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[calculatedate getMonthDayTimeStr] isEqualToString:model.title]) {
                count = model.count;
                *stop = YES;
            }
        }];
        [item addObject:count];
        [datas insertObject:item atIndex:0];
    }
    NSMutableDictionary *echartData = [NSMutableDictionary new];
         [echartData addEntriesFromDictionary:@{@"xAxis":@{@"type":@"time",
                                                           @"name":@"",
         },
                                                @"yAxis":@{@"interval":@5,
                                                           @"type":@"value",
                                                           @"name":@"",
                                                },
                                                @"title":@{@"text":NSLocalizedString(@"local.AlarmEchartTitle", @"")},
                                                @"legend":@{@"data":NSLocalizedString(@"local.alarm", @"")},
         }];
    
         [echartData addEntriesFromDictionary:@{@"series":@[@{@"data":datas,
                                                            @"id":@"itemA",
                                                            @"name":NSLocalizedString(@"local.alarm", @""),
                                                            @"type":@"line",
         }]}];
    return echartData;
}

- (void)createUI{
   
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-Interval(98)-kStatusBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.tableView registerClass:IssueChartCell.class forCellReuseIdentifier:@"IssueChartCell"];
    [self.tableView registerClass:IssueChartEchartCell.class forCellReuseIdentifier:@"IssueChartEchartCell"];
    [self.tableView registerClass:IssueChartListCell.class forCellReuseIdentifier:@"IssueChartListCell"];
   self.tableView.mj_header = self.header;

}
-(void)headerRefreshing{
    [self refreshDataWithIsChangeTeam:YES];
    [self.header endRefreshing];
}
#pragma mark ========== UITableViewDelegate ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyModel *model =self.dataSource[indexPath.row];
    IssueChartCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellIdentifier];
    cell.model = model;
    if ([cell.model.cellIdentifier isEqualToString:@"IssueChartListCell"]) {
       WeakSelf
        cell.block = ^(NSInteger ide){
            [weakSelf pushListViewWithIdentify:ide];
        };
    }else{
       WeakSelf
        cell.block = ^(NSInteger ide){
           IssueChartListVC *chartList = [IssueChartListVC new];
           chartList.model = weakSelf.dataSource[indexPath.row];
           chartList.level = ide;
           [weakSelf.navigationController pushViewController:chartList animated:YES];
        };
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)pushListViewWithIdentify:(NSInteger)ide{
    IssueReportListView *list = [IssueReportListView new];
    ClassifyModel *model = [self.dataSource lastObject];
    list.type = ide;
    if (ide==1) {
        list.datas = model.dayAry;
        list.title = NSLocalizedString(@"local.dailyReport", @"");
    }else if (ide==2){
        list.datas = model.webAry;
        list.title = NSLocalizedString(@"local.webSecurityReport", @"");
    }else{
        list.datas = model.serviceAry;
        list.title = NSLocalizedString(@"local.serviceReport", @"");
    }
    [self.navigationController pushViewController:list animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
