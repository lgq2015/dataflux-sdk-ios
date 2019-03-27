//
//  ServiceLogVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ServiceLogVC.h"
#import "MonitorCell.h"
#import "InfoDetailVC.h"
#import "ProblemDetailsVC.h"
@interface ServiceLogVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageMaker;
@property (nonatomic, strong) MonitorCell *tempCell;

@end

@implementation ServiceLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务记录";
    [self createUI];
    [self loadTeamNeedData];
}
- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MonitorCell class] forCellReuseIdentifier:@"MonitorCell"];
    self.tempCell = [[MonitorCell alloc] initWithStyle:0 reuseIdentifier:@"MonitorCell"];
}
- (void)loadTeamNeedData{
    [SVProgressHUD show];
    NSDictionary *params =@{@"_withLatestIssueLog":@YES,
                            @"orderBy":@"seq",
                            @"_latestIssueLogLimit":@1,
                            @"orderMethod":@"desc",
                            @"pageSize":@10,
                            @"ticketType":@"serviceEvent",
                            @"_latestIssueLogSubType":@"comment"};
    [PWNetworking requsetHasTokenWithUrl:PW_issueGeneralList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *pageInfo = response[@"content"][@"pageInfo"];
            NSArray *data = response[@"content"][@"data"];
            if (data.count>0) {
                [self dealWithData:data];
                self.pageMaker = [pageInfo longValueForKey:@"pageMarker" default:0];
                if (data.count<10) {
                    [self showNoMoreDataFooter];
                }
            }else{
                [self showNoDataImage];
            }
        }
        [self.header endRefreshing];
        [SVProgressHUD dismiss];

    } failBlock:^(NSError *error) {
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [SVProgressHUD dismiss];
        if(self.dataSource.count == 0){
            [self showNoNetWorkView];
        }
    }];
}
- (void)headerRereshing{
    self.dataSource = [NSMutableArray new];
    self.pageMaker = 0;
    [self showLoadFooterView];
    [self loadTeamNeedData];
}
-(void)footerRereshing{
    if (self.pageMaker == 0) {
        [self loadTeamNeedData];

    }else{
    [self loadMoreDate];
    }
}
- (void)loadMoreDate{
    NSDictionary *params =@{@"_withLatestIssueLog":@YES,@"orderBy":@"seq",@"_latestIssueLogLimit":@1,@"orderMethod":@"desc",@"pageSize":@10,@"ticketType":@"serviceEvent",@"pageMarker":[NSNumber numberWithInteger:self.pageMaker]};
    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *pageInfo = response[@"content"][@"pageInfo"];
            NSArray *data = response[@"content"][@"data"];
            if (data.count>0) {
                [self dealWithData:data];
                self.pageMaker = [pageInfo longValueForKey:@"pageMarker" default:0];
                if (data.count<10) {
                    [self showNoMoreDataFooter];
                }
            }else{
                if (self.dataSource.count == 0) {
                    [self showNoDataImage];
                }
                self.tableView.tableFooterView = self.footView;
                self.footer.hidden = YES;
            }
        }
        [self.footer endRefreshing];
        [self.header endRefreshing];
    } failBlock:^(NSError *error) {
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
    }];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)dealWithData:(NSArray *)data{
    if (data>0) {
        [data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            MonitorListModel *model = [[MonitorListModel alloc]initWithDictionary:dict];
            [self.dataSource addObject:model];
        }];
        [self.tableView reloadData];
    }else{
        if (self.dataSource.count == 0) {
            [self showNoDataImage];
        }
    }
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
    cell.isService = YES;
    cell.model = self.dataSource[indexPath.row];
    cell.backgroundColor = PWWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorListModel *model =self.dataSource[indexPath.row];
     model.isRead = YES;
    if (model.isFromUser) {
        ProblemDetailsVC *detailVC = [[ProblemDetailsVC alloc]init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        InfoDetailVC *infodetial = [[InfoDetailVC alloc]init];
        infodetial.model = model;
        [self.navigationController pushViewController:infodetial animated:YES];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorListModel *model =self.dataSource[indexPath.row];
    if (model.cellHeight == 0 || !model.cellHeight) {
        CGFloat cellHeight = [self.tempCell heightForModel:self.dataSource[indexPath.row]];
        // 缓存给model
        model.cellHeight = cellHeight;
        
        return cellHeight;
    } else {
        return model.cellHeight;
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
