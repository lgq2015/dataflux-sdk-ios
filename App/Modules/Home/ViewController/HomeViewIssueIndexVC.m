//
//  HomeViewIssueIndexVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "HomeViewIssueIndexVC.h"
#import "IssueBoard.h"
#import "HomeNoticeScrollView.h"
#import "NewsListCell.h"
#import "IssueListVC.h"
#import "IssueSourceListVC.h"
#import "AddSourceVC.h"
#import "UserManager.h"
#import "IssueListManger.h"
#import "NewsWebView.h"
#import "PWFMDB.h"
#import "IssueSourceManger.h"
#import "InformationStatusReadManager.h"
#import "NewsListImageCell.h"
#import "TeamInfoModel.h"
#import "PWHttpEngine.h"
#import "MineMessageModel.h"
#import "MessageDetailVC.h"
#import "IssueModel.h"
#import "IssueDetailVC.h"
#import "IssueProblemDetailsVC.h"
#import "HomeIssueIndexGuidanceView.h"
#import "NewsListEmptyView.h"
@interface HomeViewIssueIndexVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *infoDatas;
@property (nonatomic, strong) NSDictionary *infoSourceDatas;
@property (nonatomic, strong) IssueBoard *infoboard;
@property (nonatomic, strong) HomeNoticeScrollView *notice;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) PWInfoBoardStyle infoBoardStyle;

@property (nonatomic, assign) NSInteger  newsPage;
@property (nonatomic, strong) NSMutableArray<NewsListModel *> *newsDatas;
@property (nonatomic, strong) NewsListCell *tempCell;
@property (nonatomic, strong) NSMutableArray *noticeDatas;
@property (nonatomic, strong) NewsListEmptyView *noDataView;
@end

@implementation HomeViewIssueIndexVC
-(void)viewWillAppear:(BOOL)animated{


    [[IssueSourceManger sharedIssueSourceManger] checkToGetDetectionStatement:^(NSString *string) {
        [_infoboard updateTitle:string];

    }];
    
    if(self.infoBoardStyle == PWInfoBoardStyleConnected){
        if (![kUserDefaults valueForKey:@"HomeIsFirst"]) {
            HomeIssueIndexGuidanceView *guid = [[HomeIssueIndexGuidanceView alloc]init];
            [guid showInView:[UIApplication sharedApplication].keyWindow];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HomeIsFirst"];
        }
    }
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
    self.newsDatas = [NSMutableArray new];
    [self loadNewsDatas];
    [self judgeIssueConnectState];
    [self loadTipsData];
    [self dealWithNotificationData];

}

-(void)dealWithNotificationData{
    NSDictionary * userInfo= getRemoteNotificationData;

    NSString *title = [userInfo valueForKey:@"content"]; //标题
    NSDictionary *extras = [userInfo valueForKey:@"extras"];//服务端定义的字段

    NSString *msgType = [extras stringValueForKey:@"msgType" default:@""];  //消息类型

    if([msgType isEqualToString:@"system_message"]){
        if([extras containsObjectForKey:@"entityId"]){
            NSString *entityId = [extras stringValueForKey:@"entityId" default:@""];

            [SVProgressHUD show];
            [[PWHttpEngine sharedInstance] getMessageDetail:entityId callBack:^(id o) {
                [SVProgressHUD dismiss];
                MineMessageModel*data = (MineMessageModel*)o;
                if(data.isSuccess){
                    MessageDetailVC *detail = [[MessageDetailVC alloc]init];
                    detail.model = data;
                    [self.navigationController pushViewController:detail animated:YES];

                } else{
                    [iToast alertWithTitleCenter:data.errorCode];
                }
            }];


        } else if([extras containsObjectForKey:@"uri"]){
            NSString *uri = [extras stringValueForKey:@"uri" default:@""];
            PWBaseWebVC*webView= [[PWBaseWebVC alloc] initWithTitle:title andURLString:uri];
            [self.navigationController pushViewController:webView animated:YES];
        }

    } else if([msgType isEqualToString:@"issue_engine_finish"]){
        //暂时只停留在首页

    } else if([msgType isEqualToString:@"issue_engine_count"]){
        //暂时只停留在首页

    }else if([msgType isEqualToString:@"issue_add"]){
        NSString *entityId = [extras stringValueForKey:@"entityId" default:@""];
        [SVProgressHUD show];

        [[PWHttpEngine sharedInstance] getIssueDetail:entityId callBack:^(id o) {
            [SVProgressHUD dismiss];
            IssueModel *data = (IssueModel *) o;
            if (data.isSuccess) {
                IssueListViewModel *monitorListModel = [[IssueListViewModel alloc] initWithJsonDictionary:data];

                IssueDetailRootVC *control;
                if ([data.origin isEqualToString:@"user"]) {
                    control = [IssueProblemDetailsVC new];
                } else {
                    control = [IssueDetailVC new];
                }
                control.model = monitorListModel;

                [self.navigationController pushViewController:control animated:YES];

            } else {
                [iToast alertWithTitleCenter:data.errorCode];
            }
        }];


    }else if([msgType isEqualToString:@"recommendation"]){
        NSString *entityId = [extras stringValueForKey:@"entityId" default:@""];
        NSString *summary = [extras stringValueForKey:@"summary" default:@""];
        NSString *url = [extras stringValueForKey:@"url" default:@""];

        NewsWebView *webView=  [[NewsWebView alloc] initWithTitle:title andURLString:url];
        webView.newsModel.newsID = entityId;
        webView.style = WebItemViewStyleNormal;
        [self.navigationController pushViewController:webView animated:YES];
    }

    [kUserDefaults removeObjectForKey:REMOTE_NOTIFICATION_JSPUSH_EXTRA];


}

- (void)judgeIssueConnectState{
    NSString  *ishideguide = getIsHideGuide;
    
    if ([ishideguide isEqualToString:PW_IsHideGuide]) {
        self.infoBoardStyle = PWInfoBoardStyleConnected;
        [[IssueListManger sharedIssueListManger] fetchIssueList:YES];
        [self createUI];
    }else{
        __block  BOOL  isAdmin = YES;
        NSString *team = getTeamState;
        if([team isEqualToString:PW_isTeam]){
            isAdmin =userManager.teamModel.isAdmin;
        }else if([team isEqualToString:PW_isPersonal]){
            isAdmin = YES;
        }
        if (isAdmin == NO) {
            self.infoBoardStyle =PWInfoBoardStyleConnected;
            [ishideguide isEqualToString:PW_IsNotConnect]?setIsHideGuide(PW_IsHideGuide):nil;
            [self createUI];
        }else{
            [[IssueListManger sharedIssueListManger] judgeIssueConnectState:^(BOOL isConnect) {
                self.infoBoardStyle = isConnect?PWInfoBoardStyleConnected:PWInfoBoardStyleNotConnected;
                if (isConnect) {
                    [ishideguide isEqualToString:PW_IsNotConnect]?setIsHideGuide(PW_IsHideGuide):nil;
                    [[IssueListManger sharedIssueListManger] fetchIssueList:YES];
                }else{
                    ishideguide == nil?setIsHideGuide(PW_IsNotConnect):nil;
                }
                [self createUI];
            }];
        }
    }
   
}
- (void)createUI{
    if (self.infoBoardStyle == PWInfoBoardStyleConnected) {
        if (![kUserDefaults valueForKey:@"HomeIsFirst"]) {
            HomeIssueIndexGuidanceView *guid = [[HomeIssueIndexGuidanceView alloc]init];
            [guid showInView:[UIApplication sharedApplication].keyWindow];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HomeIsFirst"];
    }
    }
    CGFloat headerHeight = self.infoBoardStyle == PWInfoBoardStyleConnected?ZOOM_SCALE(530):ZOOM_SCALE(696);

    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, headerHeight)];
   
    [self.headerView addSubview:self.infoboard];
    [self.headerView addSubview:self.notice];
    NSArray *array = [[IssueListManger sharedIssueListManger] getInfoBoardData];
    self.infoDatas = [[NSMutableArray alloc]initWithArray:array];
    [self.infoboard createUIWithParamsDict:@{@"datas":self.infoDatas}];
    __weak typeof(self) weakSelf = self;
    self.infoboard.historyInfoClick = ^(void){
        IssueSourceListVC *infosourceVC = [[IssueSourceListVC alloc]init];
        [weakSelf.navigationController pushViewController:infosourceVC animated:YES];
    };

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
        IssueListVC *monitor = [[IssueListVC alloc]initWithTitle:title andIssueType:issueType];
        monitor.dataSource = [[NSMutableArray alloc]initWithArray:dataSource];
        [weakSelf.navigationController pushViewController:monitor animated:YES];
    };

    self.infoboard.connectClick = ^(){
        AddSourceVC *addVC = [[AddSourceVC alloc]init];
        [weakSelf.navigationController pushViewController:addVC animated:YES];
    };
    [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoboard.mas_bottom).offset(20);
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(60));
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-kTopHeight-16);
    self.tableView.estimatedRowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.tableView registerClass:[NewsListCell class] forCellReuseIdentifier:@"NewsListCell"];
    [self.tableView registerClass:[NewsListImageCell class] forCellReuseIdentifier:@"NewsListImageCell"];

    self.tempCell = [[NewsListCell alloc] initWithStyle:0 reuseIdentifier:@"NewsListCell"];
    [self.view addSubview:self.tableView];

}
-(void)infoBoardStyleUpdate{
    if (self.infoBoardStyle == PWInfoBoardStyleNotConnected ) {
        self.infoBoardStyle = PWInfoBoardStyleConnected;
        [[IssueListManger sharedIssueListManger] fetchIssueList:NO];
        NSArray *array = [IssueListManger sharedIssueListManger].infoDatas;
        [self.infoboard updataInfoBoardStyle:PWInfoBoardStyleConnected itemData:@{@"datas":array}];
        self.headerView.frame =CGRectMake(0, 0, kWidth, ZOOM_SCALE(524));
        self.infoboard.frame = CGRectMake(0, 0, kWidth, ZOOM_SCALE(436));
        self.tableView.tableHeaderView = self.headerView;
    }
}
-(void)infoBoardDatasUpdate{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[IssueListManger sharedIssueListManger] getInfoBoardData];
        NSString *tilte=[[IssueSourceManger sharedIssueSourceManger] getLastDetectionTimeStatement];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.infoboard updateTitle:tilte];
            if (array.count>0) {
                [self.infoboard updataDatas:@{@"datas":array}];
            }
        });

    });

}
-(IssueBoard *)infoboard{
    if (!_infoboard) {
        CGFloat height = self.infoBoardStyle == PWInfoBoardStyleConnected? ZOOM_SCALE(440):ZOOM_SCALE(600);
        _infoboard = [[IssueBoard alloc]initWithFrame:CGRectMake(0, 0, kWidth, height) style:self.infoBoardStyle]; // type从用户信息里提前获取
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
- (NewsListEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[NewsListEmptyView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    }
    return _noDataView;
}
- (void)loadTipsData{
    [PWNetworking requsetWithUrl:PW_TIPS withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if([response isKindOfClass:NSArray.class]){
            NSArray *array = response;
            if (array.count>0) {
                NSDictionary *dict = array[0];
                self.noticeDatas = [NSMutableArray new];
                [self.noticeDatas addObjectsFromArray:array];
                [self.notice createUIWithTitleArray:@[dict[@"title"]]];
            }
           
        }
        
    } failBlock:^(NSError *error) {
        [error errorToast];
    }];
}
- (void)headerRereshing{
    self.newsPage = 1;
    [self showLoadFooterView];
    [[IssueListManger sharedIssueListManger] fetchIssueList:NO];
    
    if(self.noticeDatas.count>0){
    int x = arc4random() % self.noticeDatas.count;
     NSDictionary *dict = self.noticeDatas[x];
      [self.notice createUIWithTitleArray:@[dict[@"title"]]];
    }else{
        [self loadTipsData];
    }
    [self loadRecommendationData];
    [self loadNewsDatas];
    if (self.infoBoardStyle == PWInfoBoardStyleNotConnected) {
        [[IssueListManger sharedIssueListManger] judgeIssueConnectState:^(BOOL isConnect) {

            if (isConnect) {
            [self infoBoardStyleUpdate];
            setIsHideGuide(PW_IsHideGuide);
            }
        }];
    }
}
-(void)footerRereshing{
    [self loadNewsDatas];
}

- (void)loadRecommendationData{
    [PWNetworking requsetWithUrl:PW_recommendation withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *datas = response[@"content"];
            if (datas.count>0) {
                [self RecommendationDatas:datas];
            }else{
                self.newsDatas.count==0?self.tableView.tableFooterView = self.noDataView :nil;
            }
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
            self.newsDatas.count==0?self.tableView.tableFooterView = self.noDataView :nil;
        }
    } failBlock:^(NSError *error) {
      self.newsDatas.count==0?self.tableView.tableFooterView = self.noDataView :nil;
        [error errorToast];
    }];
}
- (void)loadNewsDatas{
  
    NSDictionary *param = @{@"page":[NSNumber numberWithInteger:self.newsPage],@"pageSize":@10,@"isStarred":@YES};
    [PWNetworking requsetWithUrl:PW_newsList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
       

        if ([response[@"errorCode"] isEqualToString:@""]) {
            NSDictionary *data=response[@"data"];
            NSArray *items = data[@"items"];
            if (items.count>0) {
            [self dealNewsDataWithData:items andTotalPage:[data[@"totalPages"] integerValue]];
            self.newsPage == 2? [self loadRecommendationData]:nil;

            }
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
            self.newsPage == 1? [self loadRecommendationData]:nil;
        }
        [self.header endRefreshing];
    } failBlock:^(NSError *error) {
        [error errorToast];
        self.newsPage == 1? [self loadRecommendationData]:nil;
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
    
}
- (void)RecommendationDatas:(NSArray *)array{
    NSMutableArray *recommendDatas = [NSMutableArray new];
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *_Nonnull stop) {
        NewsListModel *model = [[NewsListModel alloc] initWithStickJsonDictionary:dict];
        [recommendDatas addObject:model];
    }];
    [InformationStatusReadManager.sharedInstance setReadStatus:recommendDatas];
    
    [self.newsDatas insertObjects:recommendDatas atIndex:0];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}
- (void)dealNewsDataWithData:(NSArray *)items andTotalPage:(NSInteger)page{
    NSArray *newsArray= [items copy];
    NSMutableArray *newsDatas = [NSMutableArray new];
    [newsArray enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict isKindOfClass:NSDictionary.class]) {
            NewsListModel *model = [[NewsListModel alloc]initWithJsonDictionary:dict];
            [newsDatas addObject:model];
        }
    }];
    if (self.newsPage == 1) {
        [self.newsDatas removeAllObjects];
    }
    [self.newsDatas addObjectsFromArray:newsDatas];
    if (self.newsDatas.count>0) {
        [InformationStatusReadManager.sharedInstance setReadStatus:self.newsDatas];
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
    }else{
        self.tableView.tableFooterView = self.noDataView;
    }

}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model = self.newsDatas[indexPath.row];
    if (model.type == NewListCellTypText) {
        NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell"];
        if (!cell) {
            cell = [[NewsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsListCell"];
        }
        cell.model = self.newsDatas[indexPath.row];

        return cell;
    }else{
        NewsListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListImageCell"];
        if (!cell) {
            cell = [[NewsListImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsListImageCell"];
        }
        cell.model = self.newsDatas[indexPath.row];

        return cell;
    }

}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model = self.newsDatas[indexPath.row];
    model.read = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[InformationStatusReadManager sharedInstance] readInformation:model.newsID];
    });
    [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:false];
    if( model.isStarred){
        NewsWebView *newsweb = [[NewsWebView alloc]initWithTitle:model.title andURLString:model.url];
        newsweb.style = WebItemViewStyleNoCollect;
        newsweb.newsModel = model;
        [self.navigationController pushViewController:newsweb animated:YES];
    }else{
    NewsWebView *newsweb = [[NewsWebView alloc]initWithTitle:model.title andURLString:model.url];
    newsweb.style = WebItemViewStyleNormal;
    newsweb.newsModel = model;
    [self.navigationController pushViewController:newsweb animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model =self.newsDatas[indexPath.row];
    if (model.cellHeight == 0 || !model.cellHeight || model.type == NewListCellTypText) {
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