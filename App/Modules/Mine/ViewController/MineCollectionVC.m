//
//  MineCollectionVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MineCollectionVC.h"
#import "NewsListModel.h"
#import "NewsWebView.h"
#import "PWNewsListCell.h"

#define DeletBtnTag 200

@interface MineCollectionVC ()<UITableViewDelegate, UITableViewDataSource,MGSwipeTableCellDelegate>
@property (nonatomic, strong) NSMutableArray<NewsListModel *> *dataSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) PWNewsListCell *tempCell;

@end

@implementation MineCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self createUI];
    [self loadData];
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.estimatedRowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.tableView registerClass:[PWNewsListCell class] forCellReuseIdentifier:@"PWNewsListCell"];
    self.tempCell = [[PWNewsListCell alloc] initWithStyle:0 reuseIdentifier:@"PWNewsListCell"];
    [self.view addSubview:self.tableView];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, Interval(12))];
    header.backgroundColor = PWBackgroundColor;
    self.tableView.tableHeaderView = header;
}
- (void)loadData{
    self.page = 1;
    self.dataSource = [NSMutableArray new];
    [SVProgressHUD show];
    NSDictionary *param = @{@"pageSize":@10,@"pageIndex":[NSNumber numberWithInteger:self.page]};
    [PWNetworking requsetHasTokenWithUrl:PW_favoritesList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *data = response[@"content"][@"data"];
            if (data.count == 0) {
                [self showNoDataImage];
            }else if(data.count<10){
                [self showNoMoreDataFooter];
                 [self dealWithData:data];
            }else{
                [self dealWithData:data];
                self.page ++;
            }
        }
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
- (void)loadMoreData{
    NSDictionary *param = @{@"pageSize":@10,@"pageIndex":[NSNumber numberWithInteger:self.page]};
    [PWNetworking requsetHasTokenWithUrl:PW_favoritesList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *data = response[@"content"][@"data"];
            if(data.count<10){
                [self showNoMoreDataFooter];
            }else{
                [self dealWithData:data];
                self.page ++;
            }
        }
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
- (void)dealWithData:(NSArray *)data{
    [data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NewsListModel *model = [[NewsListModel alloc]initWithCollectionDictionary:dict];
        [self.dataSource addObject:model];
    }];
    [self.tableView reloadData];

}
- (void)headerRereshing{
    self.page = 1;
    [self showLoadFooterView];
    [self loadData];
}
-(void)footerRereshing{
    
    [self loadMoreData];
    
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ PWNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PWNewsListCell"];
    if (!cell) {
        cell = [[PWNewsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PWNewsListCell"];
    }
    cell.model = self.dataSource[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"]padding:10 callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [self delectCollection:indexPath.row];
        return NO;
    }];
    button.titleLabel.font = MediumFONT(14);
   
    [button centerIconOverTextWithSpacing:5];
    cell.rightButtons = @[button];
    cell.delegate = self;
    return cell;
    
}
- (void)delectCollection:(NSInteger)index{
    NewsListModel *model = self.dataSource[index];
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_favoritesDelete(model.favoID) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];

        if([response[ERROR_CODE] isEqualToString:@""]){
            [self loadData];
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
    
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model = self.dataSource[indexPath.row];
    NewsWebView *newsweb = [[NewsWebView alloc]initWithTitle:model.title andURLString:model.url];
    newsweb.newsModel = model;
    newsweb.style = WebItemViewStyleNoShare;
    [self.navigationController pushViewController:newsweb animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model =self.dataSource[indexPath.row];
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
