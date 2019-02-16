//
//  InformationVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "InformationVC.h"
#import "PWInfoBoard.h"
#import "HomeNoticeScrollView.h"
#import "PWNewsListCell.h"
#import "MonitorVC.h"
#import "InformationSourceVC.h"
#import "AddSourceVC.h"
#import "UserManager.h"
#import "IssueListManger.h"
@interface InformationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<NewsListModel *> *newsDatas;
@property (nonatomic, strong) NSMutableArray *infoDatas;
@property (nonatomic, strong) NSDictionary *infoSourceDatas;
@property (nonatomic, strong) PWInfoBoard *infoboard;
@property (nonatomic, strong) HomeNoticeScrollView *notice;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) PWInfoBoardStyle infoBoardStyle;
@property (nonatomic, assign) NSInteger  newsPage;
@property (nonatomic, strong) PWNewsListCell *tempCell;
@end

@implementation InformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
        self.tableView.mj_header = self.header;
        self.tableView.mj_footer = self.footer;
        self.newsPage = 1;
        [self loadIssueData];
        [self loadNewsDatas];
}
- (void)createUI{
    CGFloat headerHeight = self.infoBoardStyle == PWInfoBoardStyleConnected?ZOOM_SCALE(534):ZOOM_SCALE(690);
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, headerHeight)];
    [self.headerView addSubview:self.infoboard];
    [self.headerView addSubview:self.notice];
    NSArray *array = [[IssueListManger sharedIssueListManger] getInfoBoardData];
    self.infoDatas = [[NSMutableArray alloc]initWithArray:array];
    [self.infoboard createUIWithParamsDict:@{@"datas":self.infoDatas}];
    __weak typeof(self) weakSelf = self;
    self.infoboard.historyInfoClick = ^(void){
        InformationSourceVC *infosourceVC = [[InformationSourceVC alloc]init];
        [weakSelf.navigationController pushViewController:infosourceVC animated:YES];
    };
    self.infoboard.itemClick = ^(NSInteger index){
         MonitorVC *monitor = [[MonitorVC alloc]init];
        switch (index) {
            case 0:
                monitor.dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"misc"];
                break;
            case 1:
               monitor.dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"security"];
                break;
            case 2:
                 monitor.dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"expense"];
                break;
            case 3:
                monitor.dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"optimization"];
                break;
            case 4:
                monitor.dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"alarm"];
                break;
        }
        [weakSelf.navigationController pushViewController:monitor animated:YES];
    };
   
    self.infoboard.connectClick = ^(){
        AddSourceVC *addVC = [[AddSourceVC alloc]init];
        [weakSelf.navigationController pushViewController:addVC animated:YES];
    };
    [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoboard.mas_bottom).offset(Interval(10));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(60));
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-kTopHeight-16);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[PWNewsListCell class] forCellReuseIdentifier:@"PWNewsListCell"];
    self.tempCell = [[PWNewsListCell alloc] initWithStyle:0 reuseIdentifier:@"PWNewsListCell"];
    [self.view addSubview:self.tableView];
}
-(PWInfoBoard *)infoboard{
    if (!_infoboard) {
        CGFloat height = self.infoBoardStyle == PWInfoBoardStyleConnected? ZOOM_SCALE(440):ZOOM_SCALE(600);
        _infoboard = [[PWInfoBoard alloc]initWithFrame:CGRectMake(0, 0, kWidth, height) style:self.infoBoardStyle]; // type从用户信息里提前获取
    }
    return _infoboard;
}
-(HomeNoticeScrollView *)notice{
    if (!_notice) {
       _notice = [[HomeNoticeScrollView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(400), kWidth, ZOOM_SCALE(60))];
       _notice.backgroundColor = PWWhiteColor;
    }
    return _notice;
}
- (void)headerRereshing{
    self.newsPage = 1;
    [self loadNewsDatas];
}
-(void)footerRereshing{
    [self loadNewsDatas];
}
- (void)loadIssueData{
    
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        DLog(@"%@",response);
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *dict = response[@"content"];
            NSArray *data = dict[@"data"];
            if (data.count>0) {
                self.infoBoardStyle = PWInfoBoardStyleConnected;
            }else{
                self.infoBoardStyle = PWInfoBoardStyleNotConnected;
            }
            [self createUI];
            self.infoSourceDatas = response;
        }else if([response[@"errCode"] isEqualToString:@"home.auth.unauthorized"]){
            KPostNotification(KNotificationLoginStateChange, @NO);
        }
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
}
- (void)loadNewsDatas{
    NSDictionary *param = @{@"page":[NSNumber numberWithInteger:self.newsPage],@"pageSize":@10};
    [PWNetworking requsetWithUrl:PW_newsList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *data=response[@"data"];
            NSArray *items = data[@"items"];
            if (items.count>0) {
                [self dealNewsDataWithData:items andTotalPage:[data[@"totalPages"] integerValue]];
            }
        }
        [self.header endRefreshing];
    } failBlock:^(NSError *error) {
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
- (void)dealNewsDataWithData:(NSArray *)items andTotalPage:(NSInteger)page{
    if (self.newsPage == 1) {
        self.newsDatas = [NSMutableArray new];
    }
    [items enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        NewsListModel *model = [[NewsListModel alloc]initWithDictionary:dict error:&error];
        [self.newsDatas addObject:model];
    }];
    [self.tableView reloadData];
   
    if (page == self.newsPage) {
        self.footer.state = MJRefreshStateNoMoreData;
        self.tableView.mj_footer.state= MJRefreshStateNoMoreData;
    }else{
        [self.footer endRefreshing];
    }
    if (page>self.newsPage) {
        self.newsPage++;
    }
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PWNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PWNewsListCell"];
    if (!cell) {
      cell = [[PWNewsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PWNewsListCell"];
    }
    cell.model = self.newsDatas[indexPath.row];
    [cell layoutIfNeeded];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model =self.newsDatas[indexPath.row];
    if (model.cellHeight == 0 || !model.cellHeight) {
        CGFloat cellHeight = [self.tempCell heightForModel:self.newsDatas[indexPath.row]];
        // 缓存给model
        model.cellHeight = cellHeight;
        
        return cellHeight;
    } else {
        return model.cellHeight;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
