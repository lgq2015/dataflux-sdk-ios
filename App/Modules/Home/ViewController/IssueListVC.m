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
#import "IssueModel.h"
#import "FillinTeamInforVC.h"
#import "IssueListManger.h"
#import "IssueLogModel.h"
#import "AddIssueGuideView.h"
#import "IssueRecoveredListVC.h"
#import "ZTCreateTeamVC.h"
#import "IssueListHeaderView.h"
#import "IssueDetailsVC.h"

@interface IssueListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) IssueCell *tempCell;
@property (nonatomic, strong) NSMutableArray *monitorData;
@property (nonatomic, copy)   NSString *type;
//@property (nonatomic, strong) UIView *listFooterView;
@property (nonatomic, strong) UILabel *tipLab;
@end

@implementation IssueListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealWithNotificationData)
                                                 name:KNotificationNewRemoteNoti
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hometeamSwitch:)
                                                 name:KNotificationSwitchTeam
                                               object:nil];
    [kNotificationCenter addObserver:self
                            selector:@selector(onNewIssueUpdate:)
                                name:KNotificationNewIssue
                              object:nil];
    [kNotificationCenter addObserver:self
                            selector:@selector(onNewIssueUpdate:)
                                name:KNotificationUpdateIssueList
                              object:nil];

    [self loadAllIssueList:^{
        [self reloadData];
        [self dealWithNotificationData];
    }];
    

}
- (void)hometeamSwitch:(NSNotification *)notification{
    DLog(@"homevc----团队切换请求成功后通知");
    [SVProgressHUD show];
    [[IssueListManger sharedIssueListManger] checkSocketConnectAndFetchIssue:^(BaseReturnModel *model) {
        [SVProgressHUD dismiss];
        NSArray *datas = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:0 issueViewType:0];
        [self.monitorData removeAllObjects];
        [datas enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:obj];
            [self.monitorData addObject:model];
        }];
        if (datas.count == 0) {
             [self showNoDataViewWithStyle:NoDataViewIssueList];
        }else{
             [self removeNoDataImage];
        }
        [self.tableView reloadData];
    }];
}
- (void)loadAllIssueList:(void (^)(void))complete{
    void (^setUpStyle)(void) = ^{
        [self createUI];
    };
    [SVProgressHUD show];
     NSArray *datas = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:0 issueViewType:0];
    if(datas.count>0){
      setUpStyle();
    }
    [[IssueListManger sharedIssueListManger] checkSocketConnectAndFetchIssue:^(BaseReturnModel *model) {
        [SVProgressHUD dismiss];
         complete();
        if (!model.isSuccess) {
            [iToast alertWithTitleCenter:model.errorMsg];
        }
        
    }];
   
}
- (void)dealWithNotificationData{
    DLog(@"dealWithNotificationData");
    NSDictionary *userInfo = getRemoteNotificationData;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate dealWithNotification:userInfo];
    [kUserDefaults removeObjectForKey:REMOTE_NOTIFICATION_JSPUSH_EXTRA];
    [kUserDefaults synchronize];
}


#pragma mark ========== UI布局 ==========
- (void)createUI{
    self.view.backgroundColor = PWWhiteColor;
    NSArray *datas = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:0 issueViewType:0];
    self.monitorData = [NSMutableArray new];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-kTopHeight-25-ZOOM_SCALE(42));
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;

    //让tableview不显示分割线
    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0; //修复 ios 11 reload data 闪动问题
    } else{
        self.tableView.estimatedRowHeight = 44;
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[IssueCell class] forCellReuseIdentifier:@"IssueCell"];
    self.tableView.tableFooterView = self.footView;
    self.tempCell = [[IssueCell alloc] initWithStyle:0 reuseIdentifier:@"IssueCell"];

    self.tableView.mj_header = self.header;
    if (datas.count>0) {
    
        [datas enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:obj];
        [self.monitorData addObject:model];
        }];
    }else{
        [self showNoDataViewWithStyle:NoDataViewIssueList];
    }
   
//    if (![kUserDefaults valueForKey:@"MonitorIsFirst"]) {
//        AddIssueGuideView *guid = [[AddIssueGuideView alloc]init];
//        [guid showInView:[UIApplication sharedApplication].keyWindow];
//
//        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"MonitorIsFirst"];
//    }

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[IssueListManger sharedIssueListManger] updateIssueBoardGetMsgTime:];
//    });

}

-(void)headerRefreshing{
    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
//        [[IssueListManger sharedIssueListManger] updateIssueBoardGetMsgTime:self.type];
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
    [self reloadDataWithIssueType:0 viewType:0];
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

        ZTCreateTeamVC *vc = [ZTCreateTeamVC new];
        vc.dowhat = supplementTeamInfo;
        [self.navigationController pushViewController:vc animated:YES];
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
//-(UIView *)listFooterView{
//    if (!_listFooterView) {
//        _listFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
//        _listFooterView.backgroundColor = PWBackgroundColor;
//        UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"DDDDDD"]]];
//        line.frame = CGRectMake(0, 60-ZOOM_SCALE(20), kWidth, 1);
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
//        btn.titleLabel.font = RegularFONT(13);
//        [btn setTitleColor:PWBlueColor forState:UIControlStateNormal];
//        btn.backgroundColor = PWBackgroundColor;
//        [btn setTitle:@"查看过去 24 小时恢复的情报" forState:UIControlStateNormal];
//        [btn sizeToFit];
//        [_listFooterView addSubview:line];
//        [_listFooterView addSubview:btn];
//        CGFloat width = btn.frame.size.width;
//        [btn addTarget:self action:@selector(noDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(line);
//            make.height.offset(ZOOM_SCALE(20));
//            make.width.offset(width+10);
//        }];
//    }
//    return _listFooterView;
//}
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
- (void)reloadDataWithIssueType:(NSInteger)index viewType:(NSInteger)viewIndex{
    IssueType type = index;
    IssueViewType viewType =viewIndex;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:type issueViewType:viewType];
        
        dispatch_async_on_main_queue(^{
            
            if (dataSource.count > 0) {
                [self.monitorData removeAllObjects];
                [dataSource enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    IssueListViewModel *model = [[IssueListViewModel alloc] initWithJsonDictionary:obj];
                    [self.monitorData addObject:model];
                }];
                [self.tableView reloadData];
                [self removeNoDataImage];
            } else {
                [self showNoDataViewWithStyle:NoDataViewIssueList];
            }
            self.tipLab.hidden = YES;
        });
    });
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.monitorData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.monitorData[indexPath.row]];
    cell.backgroundColor = PWWhiteColor;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.monitorData[indexPath.row];
    model.isRead = YES;
    IssueDetailsVC *detailsVC = [[IssueDetailsVC alloc]init];
    detailsVC.model = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
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
