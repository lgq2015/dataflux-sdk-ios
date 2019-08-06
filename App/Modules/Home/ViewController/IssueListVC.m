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
#import "ZTCreateTeamVC.h"
#import "IssueDetailsVC.h"
#import "SelectObject.h"
#import "HLSafeMutableArray.h"
#import "ZhugeIOIssueHelper.h"


@interface IssueListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) IssueCell *tempCell;
@property (nonatomic, strong) NSMutableArray *monitorData;
@property (nonatomic, copy)   NSString *type;
//@property (nonatomic, strong) UIView *listFooterView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) HLSafeMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

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
                            selector:@selector(onNewIssueAddUpdate:)
                                name:KNotificationNewIssue
                              object:nil];
    [kNotificationCenter addObserver:self
                            selector:@selector(onNewIssueUpdate:)
                                name:KNotificationUpdateIssueList
                              object:nil];
    [kNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:KNotificationReloadIssueList object:nil];

    [self createUI];
    WeakSelf
    [self loadAllIssueList:^{
        [weakSelf reloadDataWithSelectObject:nil refresh:NO];
        [weakSelf dealWithNotificationData];
    }];
    

}
- (void)hometeamSwitch:(NSNotification *)notification{
    DLog(@"homevc----团队切换请求成功后通知");
    [SVProgressHUD show];
    WeakSelf
    [[IssueListManger sharedIssueListManger] checkSocketConnectAndFetchNewIssue:^(BaseReturnModel *model) {
        [SVProgressHUD dismiss];
        NSArray *datas = [[IssueListManger sharedIssueListManger] getIssueListWithSelectObject:nil];
        if (datas.count == 0) {
             [weakSelf showNoDataViewWithStyle:NoDataViewIssueList];
        }else{
            [weakSelf removeNoDataImage];
            [weakSelf.datas removeAllObjects];
            [weakSelf.datas addObjectsFromArray:datas];
            weakSelf.currentPage = 1;
            [weakSelf dealDatas];
        }
       
    }];
}
- (void)loadAllIssueList:(void (^)(void))complete{
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [SVProgressHUD show];
    });

    [[IssueListManger sharedIssueListManger] checkSocketConnectAndFetchNewIssue:^(BaseReturnModel *model) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
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
    self.currentPage = 1;
    self.view.backgroundColor = PWWhiteColor;
    NSArray *datas = [[IssueListManger sharedIssueListManger] getIssueListWithSelectObject:nil];
    self.monitorData = [NSMutableArray new];
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0); 
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
    self.tempCell = [[IssueCell alloc] initWithStyle:0 reuseIdentifier:@"IssueCell"];

    self.tableView.mj_header = self.header;
    [self.datas addObjectsFromArray:datas];
    if (datas.count>0) {
        [self dealDatas];
    }else{
        [self showNoDataViewWithStyle:NoDataViewIssueList];
    }
   

}
-(void)footerRefreshing{
    self.currentPage++;
    [self addDatas];
}
-(void)headerRefreshing{
    self.currentPage = 1;
    WeakSelf
    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
        [weakSelf reloadDataWithSelectObject:nil refresh:YES];
        [weakSelf.header endRefreshing];
    }                                           getAllDatas:NO];
}
-(HLSafeMutableArray *)datas{
    if (!_datas) {
        _datas = [HLSafeMutableArray new];
    }
    return _datas;
}
- (void)onNewIssueUpdate:(NSNotification *)notification{
    NSDictionary *pass = [notification userInfo];
    if ([pass boolValueForKey:@"updateView" default:NO]) {
        [self reloadDataWithSelectObject:nil refresh:NO];
    }
}
- (void)onNewIssueAddUpdate:(NSNotification *)notification{
    NSDictionary *pass = [notification userInfo];

    NSArray *types = [pass mutableArrayValueForKey:@"types"];
    if ([pass containsObjectForKey:@"types"]) {
        self.tipLab.hidden = NO;
        [self.view bringSubviewToFront:self.tipLab];
    }
    if ([types containsObject:self.type]) {
        self.tipLab.hidden = NO;
        [self.view bringSubviewToFront:self.tipLab];
    }
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
        WeakSelf
        [userManager judgeIsHaveTeam:^(BOOL isSuccess, NSDictionary *content) {
            if (isSuccess) {
                if([getTeamState isEqualToString:PW_isTeam]){
                    AddIssueVC *creatVC = [[AddIssueVC alloc]init];
                    creatVC.type = _type;
                    [weakSelf.navigationController pushViewController:creatVC animated:YES];
                }else if([getTeamState isEqualToString:PW_isPersonal]){
                    FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
                    [weakSelf.navigationController pushViewController:createTeam animated:YES];
                }
            }else{
              
            }
        }];
    }
}
- (void)addDatas{
    NSArray *currentData;
    NSInteger addCount;
    if (self.datas.count<=self.currentPage*10) {
        addCount = self.datas.count%10==0?10:self.datas.count%10;
        if (self.datas.count == (self.currentPage-1)*10) {
            addCount = 0;
        }
        self.tableView.tableFooterView = self.footView;
    }else{
        addCount = 10;
        self.tableView.tableFooterView = self.footer;
    }
    
    currentData = [self.datas subarrayWithRange:NSMakeRange((self.currentPage-1)*10, addCount)];
    WeakSelf
    [currentData enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:obj];
        [weakSelf.monitorData addObject:model];
    }];
    [self.tableView reloadData];
    [self.footer endRefreshing];
}
- (void)dealDatas{
    [self.monitorData removeAllObjects];
    NSArray *currentData;
    if (self.datas.count>=self.currentPage*10) {
        currentData = [self.datas subarrayWithRange:NSMakeRange(0, self.currentPage*10)];
        self.tableView.tableFooterView = self.footer;
    }else{
        currentData = [self.datas copy];
        self.tableView.tableFooterView = self.footView;
    }
    [currentData enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:obj];
        [_monitorData addObject:model];
    }];
    [self.tableView reloadData];
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        NSString *string =@"您有新情报，点击刷新";
        _tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(30)) font:RegularFONT(14) textColor:PWBlueColor text:string];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.backgroundColor = [UIColor colorWithHexString:@"#D3E4F5"];
        [self.view addSubview:_tipLab];
        _tipLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerRefreshing)];
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
- (void)reloadData{
    [self reloadDataWithSelectObject:nil refresh:YES];
}
- (void)reloadDataWithSelectObject:(nullable SelectObject *)sel refresh:(BOOL)refresh{
    if (refresh) {
        self.currentPage =1;
    }

    WeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *dataSource = [[IssueListManger sharedIssueListManger] getIssueListWithSelectObject:sel];
        
        dispatch_async_on_main_queue(^{
            
            if (dataSource.count > 0) {
                [weakSelf.datas removeAllObjects];
                [weakSelf.datas addObjectsFromArray:dataSource];
                [weakSelf dealDatas];
                if (refresh) {
             [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                [weakSelf removeNoDataImage];
            } else {
                [weakSelf showNoDataViewWithStyle:NoDataViewIssueList];
            }
            weakSelf.tipLab.hidden = YES;
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
    [[[ZhugeIOIssueHelper new] eventLookIssue] track];


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.monitorData[indexPath.row];
    
    return model.titleHeight+ZOOM_SCALE(48)+82;

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
