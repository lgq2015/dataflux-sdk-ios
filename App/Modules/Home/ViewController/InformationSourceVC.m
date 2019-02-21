//
//  InformationSourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InformationSourceVC.h"
#import "InformationSourceCell.h"
#import "AddSourceVC.h"
#import "SourceVC.h"
@interface InformationSourceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger  currentPage;

@end

@implementation InformationSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报源";
    [self createUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(headerRereshing)
                                                 name:KNotificationIssueSourceChange
                                               object:nil];
}
- (void)createUI{
    NSArray *title = @[@"添加"];
    self.currentPage = 1;
    [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
    self.dataSource = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_footer = self.footer;
    self.tableView.mj_header = self.header;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.rowHeight = 100.f;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[InformationSourceCell class] forCellReuseIdentifier:@"InformationSourceCell"];
}
- (void)loadData{
    NSDictionary *param = @{@"pageNumber":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@10};
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            if (data.count>0) {
                if (self.currentPage == 1) {
                    self.dataSource = [NSMutableArray arrayWithArray:data];
                }else{
                    [self.dataSource addObjectsFromArray:data];
                }
                [self.tableView reloadData];
                if ([content[@"pageInfo"][@"pageCount"] integerValue]>self.currentPage) {
                    self.currentPage++;
                    [self.footer endRefreshing];
                }else{
                    self.footer.state = MJRefreshStateNoMoreData;
                }
            }
        }else if([response[@"errCode"] isEqualToString:@"home.auth.unauthorized"]){
        }
        [self.header endRefreshing];
    } failBlock:^(NSError *error) {
        [self.header endRefreshing];
    }];
}
-(void)headerRereshing{
    self.currentPage = 1;
    [self loadData];
}
-(void)footerRereshing{
    [self loadData];
}
- (void)addInfoSource{
    AddSourceVC *addVC = [[AddSourceVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationSourceCell"];
    
    cell.model = [[PWInfoSourceModel alloc]initWithJsonDictionary:self.dataSource[indexPath.row]];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    InformationSourceCell *cell = (InformationSourceCell *)[tableView cellForRowAtIndexPath:indexPath];
    SourceVC *source = [[SourceVC alloc]init];
    source.model = cell.model;
    source.isAdd = NO;
    [self.navigationController pushViewController:source animated:YES];
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
