//
//  HomeIssueListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HomeIssueListVC.h"
#import "IssueListHeaderView.h"
#import "IssueListVC.h"
#import "IssueListManger.h"
#import "ScanViewController.h"
#import "RootNavigationController.h"
#import "ZTChangeTeamNavView.h"
#import "TeamInfoModel.h"
@interface HomeIssueListVC ()<IssueListHeaderDelegate>
@property (nonatomic, strong) IssueListHeaderView *headerView;
@property (nonatomic, strong) IssueListVC *listVC;
@property (nonatomic, strong) ZTChangeTeamNavView *changeTeamNavView;
@end

@implementation HomeIssueListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
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
    nav.backgroundColor = PWBackgroundColor;
    NSString *titleString;
    if([getTeamState isEqualToString:PW_isTeam]){
        titleString = userManager.teamModel.name;
    }else{
        titleString = @"我的团队";
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
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+24, kWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [nav addSubview:line];
    self.headerView = [[IssueListHeaderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nav.frame) , kWidth, ZOOM_SCALE(42))];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    CGFloat topHeight = CGRectGetMaxY(self.headerView.frame);
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0,topHeight , kWidth, kHeight-kTabBarHeight-topHeight)];
    [self.view addSubview:contentView];
    self.listVC = [IssueListVC new];
    [self addChildViewController:self.listVC];
    [contentView addSubview:self.listVC.view];
}
- (void)navLeftBtnclick:(UIButton *)button{
    
}
- (void)tapTopArrow:(UITapGestureRecognizer *)tap{
    
}
- (void)scanBtnClick{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.isVideoZoom = YES;
    scan.libraryType = SLT_Native;
    scan.scanCodeType = SCT_QRCode;
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:scan];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)selectIssueTypeIndex:(NSInteger)index{
    [self.listVC reloadDataWithIssueType:index+1 viewType:0];
}
-(void)selectIssueViewTypeIndex:(NSInteger)index{
    [self.listVC reloadDataWithIssueType:0 viewType:index+1];
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
