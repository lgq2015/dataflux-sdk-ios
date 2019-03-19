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
#import "NewsWebView.h"
#import "PWFMDB.h"
#import "IssueSourceManger.h"

@interface InformationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *infoDatas;
@property (nonatomic, strong) NSDictionary *infoSourceDatas;
@property (nonatomic, strong) PWInfoBoard *infoboard;
@property (nonatomic, strong) HomeNoticeScrollView *notice;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) PWInfoBoardStyle infoBoardStyle;

@property (nonatomic, assign) NSInteger  newsPage;
@property (nonatomic, strong) NSMutableArray<NewsListModel *> *newsDatas;
@property (nonatomic, strong) PWNewsListCell *tempCell;
@end

@implementation InformationVC
-(void)viewWillAppear:(BOOL)animated{
    [[IssueSourceManger sharedIssueSourceManger] getLastDetectionTime:^(NSString * _Nonnull str) {
        if (_infoboard) {
            [self.infoboard updateTitle:str];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    self.newsPage = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(infoBoardDatasUpdate)
                                                 name:KNotificationInfoBoardDatasUpdate
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(infoBoardStyleUpdate)
                                                 name:KNotificationIssueSourceChange
                                               object:nil];
    [self dealNewsDatas];
    [self judgeIssueConnectState];
    [self loadTipsData];
    
}
- (void)judgeIssueConnectState{
    BOOL  ishideguide = getIsHideGuide;
    BOOL  isconnect = getConnectState;
    if (ishideguide || isconnect) {
        self.infoBoardStyle = PWInfoBoardStyleConnected;
        [[IssueListManger sharedIssueListManger] downLoadAllIssueList];
        [self createUI];
    }else{
        [[IssueListManger sharedIssueListManger] judgeIssueConnectState:^(BOOL isConnect) {
            self.infoBoardStyle = isConnect?PWInfoBoardStyleConnected:PWInfoBoardStyleNotConnected;
            if (isConnect) {
                [[IssueListManger sharedIssueListManger] downLoadAllIssueList];
            }
            [self createUI];
        }];
    }
}
- (void)createUI{
    CGFloat headerHeight = self.infoBoardStyle == PWInfoBoardStyleConnected?ZOOM_SCALE(524):ZOOM_SCALE(690);
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
    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(NSString * _Nonnull str) {
        [self.infoboard updateTitle:str];
    }];
   
    self.infoboard.itemClick = ^(NSInteger index){
        NSArray *dataSource;
         NSString *title;
         NSString *issueType;
        switch (index) {
            case 0:
                dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"alarm"];
                title = @"监控";
                issueType = @"alarm";
                break;
            case 1:
                dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"security"];
                title = @"安全";
                issueType = @"security";
                break;
            case 2:
                 dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"expense"];
                title = @"费用";
                issueType = @"expense";
                break;
            case 3:
                dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"optimization"];
                title = @"优化";
                issueType = @"optimization";
                break;
            case 4:
                dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"misc"];
                title = @"提醒";
                issueType = @"misc";
                break;
            default:
                dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:@"misc"];
                title = @"提醒";
                issueType = @"misc";
                break;
        }
        MonitorVC *monitor = [[MonitorVC alloc]initWithTitle:title andIssueType:issueType];
        monitor.dataSource = [[NSMutableArray alloc]initWithArray:dataSource];
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
    self.tableView.estimatedRowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.tableView registerClass:[PWNewsListCell class] forCellReuseIdentifier:@"PWNewsListCell"];
    self.tempCell = [[PWNewsListCell alloc] initWithStyle:0 reuseIdentifier:@"PWNewsListCell"];
    [self.view addSubview:self.tableView];

}
-(void)infoBoardStyleUpdate{
    if (self.infoBoardStyle == PWInfoBoardStyleNotConnected ) {
        [[IssueListManger sharedIssueListManger] downLoadAllIssueList];
        NSArray *array = [IssueListManger sharedIssueListManger].infoDatas;
        [self.infoboard updataInfoBoardStyle:PWInfoBoardStyleConnected itemData:@{@"datas":array}];
        self.headerView.frame =CGRectMake(0, 0, kWidth, ZOOM_SCALE(524));
        self.infoboard.frame = CGRectMake(0, 0, kWidth, ZOOM_SCALE(436));
        self.tableView.tableHeaderView = self.headerView;
    }
}
-(void)infoBoardDatasUpdate{
    NSArray *array = [[IssueListManger sharedIssueListManger] getInfoBoardData];
    if (array.count>0) {
        [self.infoboard updataDatas:@{@"datas":array}];
    }
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
- (void)loadTipsData{
    [PWNetworking requsetWithUrl:PW_TIPS withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        NSArray *array = response;
        NSDictionary *dict = array[0];
        [self.notice createUIWithTitleArray:@[dict[@"title"]]];
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)headerRereshing{
    self.newsPage = 1;
    self.newsDatas = [NSMutableArray new];
    [self showLoadFooterView];
    [[IssueListManger sharedIssueListManger] newIssueNeedUpdate];
    [self loadRecommendationData];
    [self loadNewsDatas];
}
-(void)footerRereshing{
    [self loadNewsDatas];
}
- (void)dealNewsDatas{
    self.newsDatas = [NSMutableArray new];
    [self loadRecommendationData];
    [self loadNewsDatas];
}
- (void)loadRecommendationData{
    [PWNetworking requsetWithUrl:PW_recommendation withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *datas = response[@"content"];
            if (datas.count>0) {
                [self RecommendationDatas:datas];
            }
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {

    }];
}
- (void)loadNewsDatas{
    NSDictionary *param = @{@"page":[NSNumber numberWithInteger:self.newsPage],@"pageSize":@10,@"isStarred":@YES};
    [PWNetworking requsetWithUrl:PW_newsList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errorCode"] isEqualToString:@""]) {
            NSDictionary *data=response[@"data"];
            NSArray *items = data[@"items"];
            if (items.count>0) {
                [self dealNewsDataWithData:items andTotalPage:[data[@"totalPages"] integerValue]];
            }
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
        [self.header endRefreshing];
    } failBlock:^(NSError *error) {
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
- (void)RecommendationDatas:(NSArray *)array{
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NewsListModel *model = [[NewsListModel alloc]initWithStickJsonDictionary:dict];
        [self.newsDatas insertObject:model atIndex:0];
    }];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}
- (void)dealNewsDataWithData:(NSArray *)items andTotalPage:(NSInteger)page{
    
    [items enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NewsListModel *model = [[NewsListModel alloc]initWithJsonDictionary:dict];
        [self.newsDatas addObject:model];
    }];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];

    if (page == self.newsPage) {
        [self showNoMoreDataFooter];
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
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model = self.newsDatas[indexPath.row];
    NewsWebView *newsweb = [[NewsWebView alloc]initWithTitle:model.title andURLString:model.url];
    newsweb.style = model.isStarred?WebItemViewStyleNoShare:WebItemViewStyleNormal;
    newsweb.newsModel = model;
    [self.navigationController pushViewController:newsweb animated:YES];
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
