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
#import "NSString+ErrorCode.h"
#import "FavoritesListModel.h"
#define DeletBtnTag 200

@interface MineCollectionVC ()<UITableViewDelegate, UITableViewDataSource,MGSwipeTableCellDelegate>
@property (nonatomic, strong) NSMutableArray<NewsListModel *> *dataSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NewsListCell *tempCell;

@end

@implementation MineCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.MineCollection", @"");
    [self createUI];
    self.page = 1;
    self.dataSource = [NSMutableArray new];
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
    [SVProgressHUD show];
    NSDictionary *param = @{@"pageSize":@10,@"pageIndex":[NSNumber numberWithInteger:self.page]};
    [[PWHttpEngine sharedInstance] getFavoritesListWithParam:param callBack:^(id response) {
        FavoritesListModel *model = response;
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
        if(model.isSuccess){
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }
            if (model.list.count == 0 && self.dataSource.count == 0) {
                [self showNoDataImage];
            }else{
                [self.dataSource addObjectsFromArray:model.list];
                [self.tableView reloadData];
                if (model.list.count < 10) {
                   [self showNoMoreDataFooter];
                }
            }
        }else{
            if(self.dataSource.count == 0){
                [self showNoNetWorkView];
            }
        }
    }];
}
- (void)headerRefreshing{
    self.page = 1;
    [self showLoadFooterView];
    [self loadData];
}
-(void)footerRefreshing{
    self.page ++;
    [self loadData];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListModel *model = self.dataSource[indexPath.row];
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"local.delete", @"") icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"] padding:10 callback:^BOOL(MGSwipeTableCell *_Nonnull cell) {
        [self deleteCollection:indexPath.row];
        return NO;
    }];
    button.titleLabel.font = RegularFONT(14);
    [button centerIconOverTextWithSpacing:5];
    if (model.type == NewListCellTypText) {
        NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell"];
        cell.model = self.dataSource[indexPath.row];
        [cell layoutIfNeeded];
        cell.rightButtons = @[button];
        cell.delegate = self;
        return cell;
    } else {
        NewsListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListImageCell"];
        cell.model = self.dataSource[indexPath.row];
        [cell layoutIfNeeded];
        cell.rightButtons = @[button];
        cell.delegate = self;
        return cell;
    }
}
- (void)deleteCollection:(NSInteger)index{
    NewsListModel *newsModel = self.dataSource[index];
    [SVProgressHUD show];
    [[PWHttpEngine sharedInstance] deleteFavoritesWithFavoID:newsModel.favoID callBack:^(id response) {
        BaseReturnModel *model = response;
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
        [self.footer endRefreshing];
        if (model.isSuccess) {
            self.page = 1;
            [self loadData];
            [[[[ZhugeIOMineHelper new] eventDeleteCollection]
              attrMessageTitle:newsModel.title.length>0?newsModel.title:@""]track];
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
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
                [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
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
                [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
