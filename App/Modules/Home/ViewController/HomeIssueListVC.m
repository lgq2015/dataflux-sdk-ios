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
#import "ZYChangeTeamUIManager.h"
#import "IssueSelectHeaderView.h"

@interface HomeIssueListVC ()<IssueSelectHeaderDelegate>
@property (nonatomic, strong) IssueSelectHeaderView *headerView;
@property (nonatomic, strong) IssueListVC *listVC;
@property (nonatomic, strong) ZTChangeTeamNavView *changeTeamNavView;
@property (nonatomic, strong) ZYChangeTeamUIManager *changeTeamView;
@end

@implementation HomeIssueListVC
#pragma mark ====其他========
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self clickTeamChangeViewBlackBG];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addTeamSuccess:)
                                                 name:KNotificationTeamStatusChange
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(issueTeamSwitch:)
                                                 name:KNotificationSwitchTeam
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editTeamNote:)
                                                 name:KNotificationEditTeamNote
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hometeamSwitch)
                                                 name:KNotificationSwitchTeam
                                               object:nil];
    // Do any additional setup after loading the view.
}
- (void)createNav{
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight+25)];
    [self.view addSubview:nav];
    UIButton *scanBtn = [[UIButton alloc]init];
    [scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(nav).offset(-20);
        make.right.mas_equalTo(nav).offset(-13);
        make.width.height.offset(28);
    }];
    nav.backgroundColor = PWWhiteColor;
    NSString *titleString;
    if([getTeamState isEqualToString:PW_isTeam]){
        titleString = userManager.teamModel.name;
    }else{
        titleString = NSLocalizedString(@"local.MyTeam", @"");
    }
    _changeTeamNavView = [[ZTChangeTeamNavView alloc] initWithTitle:titleString font:BOLDFONT(20)];
    [_changeTeamNavView.navViewLeftBtn addTarget:self action:@selector(navLeftBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    _changeTeamNavView.navViewImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopArrow:)];
    [_changeTeamNavView.navViewImageView addGestureRecognizer:tap];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue <= 11.0) {
        _changeTeamNavView.frame = [_changeTeamNavView getChangeTeamNavViewFrame:NO];
    }
    [nav addSubview:_changeTeamNavView];
    [_changeTeamNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(15));
        make.bottom.mas_equalTo(nav).offset(-20);
        make.height.offset(ZOOM_SCALE(25));
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+24.5, kWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [nav addSubview:line];
    self.headerView = [[IssueSelectHeaderView alloc]initWithFrame:CGRectMake(0, kTopHeight+25, kWidth, ZOOM_SCALE(42))];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    CGFloat topHeight = CGRectGetMaxY(self.headerView.frame);
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0,topHeight , kWidth, kHeight-kTabBarHeight-topHeight)];
    [self.view addSubview:contentView];
    self.listVC = [IssueListVC new];
    [self addChildViewController:self.listVC];
    [contentView addSubview:self.listVC.view];
}
- (void)navLeftBtnclick:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    sender.selected = !sender.selected;
    //设置动画
    [UIView animateWithDuration:0.2 animations:^{
        if (sender.selected){
            _changeTeamNavView.navViewImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            _changeTeamNavView.navViewImageView.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
        }
    } completion:^(BOOL finished) {
        sender.userInteractionEnabled = YES;
    }];
    //显示
    if (sender.isSelected){
        [self.headerView disMissView];
        [self.changeTeamView showWithOffsetY:kTopHeight+24];
    }else{
        [self.changeTeamView  dismiss];
    }
}
- (void)hometeamSwitch{
    [self.headerView teamSwitchChangeBtnTitle];
}
- (void)addTeamSuccess:(NSNotification *)notification{
    [self changeTopLeftNavTitleName];
    [self.tableView reloadData];
    WeakSelf
    [userManager addTeamSuccess:^(BOOL isSuccess) {
        if (isSuccess){
            [weakSelf changeTopLeftNavTitleName];
            [weakSelf.tableView reloadData];
        }
    }];
}
- (void)editTeamNote:(NSNotification *)notification{
    DLog(@"teamvc----修改备注");
}
- (void)tapTopArrow:(UITapGestureRecognizer *)ges{
    [self navLeftBtnclick:_changeTeamNavView.navViewLeftBtn];
    if(self.headerView.selView.isShow){
        [self.headerView.selView disMissView];
    }else if (self.headerView.sortView.isShow) {
        [self.headerView.sortView disMissView];
    }
}
- (void)scanBtnClick{
    if(self.headerView.selView.isShow){
        [self.headerView.selView disMissView];
    }else if (self.headerView.sortView.isShow) {
        [self.headerView.sortView disMissView];
    }else if(self.headerView.isMineView.isShow){
        [self.headerView.isMineView disMissView];
    }
    [_changeTeamView dismiss];
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.isVideoZoom = YES;
    scan.libraryType = SLT_Native;
    scan.scanCodeType = SCT_QRCode;
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:scan];
    [self presentViewController:nav animated:YES completion:nil];
}

-(ZYChangeTeamUIManager *)changeTeamView{
    if (!_changeTeamView) {
        _changeTeamView = [[ZYChangeTeamUIManager alloc]init];
        [_changeTeamView showWithOffsetY:kTopHeight+24];
        _changeTeamView.fromVC = self;
        WeakSelf
        _changeTeamView.dismissedBlock = ^(BOOL isDismissed) {
            if (isDismissed){
                weakSelf.changeTeamNavView.navViewLeftBtn.selected = NO;
                //设置动画
                weakSelf.changeTeamNavView.navViewLeftBtn.userInteractionEnabled = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.changeTeamNavView.navViewImageView.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
                } completion:^(BOOL finished) {
                    weakSelf.changeTeamNavView.navViewLeftBtn.userInteractionEnabled = YES;
                }];
            }
        };
    }
    return _changeTeamView;
}
- (void)issueTeamSwitch:(NSNotification *)notification{
    [self changeTopLeftNavTitleName];
//    [self.headerView refreshHeaderViewTitle];
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
    if(self.headerView.selView.isShow){
        [self.headerView.selView disMissView];
    }else if (self.headerView.sortView.isShow) {
        [self.headerView.sortView disMissView];
    }else if(self.headerView.isMineView.isShow){
        [self.headerView.isMineView disMissView];
    }
    [_changeTeamView dismiss];
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
