//
//  HandBookArticleVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HandBookArticleVC.h"
#import "HandbookCell.h"
#import "NewsWebView.h"
#import "ZTHandBookNoPicCell.h"
#import "ZTHandBookHasPicCell.h"
#import "UITableViewCell+ZTCategory.h"
#define seperatorLineH 4.0
@interface HandBookArticleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation HandBookArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    [self createUI];
    [self loadData];
}
- (void)createUI{
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.view addSubview:self.tableView];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, Interval(12))];
    header.backgroundColor = PWBackgroundColor;
    self.tableView.tableHeaderView = header;
    [self.tableView registerNib:[ZTHandBookNoPicCell cellWithNib] forCellReuseIdentifier:[ZTHandBookNoPicCell cellReuseIdentifier]];
    [self.tableView registerNib:[ZTHandBookHasPicCell cellWithNib] forCellReuseIdentifier:[ZTHandBookHasPicCell cellReuseIdentifier]];

}
- (void)loadData{
    self.dataSource = [NSMutableArray new];
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_handbook(self.model.handbookId) withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count>0) {
                [self.dataSource addObjectsFromArray:content];
                [self.tableView reloadData];
                [self showNoMoreDataFooter];
            }else{
                [self showNoDataImage];
            }
        }
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.row] error:&error];
    if ([model.imageUrl isEqualToString:@""]) {
        ZTHandBookNoPicCell *cell = (ZTHandBookNoPicCell *)[tableView dequeueReusableCellWithIdentifier:[ZTHandBookNoPicCell cellReuseIdentifier]];
        cell.isSearch = NO;
        cell.model = model;
        return cell;
    }else{
        ZTHandBookHasPicCell *cell = (ZTHandBookHasPicCell *)[tableView dequeueReusableCellWithIdentifier:[ZTHandBookHasPicCell cellReuseIdentifier]];
        cell.isSearch = NO;
        cell.model = model;
        return cell;
    }
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.row] error:&error];
    DLog(@"%@",PW_handbookUrl(model.articleId));
    NewsWebView *webview = [[NewsWebView alloc]initWithTitle:model.title andURLString:PW_handbookUrl(model.articleId)];
    webview.handbookModel = model;
    [self.navigationController pushViewController:webview animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.row] error:&error];
    CGFloat height = 0.0;
    if ([model.imageUrl isEqualToString:@""]) {
        ZTHandBookNoPicCell *cell = (ZTHandBookNoPicCell *)[tableView dequeueReusableCellWithIdentifier:[ZTHandBookNoPicCell cellReuseIdentifier]];
        cell.isSearch = NO;
        height = [cell caculateRowHeight:model];
    }else{
        ZTHandBookHasPicCell *cell = (ZTHandBookHasPicCell *)[tableView dequeueReusableCellWithIdentifier:[ZTHandBookHasPicCell cellReuseIdentifier]];
        cell.isSearch = NO;
        height = [cell caculateRowHeight:model];
    }
    return height + seperatorLineH;
}

@end
