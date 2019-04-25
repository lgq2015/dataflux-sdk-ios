//
//  IssueListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueListVC.h"
#import "IssueCell.h"
#import "IssueListViewModel.h"
#import "AddIssueVC.h"
#import "IssueProblemDetailsVC.h"
#import "IssueModel.h"
#import "FillinTeamInforVC.h"
#import "IssueDetailVC.h"
#import "IssueListManger.h"
#import "IssueLogModel.h"
#import "AddIssueGuideView.h"

@interface IssueListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) IssueCell *tempCell;
@property (nonatomic, strong) NSMutableArray *monitorData;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) UILabel *tipLab;

@end

@implementation IssueListVC
- (id)initWithTitle:(NSString *)title andIssueType:(NSString *)type{
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotificationCenter addObserver:self
                            selector:@selector(onNewIssueUpdate:)
                                name:KNotificationNewIssue
                              object:nil];
    [kNotificationCenter addObserver:self
                            selector:@selector(onNewIssueUpdate:)
                                name:KNotificationUpdateIssueList
                              object:nil];


    [self createUI];

}
#pragma mark ========== UI布局 ==========
- (void)createUI{

    [self addNavigationItemWithTitles:@[@"创建问题"] isLeft:NO target:self action:@selector(navBtnClick:) tags:@[@10]];
    self.monitorData = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0; //修复 ios 11 reload data 闪动问题
    } else{
        self.tableView.estimatedRowHeight = 44;
    }
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[IssueCell class] forCellReuseIdentifier:@"IssueCell"];
    self.tableView.tableFooterView = self.footView;
    self.tempCell = [[IssueCell alloc] initWithStyle:0 reuseIdentifier:@"IssueCell"];

    self.tableView.mj_header = self.header;
    if (self.dataSource.count>0) {
        [self.dataSource enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:obj];
            [self.monitorData addObject:model];
        }];
        [self.tableView reloadData];
    }else{
        [self showNoDataImage];
    }
    if (![kUserDefaults valueForKey:@"MonitorIsFirst"]) {
        AddIssueGuideView *guid = [[AddIssueGuideView alloc]init];
        [guid showInView:[UIApplication sharedApplication].keyWindow];

        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"MonitorIsFirst"];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[IssueListManger sharedIssueListManger] updateIssueBoardGetMsgTime:self.type];
    });

}
-(void)headerRefreshing{
    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
        [[IssueListManger sharedIssueListManger] updateIssueBoardGetMsgTime:self.type];
        [self reloadData];
        [self.header endRefreshing];
    }                                           getAllDatas:YES];
}
- (void)onNewIssueUpdate:(NSNotification *)notification{
    NSDictionary *pass = [notification userInfo];
    if ([pass boolValueForKey:@"updateView" default:NO]) {
        [self reloadData];
    } else {

        NSArray *types = [pass mutableArrayValueForKey:@"types"];
        if ([types containsObject:self.type]) {
            self.tipLab.hidden = NO;
        }
    }
}

- (void)reloadData {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSArray *dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:self.type];

        dispatch_sync_on_main_queue(^{
            self.dataSource = [dataSource mutableCopy];
            if (self.dataSource.count > 0) {
                [self.monitorData removeAllObjects];
                [self.dataSource enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    IssueListViewModel *model = [[IssueListViewModel alloc] initWithJsonDictionary:obj];
                    [self.monitorData addObject:model];
                }];
                [self.tableView reloadData];
                [self removeNoDataImage];
            } else {
                [self showNoDataImage];
            }
            self.tipLab.hidden = YES;
        });
    });

}
- (void)navBtnClick:(UIButton *)btn{
    if([getTeamState isEqualToString:PW_isTeam]){
    AddIssueVC *creatVC = [[AddIssueVC alloc]init];
    creatVC.type = self.type;
        WeakSelf
        creatVC.refresh = ^(){
        [weakSelf headerRefreshing];
        };
    [self.navigationController pushViewController:creatVC animated:YES];
    }else if([getTeamState isEqualToString:PW_isPersonal]){
        FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
        [self.navigationController pushViewController:createTeam animated:YES];
    }else{
        [userManager judgeIsHaveTeam:^(BOOL isSuccess, NSDictionary *content) {
            if (isSuccess) {
                if([getTeamState isEqualToString:PW_isTeam]){
                    AddIssueVC *creatVC = [[AddIssueVC alloc]init];
                    creatVC.type = self.type;
                    [self.navigationController pushViewController:creatVC animated:YES];
                }else if([getTeamState isEqualToString:PW_isPersonal]){
                    FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
                    [self.navigationController pushViewController:createTeam animated:YES];
                }
            }else{
              
            }
        }];
    }
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        NSString *string =@"您有新情报，点击刷新";
        _tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(30)) font:RegularFONT(14) textColor:PWBlueColor text:string];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.backgroundColor = [UIColor colorWithHexString:@"#D3E4F5"];
        [self.view addSubview:_tipLab];
        _tipLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadData)];
        [_tipLab addGestureRecognizer:tap];
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range = [string rangeOfString:@"点击刷新"];
    NSRange pointRange = NSMakeRange(0, range.location);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = PWTextColor;
    //赋值
    [attribut addAttributes:dic range:pointRange];
    _tipLab.attributedText = attribut;
    }
    return _tipLab;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.monitorData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell"];
    cell.model = self.monitorData[indexPath.row];
    cell.backgroundColor = PWWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.monitorData[indexPath.row];
    model.isRead = YES;
    if (model.isFromUser) {
        IssueProblemDetailsVC *detailVC = [[IssueProblemDetailsVC alloc]init];
        detailVC.model = self.monitorData[indexPath.row];
        WeakSelf
        detailVC.refreshClick = ^(){
            [weakSelf reloadData];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        IssueDetailVC *infodetial = [[IssueDetailVC alloc]init];
        infodetial.model = model;
        [self.navigationController pushViewController:infodetial animated:YES];
    }
    [self.tableView reloadData];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.monitorData[indexPath.row];
    if (model.cellHeight == 0 || !model.cellHeight) {
        CGFloat cellHeight = [self.tempCell heightForModel:self.monitorData[indexPath.row]];
        // 缓存给model
        model.cellHeight = cellHeight;

        return cellHeight;
    } else {
        return model.cellHeight;
    }

}

-(void)dealloc{
    [[IssueListManger sharedIssueListManger] updateIssueBoardGetMsgTime:_type];
    KPostNotification(KNotificationInfoBoardDatasUpdate, nil)
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
