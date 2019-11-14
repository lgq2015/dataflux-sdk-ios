//
//  HomeIssueListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HomeIssueListVC.h"
#import "IssueListVC.h"
#import "IssueListManger.h"
#import "ScanViewController.h"
#import "RootNavigationController.h"
#import "ZTChangeTeamNavView.h"
#import "TeamInfoModel.h"
#import "IssueSelectHeaderView.h"
#import "SearchIssueVC.h"
#import "TouchLargeButton.h"
#import "SelectObject.h"
#import "IssueChartVC.h"

#define HomeNavHeight Interval(98)+kStatusBarHeight
@interface HomeIssueListVC ()<IssueSelectHeaderDelegate,SelectSortViewDelegate,ZTChangeTeamNavViewDelegate>
@property (nonatomic, strong) IssueSelectHeaderView *headerView;
@property (nonatomic, strong) IssueListVC *listVC;
@property (nonatomic, strong) ZTChangeTeamNavView *changeTeamNavView;
@property (nonatomic, strong) TouchLargeButton *mineTypeBtn;
@property (nonatomic, strong) SelectObject *selObj;
@property (nonatomic, strong) IssueSelectSortTypeView *isMineView;//我的情报
@property (nonatomic, strong) IssueChartVC *chartVC;
@end

@implementation HomeIssueListVC
#pragma mark ====其他========
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selObj = [[IssueListManger sharedIssueListManger] getCurrentSelectObject];
    [self createNav];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addTeamSuccess:)
                                                 name:KNotificationTeamStatusChange
                                               object:nil];
    [kNotificationCenter addObserver:self
                                             selector:@selector(hometeamSwitch)
                                                 name:KNotificationSwitchTeam
                                               object:nil];
    WeakSelf
    [self loadAllIssueList:^{
        
        [weakSelf.listVC reloadDataWithSelectObject:nil refresh:NO];
        [weakSelf.listVC dealWithNotificationData];
        [weakSelf.chartVC refreshData];
    }];
    // Do any additional setup after loading the view.
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
- (void)createNav{
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, HomeNavHeight)];
    [self.view addSubview:nav];
    UIButton *scanBtn = [[UIButton alloc]init];
    [scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nav).offset(kTopHeight-23);
        make.right.mas_equalTo(nav).offset(-13);
        make.width.height.offset(Interval(28));
    }];
    NSString *titleString;
    if([getTeamState isEqualToString:PW_isTeam]){
        titleString = userManager.teamModel.name;
    }else{
        titleString = NSLocalizedString(@"local.MyTeam", @"");
    }
    _changeTeamNavView = [[ZTChangeTeamNavView alloc] initWithTitle:titleString font:BOLDFONT(20) showWithOffsetY:HomeNavHeight-1];
    _changeTeamNavView.delegate = self;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue <= 11.0) {
        _changeTeamNavView.frame = [_changeTeamNavView getChangeTeamNavViewFrame:NO];
    }
    [nav addSubview:_changeTeamNavView];
    [_changeTeamNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.centerY.mas_equalTo(scanBtn);
        make.height.offset(Interval(25));
    }];
    [nav addSubview:self.mineTypeBtn];
    [self.mineTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(_changeTeamNavView.mas_bottom).offset(Interval(16));
        make.left.mas_equalTo(nav).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(21));
        make.width.offset(ZOOM_SCALE(90));
    }];
    nav.backgroundColor = PWWhiteColor;
    UIButton *changeBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:NSLocalizedString(@"local.BackToTheList", @"")];
    changeBtn.titleLabel.font = RegularFONT(13);
    [changeBtn setTitle:NSLocalizedString(@"local.BackToTheList", @"") forState:UIControlStateNormal];
    [changeBtn setTitle:NSLocalizedString(@"local.EnterTheStatisticsView", @"") forState:UIControlStateSelected];
    [nav addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nav).offset(-Interval(16));
        make.height.mas_equalTo(ZOOM_SCALE(21));
        make.centerY.mas_equalTo(self.mineTypeBtn);
    }];
    [changeBtn addTarget:self action:@selector(changeViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *searchView = [self createSearchView];
    [nav addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nav).offset(Interval(16));
        make.right.mas_equalTo(nav).offset(-Interval(16));
        make.height.offset(Interval(30));
    make.top.mas_equalTo(nav).offset(HomeNavHeight);
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, HomeNavHeight-0.5, kWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [nav addSubview:line];
    self.headerView = [[IssueSelectHeaderView alloc]initWithFrame:CGRectMake(0, HomeNavHeight+Interval(42), kWidth, ZOOM_SCALE(42)) type:SelectHeaderAddIssue];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0,HomeNavHeight , kWidth, kHeight-kTabBarHeight-HomeNavHeight)];
    [self.view addSubview:contentView];
    self.listVC = [IssueListVC new];
    self.chartVC = [IssueChartVC new];
    [self addChildViewController:self.listVC];
    [self addChildViewController:self.chartVC];
    [contentView addSubview:self.listVC.view];
    [RACObserve(changeBtn, selected) subscribeNext:^(id x) {
        if ([x boolValue]) {
            contentView.frame = CGRectMake(0,HomeNavHeight+84, kWidth, kHeight-kTabBarHeight-HomeNavHeight-84);
            nav.frame = CGRectMake(0, 0, kWidth, HomeNavHeight+84);
            line.frame = CGRectMake(0, HomeNavHeight+41.5, kWidth, 0.5);
            [self transitionFromViewController:self.chartVC toViewController:self.listVC duration:0.2 options:UIViewAnimationOptionAutoreverse animations:nil completion:^(BOOL finished) {
                
            }];
            self.mineTypeBtn.hidden = NO;
        }else{
            contentView.frame = CGRectMake(0,HomeNavHeight , kWidth, kHeight-kTabBarHeight-HomeNavHeight);
            nav.frame = CGRectMake(0, 0, kWidth, HomeNavHeight);
            line.frame = CGRectMake(0, HomeNavHeight-0.5, kWidth, 0.5);
            [self transitionFromViewController:self.listVC toViewController:self.chartVC duration:0.2 options:UIViewAnimationOptionAutoreverse animations:nil completion:^(BOOL finished) {
                
            }];
            self.mineTypeBtn.hidden = YES;
        }
    }];
}
-(TouchLargeButton *)mineTypeBtn{
    if (!_mineTypeBtn) {
        _mineTypeBtn = [[TouchLargeButton alloc]init];
        _mineTypeBtn.largeWidth = 20;
        _mineTypeBtn.largeHeight = 14;
        NSString *title = self.selObj.issueFrom == IssueFromMe?NSLocalizedString(@"local.MyIssue", @""):NSLocalizedString(@"local.AllIssue", @"");
        [_mineTypeBtn setTitle:title forState:UIControlStateNormal];
        [_mineTypeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        [_mineTypeBtn setTitleColor:PWBlueColor forState:UIControlStateSelected];
        _mineTypeBtn.titleLabel.font = RegularFONT(15);
        [_mineTypeBtn addTarget:self action:@selector(mineTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mineTypeBtn setImage:[UIImage imageNamed:@"arrow_down_c"] forState:UIControlStateNormal];
        [_mineTypeBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateSelected];
        [_mineTypeBtn sizeToFit];
        _mineTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_mineTypeBtn.imageView.frame.size.width - _mineTypeBtn.frame.size.width + _mineTypeBtn.titleLabel.frame.size.width-10, 0, 0);
        _mineTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_mineTypeBtn.titleLabel.frame.size.width - _mineTypeBtn.frame.size.width + _mineTypeBtn.imageView.frame.size.width);
    }
    return _mineTypeBtn;
}
-(IssueSelectSortTypeView *)isMineView{
    if (!_isMineView) {
        _isMineView = [[IssueSelectSortTypeView alloc]initWithTop:HomeNavHeight AndSelectTypeIsTime:NO];
        _isMineView.delegate = self;
        WeakSelf
        _isMineView.disMissClick = ^(){
            weakSelf.mineTypeBtn.selected = NO;
        };
    }
    return _isMineView;
}
- (UIView *)createSearchView{
    
    UIView *searchView = [[UIView alloc]init];
    searchView.layer.cornerRadius = 4.0;
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]init];
    [searchTap addTarget:self action:@selector(searchBtnClick)];
    [searchView addGestureRecognizer:searchTap];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
    [searchView addSubview:icon];
    icon.frame = CGRectMake(6, 0, Interval(30), Interval(30));
    UILabel *searchLab = [PWCommonCtrl lableWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+5, 0, 200, Interval(30)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:NSLocalizedString(@"local.search", @"")];
    [searchView addSubview:searchLab];
    return searchView;
}
- (void)changeViewClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self dissMissAlertView];
}
- (void)mineTypeBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        if (self.headerView.sortByTimeView.isShow) {
            [self.headerView.sortByTimeView disMissView];
        }else if(self.headerView.selView.isShow){
            [self.headerView.selView disMissView];
        }
        [self.isMineView showInView:[UIApplication sharedApplication].keyWindow selectObj:self.selObj];
    }else{
        [self.isMineView disMissView];
    }
    [self.changeTeamNavView dissMissView];
}
- (void)hometeamSwitch{
    [self.headerView teamSwitchChangeBtnTitle];
    [self changeTopLeftNavTitleName];
    WeakSelf
    [self loadAllIssueList:^{
           [weakSelf.listVC reloadDataWithSelectObject:nil refresh:NO];
           [weakSelf.chartVC refreshData];
       }];
}
- (void)addTeamSuccess:(NSNotification *)notification{
    [self changeTopLeftNavTitleName];
    [self.chartVC refreshData];
    [self.tableView reloadData];
    WeakSelf
    [userManager addTeamSuccess:^(BOOL isSuccess) {
        if (isSuccess){
            [weakSelf changeTopLeftNavTitleName];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)scanBtnClick{
    [self.changeTeamNavView dissMissView];
    [self dissMissAlertView];
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.isVideoZoom = YES;
    scan.libraryType = SLT_Native;
    scan.scanCodeType = SCT_QRCode;
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:scan];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)searchBtnClick{
    [self.changeTeamNavView dissMissView];
    [self dissMissAlertView];
    SearchIssueVC *search = [[SearchIssueVC alloc]init];
    search.isHidenNaviBar = YES;
    [self.navigationController pushViewController:search animated:YES];
}
-(void)dissMissAlertView{
    if(self.headerView.selView.isShow){
           [self.headerView.selView disMissView];
       }else if (self.headerView.sortByTimeView.isShow) {
           [self.headerView.sortByTimeView disMissView];
       }else if(self.isMineView.isShow){
           [self.isMineView disMissView];
       }
}
- (void)changeTopLeftNavTitleName{
    NSString *currentTeamType = userManager.teamModel.type;
    if ([currentTeamType isEqualToString:@"singleAccount"]){
        [_changeTeamNavView changeTitle:NSLocalizedString(@"local.MyTeam", @"")];
    }else{
        [_changeTeamNavView changeTitle:userManager.teamModel.name];
    }
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue <= 11.0) {
        _changeTeamNavView.frame = [_changeTeamNavView getChangeTeamNavViewFrame:YES];
    }
}
-(void)selectIssueSelectObject:(SelectObject *)sel{
    [self.listVC reloadDataWithSelectObject:sel refresh:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self dissMissAlertView];
}
#pragma mark ========== SelectSortViewDelegate ==========
-(void)selectSortWithSelectObject:(SelectObject *)sel{
    NSString *title = sel.issueFrom == IssueFromMe?NSLocalizedString(@"local.MyIssue", @""):NSLocalizedString(@"local.AllIssue", @"");
    [_mineTypeBtn setTitle:title forState:UIControlStateNormal];
    self.selObj = sel;
    [[IssueListManger sharedIssueListManger] setCurrentSelectObject:sel];
    [self.listVC reloadDataWithSelectObject:sel refresh:YES];
    [self.chartVC refreshData];
}
#pragma mark ========== ZTChangeTeamNavViewDelegate ==========
-(void)changeTeamViewShow{
    [self dissMissAlertView];
}
-(void)dealloc{
    self.listVC = nil;
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
