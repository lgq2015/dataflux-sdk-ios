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

@interface IssueChartVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<ClassifyModel *> *dataSource;
@end

@implementation IssueChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshData];
}
- (void)refreshData{
    self.dataSource = [NSMutableArray new];
       ClassifyModel *crontabModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeCrontab];
       ClassifyModel *taskModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeTask];
       ClassifyModel *alarmModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeAlarm];
       ClassifyModel *reportModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeReport];
       [self.dataSource addObjectsFromArray:@[crontabModel,taskModel,alarmModel,reportModel]];
     [self.tableView reloadData];
       
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


}
#pragma mark ========== UITableViewDelegate ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataSource[indexPath.row].cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource[indexPath.row].type == ClassifyTypeReport) {
        return;
    }else{
        IssueChartListVC *chartList = [IssueChartListVC new];
        chartList.model = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:chartList animated:YES];
    }
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)pushListViewWithIdentify:(NSInteger)ide{
    IssueReportListView *list = [IssueReportListView new];
    if (ide==1) {
        list.datas = [self.dataSource lastObject].dayAry;
        list.title = NSLocalizedString(@"local.dailyReport", @"");
    }else if (ide==2){
        list.datas = [self.dataSource lastObject].webAry;
        list.title = NSLocalizedString(@"local.webSecurityReport", @"");
    }else{
        list.datas = [self.dataSource lastObject].serviceAry;
        list.title = NSLocalizedString(@"local.serviceReport", @"");
    }
    [self.navigationController pushViewController:list animated:YES];
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
