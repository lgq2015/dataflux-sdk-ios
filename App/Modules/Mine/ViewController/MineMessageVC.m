//
//  MineMessageVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MineMessageVC.h"
#import "MineMessageCell.h"
#import "MineMessageModel.h"
#import "MessageDetailVC.h"
#import "PWBaseWebVC.h"
@interface MineMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MineMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    [self createUI];
    [self loadData];
}
-(void)createUI{
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.rowHeight = Interval(32)+ZOOM_SCALE(49);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.tableView registerClass:[MineMessageCell class] forCellReuseIdentifier:@"MineMessageCell"];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, Interval(12))];
    header.backgroundColor = PWBackgroundColor;
    self.tableView.tableHeaderView = header;
}
-(void)loadData{
    [SVProgressHUD show];
    self.dataSource = [NSMutableArray new];
    self.pageIndex = 1;
    NSDictionary *param = @{@"pageSize":@20,@"pageIndex":@1};
    [PWNetworking requsetHasTokenWithUrl:PW_systemMessageList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *data = response[@"content"][@"data"];
            if (data.count>0) {
                [self.dataSource addObjectsFromArray:data];
                [self.tableView reloadData];
                self.pageIndex++;
                if (data.count<10) {
                    [self showNoMoreDataFooter];
                }
            }else{
                [self showNoDataImage];
            }
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
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
-(void)loadMoreData{
    NSDictionary *param = @{@"pageSize":@20,@"pageIndex":[NSNumber numberWithInteger:self.pageIndex]};
    [PWNetworking requsetHasTokenWithUrl:PW_systemMessageList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            self.pageIndex++;
            NSArray *data = response[@"content"][@"data"];
            if (data.count>0) {
                [self.dataSource addObjectsFromArray:data];
                [self.tableView reloadData];
                if (data.count<10) {
                    [self showNoMoreDataFooter];
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
- (void)headerRefreshing{
    self.dataSource = [NSMutableArray new];
    self.pageIndex = 1;
    [self showLoadFooterView];
    [self loadData];
}
-(void)footerRefreshing{
    
   [self loadMoreData];
    
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineMessageCell"];
    NSDictionary *dict = self.dataSource[indexPath.row];
    MineMessageModel *model = [MineMessageModel new];
    [model setLocalValueWithDict:dict];
    cell.model = model;
    return cell;
}

#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    MineMessageModel *model = [MineMessageModel new];
    [model setLocalValueWithDict:dict];
    if (!([model.uri isEqualToString:@""]|| model.uri == nil)) {
        PWBaseWebVC *web = [[PWBaseWebVC alloc]initWithTitle:model.title andURLString:model.uri];
        [self.navigationController pushViewController:web animated:YES];
        [self setMessageRead:model];
    }else{
    MessageDetailVC *detail = [[MessageDetailVC alloc]init];
   
    detail.model = model;
    detail.refreshTable =^(){
        [self loadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
    }
}
- (void)setMessageRead:(MineMessageModel *)model{
    NSDictionary *param = @{@"data":@{@"system_message_ids":model.messageID}};
    [PWNetworking requsetHasTokenWithUrl:PW_systemMessageSetRead withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            [self loadData];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
@end
