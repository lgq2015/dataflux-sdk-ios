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
#import "ReportListModel.h"

@interface IssueReportListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *subType;
@end

@implementation IssueReportListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    switch (self.type) {
        case ReportListTypeDaily:
            self.subType = @"daily_report";
            break;
        case ReportListTypeWebSecurity:
            self.subType = @"web_security_report";
            break;
        case ReportListTypeService:
            self.subType = @"service_report";
            break;
    }
    self.dataSource = [NSMutableArray new];
    
    self.currentPage =1;
    self.tableView.rowHeight = ZOOM_SCALE(45);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);

    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    [self.view addSubview:self.tableView];
    [self dealWithData:self.datas];
}
-(void)headerRefreshing{
   self.currentPage = 1;
    [SVProgressHUD show];
    WeakSelf
    [[PWHttpEngine sharedInstance] reportListWithSubType:self.subType pageMarker:-1 callBack:^(id response) {
        ReportListModel *model = response;
        [SVProgressHUD dismiss];
        if (model.isSuccess) {
            [self.dataSource removeAllObjects];
            [self dealWithData:model.list];
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
        [weakSelf.header endRefreshing];
    }];
}
-(void)footerRefreshing{
    IssueModel *model = [self.dataSource lastObject];
    [[PWHttpEngine sharedInstance] reportListWithSubType:self.subType pageMarker:model.seq  callBack:^(id response) {
        ReportListModel *model = response;
        [SVProgressHUD dismiss];
        if (model.isSuccess) {
            [self dealWithData:model.list];
            [self.footer endRefreshing];
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
- (void)dealWithData:(NSArray *)array{
    [self.dataSource addObjectsFromArray:array];
     if (self.dataSource.count == 0) {
            [self showNoDataImage];
        }else{
            [self removeNoDataImage];
            if (array.count<20) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footer;
            }
        }
    [self.tableView reloadData];
}
- (void)updateAllData{
    
    [self.tableView reloadData];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    MineCellModel *model = [MineCellModel new];
    IssueModel *issue = self.dataSource[indexPath.row];
    
    model.title =[NSString getLocalDateFormateUTCDate:issue.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outdateFormatted:@"yyyy-MM-dd"];
    [cell initWithData:model type:MineVCCellTypeOnlyTitle];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IssueModel *model = self.dataSource[indexPath.row];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
