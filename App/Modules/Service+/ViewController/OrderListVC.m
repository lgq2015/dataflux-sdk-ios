//
//  OrderListVC.m
//  App
//
//  Created by tao on 2019/4/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "OrderListVC.h"
#import "UITableViewCell+ZTCategory.h"
#import "ZTOrderListCell.h"
#import "ZTOrderListExceptNotPayStatusCell.h"
@interface OrderListVC ()<UITableViewDelegate, UITableViewDataSource,ZTOrderListCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.title = @"订单列表";
    self.dataSource = [NSMutableArray new];
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[ZTOrderListCell cellWithNib] forCellReuseIdentifier:[ZTOrderListCell cellReuseIdentifier]];
    [self.tableView registerNib:[ZTOrderListExceptNotPayStatusCell cellWithNib] forCellReuseIdentifier:[ZTOrderListExceptNotPayStatusCell cellReuseIdentifier]];
}

#pragma mark ===网络请求=====
- (void)loadData{
    self.pageNum = 1;
    self.dataSource = [NSMutableArray new];
    [SVProgressHUD show];
    NSDictionary *param = @{@"pageSize":@10,@"pageIndex":[NSNumber numberWithInteger:self.pageNum]};
    [PWNetworking requsetHasTokenWithUrl:PW_favoritesList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *data = response[@"content"][@"data"];
            if (data.count == 0) {
                [self showNoDataImage];
            }else if(data.count<10){
                [self showNoMoreDataFooter];
                [self dealWithData:data];
            }else{
                [self dealWithData:data];
                self.pageNum ++;
            }
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
        if(self.dataSource.count == 0){
            [self showNoNetWorkView];
        }
    }];
}
-(void)loadMoreData{
    NSDictionary *param = @{@"pageSize":@10,@"pageIndex":[NSNumber numberWithInteger:self.pageNum]};
    [PWNetworking requsetHasTokenWithUrl:PW_systemMessageList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *data = response[@"content"][@"data"];
            if (data.count>0) {
                [self dealWithData:data];
                if (data.count<10) {
                    [self showNoMoreDataFooter];
                }else{
                    self.pageNum++;
                }
            }else{
                [self showNoMoreDataFooter];
            }
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
    } failBlock:^(NSError *error) {
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
    }];
}
- (void)dealWithData:(NSArray *)data{
//    [data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
//        NewsListModel *model = [[NewsListModel alloc]initWithCollectionDictionary:dict];
//        [self.dataSource addObject:model];
//    }];
    [self.tableView reloadData];
}
#pragma mark ===刷新、加载======
- (void)headerRefreshing{
    [self showLoadFooterView];
    [self loadData];
}
-(void)footerRefreshing{
    [self loadMoreData];
}
#pragma mark ========== UITableViewDataSource ==========
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    FounctionIntroductionModel *model = self.dataArr[indexPath.row];
    if (indexPath.row %2 == 0){
        ZTOrderListCell *cell = (ZTOrderListCell *)[tableView dequeueReusableCellWithIdentifier:[ZTOrderListCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return  cell;
    }else{
        ZTOrderListExceptNotPayStatusCell *cell = (ZTOrderListExceptNotPayStatusCell *)[tableView dequeueReusableCellWithIdentifier:[ZTOrderListExceptNotPayStatusCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    FounctionIntroductionModel *model = self.dataArr[indexPath.row];
    if (indexPath.row %2 == 0){
        ZTOrderListCell *cell = (ZTOrderListCell *)[tableView dequeueReusableCellWithIdentifier:[ZTOrderListCell cellReuseIdentifier]];
        CGFloat height = [cell caculateRowHeight:nil];
        return height;
    }else{
        ZTOrderListExceptNotPayStatusCell *cell = (ZTOrderListExceptNotPayStatusCell *)[tableView dequeueReusableCellWithIdentifier:[ZTOrderListExceptNotPayStatusCell cellReuseIdentifier]];
        CGFloat height = [cell caculateRowHeight:nil];
        return height;
    }
    
}

#pragma mark ========== ZTOrderListCellDelegate ==========
- (void)didClickCancelOrder:(ZTOrderListCell *)cell{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    DLog(@"点击取消----%ld",indexpath.row);
}
- (void)didClickPayOrder:(ZTOrderListCell *)cell{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    DLog(@"点击确定----%ld",indexpath.row);
}

@end
