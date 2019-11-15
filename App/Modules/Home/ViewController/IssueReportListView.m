//
//  IssueReportListView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueReportListView.h"
#import "MineCellModel.h"
#import "MineViewCell.h"
#import "IssueModel.h"
#import "IssueListViewModel.h"
#import "IssueDetailsVC.h"
#import "IssueListManger.h"
#import "ClassifyModel.h"
@interface IssueReportListView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation IssueReportListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotificationCenter addObserver:self
                                    selector:@selector(updateAllData)
                                        name:KNotificationUpdateIssueList
                                      object:nil];
    [self createUI];
}
- (void)createUI{
    self.tableView.rowHeight = ZOOM_SCALE(45);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.tableFooterView = self.footView;
    [self.view addSubview:self.tableView];
}
- (void)updateAllData{
     ClassifyModel *reportModel = [[IssueListManger sharedIssueListManger] getIssueWithClassifyType:ClassifyTypeReport];
    switch (self.type) {
        case ReportListTypeDaily:
            self.datas = reportModel.dayAry;
            break;
        case ReportListTypeWebSecurity:
            self.datas = reportModel.webAry;
            break;
        case ReportListTypeService:
            self.datas = reportModel.serviceAry;
            break;
    }
    [self.tableView reloadData];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    MineCellModel *model = [MineCellModel new];
    IssueModel *issue = self.datas[indexPath.row];
    
    model.title =[NSString getLocalDateFormateUTCDate:issue.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outdateFormatted:@"yyyy-MM-dd"];
    [cell initWithData:model type:MineVCCellTypeOnlyTitle];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IssueModel *model =self.datas[indexPath.row];
    IssueListViewModel *viewModel = [[IssueListViewModel alloc]initWithJsonDictionary:model];
    model.isRead = YES;
    IssueDetailsVC *detailsVC = [[IssueDetailsVC alloc]init];
    detailsVC.model = viewModel;
    [self.navigationController pushViewController:detailsVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
