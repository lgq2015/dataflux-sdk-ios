//
//  IssueSourceListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceListVC.h"
#import "InformationSourceCell.h"
#import "TeamInfoModel.h"
#import "AddSourceVC.h"
#import "IssueSourceDetailVC.h"
#import "IssueSourceManger.h"
#import "BaseReturnModel.h"

#define TagNoDataImageView  150
@interface IssueSourceListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger  currentPage;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UIView *nodataView;
@end

@implementation IssueSourceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连接云服务";
    [self createUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(headerRefreshing)
                                                 name:KNotificationInfoBoardDatasUpdate
                                               object:nil];
}
- (void)createUI{
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    NSMutableArray *newMarr = [NSMutableArray arrayWithArray:marr];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[IssueSourceDetailVC class]] || [vc isKindOfClass:[AddSourceVC class]]) {
            [newMarr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = newMarr;
    self.currentPage = 1;
    self.dataSource = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = self.header;
    
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.rowHeight = 100.f;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[InformationSourceCell class] forCellReuseIdentifier:@"InformationSourceCell"];
    if (userManager.teamModel.isAdmin) {
         [self addNavigationItemWithTitles:@[@"添加"] isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
    }
}
- (void)addIssueSource{
    
}
- (void)loadTeamProductcompletion:(void(^)(BOOL isDefault))completion{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamProduct withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            NSDictionary *basic_source = content[0];
            BOOL isdefault = [basic_source boolValueForKey:@"isDefault" default:NO];
            completion(isdefault);
        }else{
        completion(NO);
        }
    } failBlock:^(NSError *error) {
        completion(NO);
        [SVProgressHUD dismiss];
    }];
}
- (void)loadData{
    //拿本地数据

    if (_isLoading)return;

    _isLoading = YES;

    [self loadFromDB];

    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(BaseReturnModel *model) {
        [self.header endRefreshing];
        if (!model.isSuccess) {
            [iToast alertWithTitleCenter:model.errorMsg delay:1];
        } else {
            [self loadFromDB];
        }

        _isLoading = NO;
    }];

    //更新数据

}

- (void)loadFromDB {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceList];
        dispatch_async_on_main_queue(^{
            self.dataSource = [array mutableCopy];
            if (self.dataSource.count > 0) {
                [self hideNoDataImageView];
                DLog(@"reload")

                [self.tableView reloadData];
                self.tableView.tableFooterView = self.footView;
            } else {
                [self showNoDataViewWithStyle:NoDataViewNormal];
            }

        });

    });
}

-(void)hideNoDataImageView{
    NSArray *title = @[@"添加"];
    if([getTeamState isEqualToString:PW_isTeam]){
        BOOL isadmain = userManager.teamModel.isAdmin;
        if (isadmain) {
            [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
        }
    }else{
        [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
    }
    self.nodataView.hidden = YES;
    self.tableView.hidden = NO;
}
-(void)showNoDataImageView{
    self.navigationItem.rightBarButtonItem = nil;
    if (self.tableView) {
        self.tableView.hidden = YES;
    }
    self.nodataView.hidden = NO;

}
-(UIView *)nodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kTopHeight)];
        _nodataView.backgroundColor = PWWhiteColor;
        [self.view addSubview:_nodataView];
        UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:[UIColor colorWithHexString:@"#140F26"] text:@"请去web端添加"];
        tip.numberOfLines = 0;
        //设置内容
        [self setContent:tip];
        [_nodataView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nodataView).offset(Interval(47));
            make.left.equalTo(_nodataView).offset(16);
            make.right.equalTo(_nodataView).offset(-16);
        }];
    }
    return _nodataView;
}
-(void)headerRefreshing{
    self.currentPage = 1;
    [self loadData];
}
// 添加云服务跳转
- (void)addInfoSource{
    AddSourceVC *addVC = [[AddSourceVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DLog(@"list count");
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationSourceCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DLog(@"list cell");
    cell.model = [[IssueSourceViewModel alloc]initWithJsonDictionary:self.dataSource[indexPath.row]];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  //  [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    InformationSourceCell *cell = (InformationSourceCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if ([getTeamState isEqualToString:PW_isPersonal] || userManager.teamModel.isAdmin==YES) {
//        [self loadTeamProductcompletion:^(BOOL isDefault) {
//            IssueSourceDetailVC *source = [[IssueSourceDetailVC alloc]init];
//            source.model = cell.model;
//            source.isAdd = NO;
//            source.isDefault = isDefault;
//            [self.navigationController pushViewController:source animated:YES];
//        }];
//    }

}
//设置 无数据内容
- (void)setContent:(UILabel *)label{
    NSString *string = @"通过连接云服务，您可以将您的云服务账号与王教授进行连接，从而获得针对云资源的专业诊断，发现可优化的配置，监控您的系统健康状态。\n所有发现的问题都将以情报推送给您，以便您可以及时获知 IT 系统存在的问题，与团队成员共同查看并沟通解决。\n\n连接云服务仅支持在 Web 端操作，请您登录 home.prof.wang，进行连接云服务的配置。";
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:@"home.prof.wang"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor blueColor];
    [attribut addAttributes:dic range:range];
    label.attributedText = attribut;
}




@end
