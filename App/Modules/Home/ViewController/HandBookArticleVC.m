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
    self.tableView.rowHeight = ZOOM_SCALE(46)+Interval(82);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.tableView registerClass:[HandbookCell class] forCellReuseIdentifier:@"HandbookCell"];
    [self.view addSubview:self.tableView];
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
    HandbookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HandbookCell"];
        NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.row] error:&error];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
