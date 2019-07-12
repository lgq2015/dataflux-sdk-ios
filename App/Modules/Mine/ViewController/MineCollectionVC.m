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
#import "NewsListCell.h"
#import "NewsListImageCell.h"
#import "ZhugeIOMineHelper.h"

#define DeletBtnTag 200

@interface MineCollectionVC ()<UITableViewDelegate, UITableViewDataSource,MGSwipeTableCellDelegate>
@property (nonatomic, strong) NSMutableArray<NewsListModel *> *dataSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NewsListCell *tempCell;

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
    [self.tableView registerClass:[NewsListCell class] forCellReuseIdentifier:@"NewsListCell"];
    self.tempCell = [[NewsListCell alloc] initWithStyle:0 reuseIdentifier:@"NewsListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[NewsListImageCell class] forCellReuseIdentifier:@"NewsListImageCell"];
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
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            //content 内容为nil,安全处理
            NSDictionary *contentDic = PWSafeDictionaryVal(response, @"content");
            if (!contentDic){
                [self showNoDataImage];
                [self.header endRefreshing];
                [self.footer endRefreshing];
                return ;
            }
            //data 内容为nil,安全处理
            NSArray *data = PWSafeArrayVal(contentDic, @"data");
            if (!data){
                [self showNoDataImage];
                [self.header endRefreshing];
                [self.footer endRefreshing];
                return ;
            }
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
- (void)loadMoreData{
    NSDictionary *param = @{@"pageSize":@10,@"pageIndex":[NSNumber numberWithInteger:self.page]};
    [PWNetworking requsetHasTokenWithUrl:PW_favoritesList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *data = response[@"content"][@"data"];
            if(data.count<10){
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
- (void)dealWithData:(NSArray *)data{
    [data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NewsListModel *model = [[NewsListModel alloc]initWithCollectionDictionary:dict];
        [self.dataSource addObject:model];
    }];
    [self.tableView reloadData];

}
- (void)headerRefreshing{
    self.page = 1;
    [self showLoadFooterView];
    [self loadData];
}
-(void)footerRefreshing{
    
    [self loadMoreData];
    
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   UITableViewCell *cell;
    NewsListModel *model = self.dataSource[indexPath.row];
    if (model.type == NewListCellTypText) {
        NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell"];
        cell.model = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell layoutIfNeeded];
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"] padding:10 callback:^BOOL(MGSwipeTableCell *_Nonnull cell) {
            [self deleteCollection:indexPath.row];
            return NO;
        }];
        button.titleLabel.font = RegularFONT(14);

        [button centerIconOverTextWithSpacing:5];
        cell.rightButtons = @[button];
        cell.delegate = self;
        return cell;
    } else {
        NewsListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListImageCell"];
        cell.model = self.dataSource[indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell layoutIfNeeded];
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"] padding:10 callback:^BOOL(MGSwipeTableCell *_Nonnull cell) {
            [self deleteCollection:indexPath.row];
            return NO;
        }];
        button.titleLabel.font = RegularFONT(14);

        [button centerIconOverTextWithSpacing:5];
        cell.rightButtons = @[button];
        cell.delegate = self;
        return cell;
    }
   

    
}
- (void)deleteCollection:(NSInteger)index{
    NewsListModel *model = self.dataSource[index];
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_favoritesDelete(model.favoID) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];

        if([response[ERROR_CODE] isEqualToString:@""]){
            [self loadData];
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [[[[ZhugeIOMineHelper new] eventDeleteCollection]
                attrMessageTitle:model.title.length>0?model.title:@""]track];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
    
}
- (void)recollectWithModel:(NewsListModel*)model{
    NSMutableDictionary *param = [@{@"id":model.newsID} mutableCopy];
    if ([model.sourceType isEqualToString:@"handbook"]) {
        [SVProgressHUD show];
        [PWNetworking requsetHasTokenWithUrl:PW_handbookdetail withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                if ([model.imageUrl isEqualToString:@""]) {
                    
                }
                PWBaseWebVC *newsweb = [[PWBaseWebVC alloc]initWithTitle:model.title andURLString:model.url];
                [self.navigationController pushViewController:newsweb animated:YES];
            }else{
                [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [error errorToast];
        }];
    }else if ([model.sourceType isEqualToString:@"forum"]) {
        [SVProgressHUD show];
        param[@"noUserView"] = @YES;
        [PWNetworking requsetHasTokenWithUrl:PW_articelForumclick(model.newsID) withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                PWBaseWebVC *newsweb = [[PWBaseWebVC alloc]initWithTitle:model.title andURLString:model.url];
                [self.navigationController pushViewController:newsweb animated:YES];
            }else{
                [iToast alertWithTitleCenter:NSLocalizedString(@"home.hdbk.articleNotExists", @"")];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [error errorToast];
        }];
    }
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model = self.dataSource[indexPath.row];
    [self recollectWithModel:model];
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
