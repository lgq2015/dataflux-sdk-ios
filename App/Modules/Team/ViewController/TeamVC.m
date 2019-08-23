//
//  TeamVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamVC.h"
#import "FillinTeamInforVC.h"
#import "TeamInfoModel.h"
#import "IssueSourceListVC.h"
#import "InviteMembersVC.h"
#import "MemberInfoModel.h"
#import "TeamMemberCell.h"
#import "MemberInfoVC.h"
#import "TeamVC+ChangeNavColor.h"
#import "ZYChangeTeamUIManager.h"
#import "MineMessageVC.h"
#import "ZTCreateTeamVC.h"
#import "ZTChangeTeamNavView.h"
#import "ZTTeamVCTopCell.h"
#import "ZTTeamProductCell.h"
#import "UITableViewCell+ZTCategory.h"
#import "ZTBuChongTeamInfoUIManager.h"
#import "ZhugeIOTeamHelper.h"
#import "NotificationRuleVC.h"
#import "TeamHeaderView.h"
#import "UtilsConstManager.h"
#import "TeamAccountListModel.h"
#define DeletBtnTag 100
@interface TeamVC ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,ZTTeamVCTopCellDelegate>
@property (nonatomic, strong) NSDictionary *teamDict;
@property (nonatomic, strong) UIButton *leftNavButton;
@property (nonatomic, strong) UIButton *rightNavButton;
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) ZTChangeTeamNavView *changeTeamNavView;
@property (nonatomic, strong) ZYChangeTeamUIManager *changeTeamView;
@property (nonatomic, strong) TeamHeaderView *headerView;
@end

@implementation TeamVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addTeamSuccess:)
                                                 name:KNotificationTeamStatusChange
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(teamSwitch:)
                                                 name:KNotificationSwitchTeam
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editTeamNote:)
                                                 name:KNotificationEditTeamNote
                                               object:nil];
    
    [self initSystemNav];
    [self s_UI];
}
-(ZYChangeTeamUIManager *)changeTeamView{
    if (!_changeTeamView) {
        _changeTeamView = [[ZYChangeTeamUIManager alloc]init];
        _changeTeamView.fromVC = self;
    }
    return _changeTeamView;
}
- (void)s_UI{
    self.tableView.mj_header = self.header;

    self.tableView.frame = CGRectMake(0, kTopHeight+25, kWidth, kHeight-kTabBarHeight-2 - kTopHeight-25);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.right.left.mas_equalTo(self.tableView);
    }];
    [self.tableView registerNib:[ZTTeamVCTopCell cellWithNib] forCellReuseIdentifier:[ZTTeamVCTopCell cellReuseIdentifier]];
    [self.tableView registerClass:[TeamMemberCell class] forCellReuseIdentifier:@"TeamMemberCell"];
    [self.tableView registerNib:[ZTTeamProductCell cellWithNib] forCellReuseIdentifier:[ZTTeamProductCell cellReuseIdentifier]];
    [self loadTeamMemberInfo];
    [self loadTeamProductData];
}


- (void)addTeamSuccess:(NSNotification *)notification{
    [self changeTopLeftNavTitleName];
    [self.tableView reloadData];
    [userManager addTeamSuccess:^(BOOL isSuccess) {
        if (isSuccess){
            [self changeTopLeftNavTitleName];
            [self.tableView reloadData];
            [self loadTeamMemberInfo];
        }
    }];
}
- (void)headerRefreshing{
    //请求团队列表
    [userManager requestMemberList:nil];
    [userManager addTeamSuccess:^(BOOL isSuccess) {
        if (isSuccess){
            //修改顶部名称
            [self changeTopLeftNavTitleName];
            [self requestTeamMember:^(bool isSuccess, NSArray *content) {
                if (isSuccess){
                    [self dealWithDatas:content];
                }
            }];
        }
    }];
}
- (void)loadTeamProductData{
    [userManager getTeamProduct:^(BOOL isSuccess, NSDictionary *product) {
        if (isSuccess) {
            [self.headerView updataUIWithDatas:product];
            [self.headerView layoutIfNeeded];
            self.tableView.tableHeaderView = self.headerView;
        }
    }];
    [[PWHttpEngine sharedInstance] getTeamProductCallBack:^(id response) {
        BaseReturnModel *model = response;
        [self.header endRefreshing];
        if (model.isSuccess) {
           [userManager setTeamProduct:model.contentDict];
            [self.headerView updataUIWithDatas:model.contentDict];
            [self.headerView layoutIfNeeded];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableHeaderView = self.headerView;
            });
        }
    }];
}
- (void)loadTeamMemberInfo{
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess) {
            [self dealWithDatas:member];
        }
    }];
    [[PWHttpEngine sharedInstance] getCurrentTeamMemberListWithCallBack:^(id response) {
        TeamAccountListModel *model = response;
        [self.header endRefreshing];
        if (model.isSuccess) {
            [userManager setTeamMember:model.list];
            [self dealWithDatas:model.list];
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
-(NSMutableArray<MemberInfoModel *> *)teamMemberArray{
    if (!_teamMemberArray) {
        _teamMemberArray = [NSMutableArray new];
    }
    return _teamMemberArray;
}
- (void)dealWithDatas:(NSArray *)content{
    [userManager setTeamMember:content];
    if (self.teamMemberArray.count>0) {
        [self.teamMemberArray removeAllObjects];
    }
    [content enumerateObjectsUsingBlock:^(MemberInfoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isAdmin) {
        [userManager setTeamAdminIdWithId:model.memberID];
         [self.teamMemberArray insertObject:model atIndex:0];
        }else{
         [self.teamMemberArray addObject:model];
        }
    }];
//    [self addSpecialist123];
    [self.tableView reloadData];
}
- (void)createTeamClick{
    FillinTeamInforVC *fillVC = [[FillinTeamInforVC alloc]init];
    [self.navigationController pushViewController:fillVC animated:YES];
}
#pragma mark -----UITableViewDataSource ----------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return;
    }
    MemberInfoModel *model = self.teamMemberArray[indexPath.row];
    NSString *memberID= model.memberID;
      MemberInfoVC *member = [[MemberInfoVC alloc]init];
      member.isHidenNaviBar = YES;
    //团队成员分三类： 1. 我 2. 其他人 3.虚拟专家
    if ([memberID isEqualToString:getPWUserID]) {
         member.type = PWMemberViewTypeMe;
    }else{
        if (model.isSpecialist){
            member.type = PWMemberViewTypeSpecialist;
        }else{
            member.type = PWMemberViewTypeTeamMember;
            member.teamMemberRefresh =^(){
                [self loadTeamMemberInfo];
            };
        }
    }
    member.model = model;
    member.isShowCustomNaviBar = YES;
    [self.navigationController pushViewController:member animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    [[[ZhugeIOTeamHelper new] eventLookMember] track];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        ZTTeamVCTopCell *cell = (ZTTeamVCTopCell *)[tableView dequeueReusableCellWithIdentifier:[ZTTeamVCTopCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return  cell;
    }else{
        TeamMemberCell *cell = [self teamMemberCell:tableView indexPath:indexPath];
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return [UIView new];
    }else{
        return [self teamMemberCellHeaderView];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }else{
        return 46;
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else{
        return self.teamMemberArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return ZOOM_SCALE(86);
    }else{
            return 60;
    }
}


- (void)delectMember:(NSInteger )row{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"local.TeamDeleteMemberTip", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.ConfirmRemoval", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *uid =self.teamMemberArray[row].memberID;
        [PWNetworking requsetHasTokenWithUrl:PW_AccountRemove(uid) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.SuccessfullyRemoved", @"")];
                [self loadTeamMemberInfo];
            }else{
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.RemovalFailed", @"")];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.RemovalFailed", @"")];
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark ---ZTTeamVCTopCellDelegate---
- (void)didClickTeamTopCell:(UITableViewCell *)cell withType:(TeamTopType)type{
    switch (type) {
        case inviteMemberType:{
            if([getTeamState isEqualToString:PW_isPersonal]){
                [self supplementMessage];
                return;
            }
            InviteMembersVC *invite = [[InviteMembersVC alloc]init];
            [self.navigationController pushViewController:invite animated:YES];
            [[[ZhugeIOTeamHelper new] eventClickInvite] track];

        }
            break;
        case cloudServerType:{
            IssueSourceListVC *infoSource = [[IssueSourceListVC alloc]init];
            [self.navigationController pushViewController:infoSource animated:YES];
            [[[ZhugeIOTeamHelper new] eventConfigIssue] track];

        }
            break;
        case teamManagerType:{
            if([getTeamState isEqualToString:PW_isPersonal]){
                [self supplementMessage];
                return;
            }
            FillinTeamInforVC *fillVC = [[FillinTeamInforVC alloc]init];
            fillVC.changeSuccess = ^(){
                [userManager addTeamSuccess:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [self changeTopLeftNavTitleName];
                    }
                }];};
            fillVC.count = self.teamMemberArray.count;
            [self.navigationController pushViewController:fillVC animated:YES];
            [[[ZhugeIOTeamHelper new] eventClickTeamManager] track];

        }
            break;
        case notificationRule: {
            NotificationRuleVC *ruleVC = [[NotificationRuleVC alloc]init];
            [self.navigationController pushViewController:ruleVC animated:YES];
            break;
        }
    }
}

#pragma mark =====系统导航栏设置=====
- (void)initSystemNav{
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight+25)];
    [self.view addSubview:nav];
    [self.view addSubview:self.rightNavButton];
    [self.rightNavButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+24.5, kWidth, SINGLE_LINE_WIDTH)];
    line.backgroundColor = PWLineColor;
    [nav addSubview:line];
}
-(TeamHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TeamHeaderView alloc]init];
    }
    return _headerView;
}
- (UIButton *)rightNavButton{
    if (!_rightNavButton){
        _rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightNavButton setImage:[UIImage imageNamed:@"team_email"] forState:UIControlStateNormal];
        [_rightNavButton setImage:[UIImage imageNamed:@"team_email"] forState:UIControlStateSelected];
        [_rightNavButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_rightNavButton addTarget:self action:@selector(rightNavClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *redPoint = [[UIView alloc] init];
        redPoint.backgroundColor = [UIColor redColor];
        redPoint.bounds = CGRectMake(0, 0, 6, 6);
        redPoint.tag  = 20;
        redPoint.layer.cornerRadius = 3;
        redPoint.hidden = YES;
        [_rightNavButton.imageView addSubview:redPoint];
        [redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rightNavButton.imageView.mas_top);
            make.right.equalTo(_rightNavButton.imageView.mas_right);
            make.width.height.offset(6);
        }];
    }
    return _rightNavButton;
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
        [self.changeTeamView showWithOffsetY:kTopHeight+24];
    }else{
        [self.changeTeamView dismiss];
    }
}
- (void)tapTopArrow:(UITapGestureRecognizer *)ges{
    [self navLeftBtnclick:_changeTeamNavView.navViewLeftBtn];
}

#pragma mark ===通知回调=====
//团队切换
- (void)teamSwitch:(NSNotification *)notification{
    [self loadTeamProductData];
    [self changeTopLeftNavTitleName];
    //如果有成员缓存，直接刷新
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess){
            [self dealWithDatas:member];
        }
    }];
    //请求当前团队，请求成员列表，刷新界面
    [userManager addTeamSuccess:^(BOOL isSuccess) {
        if (isSuccess){
            [self requestTeamMember:^(bool isSuccess,NSArray *content) {
                if (isSuccess){
                    [self dealWithDatas:content];
                }
            }];
        }
    }];
    //请求团队未读消息
    [self requestTeamSystemUnreadCount];
}
//修改备注
- (void)editTeamNote:(NSNotification *)notification{
    DLog(@"teamvc----Modify the remark");
    [self loadTeamMemberInfo];
}
#pragma mark ====常用按钮交互=====
- (void)rightNavClick{
    
    if (self.changeTeamView.isShowTeamView){
        [self.changeTeamView dismiss];
    }
    MineMessageVC *messageVC = [[MineMessageVC alloc]init];
    messageVC.ownership = Team_Message;
    [self.navigationController pushViewController:messageVC animated:YES];
}
#pragma mark ====其他========
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clickTeamChangeViewBlackBG];
    [self requestTeamSystemUnreadCount];
}
-(void)viewDidAppear:(BOOL)animated{
    if (_headerView) {
        [self.headerView layoutIfNeeded];
        dispatch_async(dispatch_get_main_queue(), ^{
         self.tableView.tableHeaderView = self.headerView;
        });
        [self.headerView layoutIfNeeded];
    }
}
- (void)clickTeamChangeViewBlackBG{
    WeakSelf
    self.changeTeamView.dismissedBlock = ^(BOOL isDismissed) {
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
//补充团队信息
- (void)supplementMessage{
    DLog(@"supplementMessage");
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [PWCommonCtrl alertControllerWithTitle:nil message:NSLocalizedString(@"local.tip.fillTeamInfoTip", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *add = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.SupplementaryTeamInformation", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ZTCreateTeamVC *vc = [ZTCreateTeamVC new];
        vc.dowhat = supplementTeamInfo;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:add];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];

}

- (UIView *)teamMemberCellHeaderView{
    UIView *view = [[UIView alloc] init];
    //团队名称
    UILabel *teamLab = [[UILabel alloc] init];
    NSString *titleString = NSLocalizedString(@"local.TeamMember", @"");
    teamLab.text = titleString;
    teamLab.font = RegularFONT(16);
    teamLab.textColor = [UIColor colorWithHexString:@"#140F26"];
    [view addSubview:teamLab];
    //团队人数
    UILabel *teamMemNumLab = [[UILabel alloc] init];
    teamMemNumLab.text = [NSString stringWithFormat:NSLocalizedString(@"local.teamMemberCount", @""),(unsigned long)self.teamMemberArray.count];
    teamMemNumLab.font = RegularFONT(13);
    teamMemNumLab.textColor = [UIColor colorWithHexString:@"#140F26"];
    [view addSubview:teamMemNumLab];
    //布局
    [teamLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [teamMemNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(teamLab.mas_right).offset(20);
        make.centerY.equalTo(teamLab);
        make.right.mas_lessThanOrEqualTo(view).offset(-15);
    }];
    [teamLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [teamMemNumLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F7"];
    return view;
}

- (TeamMemberCell *)teamMemberCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    MemberInfoModel *model = self.teamMemberArray[indexPath.row];
    cell.model = model;
    cell.line.hidden = indexPath.row == self.teamMemberArray.count-1?YES:NO;
    if (userManager.teamModel.isAdmin) {//我是管理员
        if (!model.isAdmin && !model.isSpecialist){//可以对非管理员和非专家执行删除操作
            MGSwipeButton *button = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"local.delete", @"") icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"]padding:10 callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
                [self delectMember:indexPath.row];
                return NO;
            }];
            button.titleLabel.font = RegularFONT(14);
            button.tag = indexPath.row + DeletBtnTag;
            [button centerIconOverTextWithSpacing:5];
            cell.rightButtons = @[button];
            cell.delegate = self;
        }
    }
    return cell;
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
#pragma mark --请求---
//请求团队系统消息，未读数量
- (void)requestTeamSystemUnreadCount{
    NSDictionary *params = @{@"ownership":@"team"};
    [[PWHttpEngine sharedInstance] getSystemMessageUnreadCountWithParam:params callBack:^(id response) {
        BaseReturnModel *model = response;
        UIView *view = [self.rightNavButton viewWithTag:20];
        NSInteger unread = 0;
        if (model.isSuccess) {
          unread = [model.contentDict longValueForKey:@"unread" default:0];
        }
        view.hidden = unread > 0 ? NO:YES;
    }];
}
//请求团队成员信息
- (void)requestTeamMember:(void(^)(bool isSuccess,NSArray *content))finished{
    [[PWHttpEngine sharedInstance] getCurrentTeamMemberListWithCallBack:^(id response) {
        TeamAccountListModel *model = response;
        [self.header endRefreshing];
        if (model.isSuccess) {
            [userManager setTeamMember:model.list];
            finished(YES,model.list);
        }else{
            finished(NO,nil);
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
//判断用户有没有购买服务，如果有就添加专家
- (void)addSpecialist123{
    TeamInfoModel *model = [userManager getTeamModel];
    NSDictionary *tags = model.tags;
    NSArray *ISPs = PWSafeArrayVal(tags, @"ISPs");
    if (ISPs == nil || ISPs.count == 0) return;
    [[UtilsConstManager sharedUtilsConstManager] getTeamISPs:^(NSArray * _Nonnull isps) {
        if (isps.count>0) {
            NSMutableArray *ipsDics = [NSMutableArray array];
            //找出当前团队所有的专家对象数组
            [ISPs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [isps enumerateObjectsUsingBlock:^(NSDictionary *ispDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *ispName = ispDic[@"ISP"];
                    if ([obj isEqualToString:ispName]){
                        [ipsDics addObject:ispDic];
                        *stop = YES;
                    }
                }];
            }];
            [ipsDics enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *displayName = dic[@"displayName"][@"zh_CN"];
                NSString *mobile = dic[@"mobile"];
                NSString *ISP = dic[@"ISP"];
                MemberInfoModel *model =[[MemberInfoModel alloc]init];
                model.mobile = mobile;
                model.name = displayName;
                model.ISP = ISP;
                model.isSpecialist = YES;
                [self.teamMemberArray insertObject:model atIndex:1];
            }];
        }
    }];
}

@end
