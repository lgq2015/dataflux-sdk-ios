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
#import "ServiceLogVC.h"
#import "MemberInfoModel.h"
#import "TeamMemberCell.h"
#import "MemberInfoVC.h"
#import "ServiceLogVC.h"
#import "TeamVC+ChangeNavColor.h"
#import "ZYChangeTeamUIManager.h"
#import "MineMessageVC.h"
#import "ZTCreateTeamVC.h"
#import "ZTChangeTeamNavView.h"
#import "ZTTeamVCTopCell.h"
#import "ZTTeamProductCell.h"
#import "UITableViewCell+ZTCategory.h"
#import "ZTBuChongTeamInfoUIManager.h"
#import "CloudCareVC.h"
#define DeletBtnTag 100
@interface TeamVC ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,ZYChangeTeamUIManagerDelegate,ZTTeamVCTopCellDelegate>
@property (nonatomic, strong) NSDictionary *teamDict;
@property (nonatomic, strong) UIButton *leftNavButton;
@property (nonatomic, strong) UIButton *rightNavButton;
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong)ZTChangeTeamNavView *changeTeamNavView;
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
                                             selector:@selector(hasMemberCacheTeamSwitch:)
                                                 name:KNotificationHasMemCacheSwitchTeam
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editTeamNote:)
                                                 name:KNotificationEditTeamNote
                                               object:nil];
    
    [self initSystemNav];
    [self s_UI];
}

- (void)s_UI{
    //判断是否购买了产品
    self.tableView.mj_header = self.header;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-2 - kTopHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[ZTTeamVCTopCell cellWithNib] forCellReuseIdentifier:[ZTTeamVCTopCell cellReuseIdentifier]];
    [self.tableView registerClass:[TeamMemberCell class] forCellReuseIdentifier:@"TeamMemberCell"];
    [self.tableView registerNib:[ZTTeamProductCell cellWithNib] forCellReuseIdentifier:[ZTTeamProductCell cellReuseIdentifier]];
    [self.view addSubview:self.tableView];
    [self loadTeamMemberInfo];
}


- (void)addTeamSuccess:(NSNotification *)notification{
    [self changeTopLeftNavTitleName];
    [self.tableView reloadData];
    [userManager addTeamSuccess:^(BOOL isSuccess) {
        if (isSuccess){
            [self changeTopLeftNavTitleName];
            [self.tableView reloadData];
        }
    }];
    [self loadTeamMemberInfo];
}
- (void)headerRefreshing{
    [self loadTeamProductData];
    [self loadTeamMemberInfo];
}
- (void)loadTeamProductData{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamProduct withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            [userManager setTeamProduct:content];
            [self.tableView reloadData];
        }
         [self.header endRefreshing];
    } failBlock:^(NSError *error) {
         [self.header endRefreshing];
        [SVProgressHUD dismiss];
    }];
}


- (void)loadTeamMemberInfo{
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess) {
         [self dealWithDatas:member];
        }
    }];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamAccount withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            [userManager setTeamMember:content];
            [self dealWithDatas:content];
        }
        [self.header endRefreshing];
    } failBlock:^(NSError *error) {
        [error errorToast];
        [self.header endRefreshing];
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
    
    [content enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:dict error:&error];
        if (model.isAdmin) {
         [self.teamMemberArray insertObject:model atIndex:0];
        }else{
         [self.teamMemberArray addObject:model];
        }
    }];
    //判断是否要添加专家
    [self addSpecialist];
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
    NSString *memberID= [model.memberID stringByReplacingOccurrencesOfString:@"-" withString:@""];
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
    [self.navigationController pushViewController:member animated:YES];
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
        return 12;
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
        ZTTeamVCTopCell *cell = (ZTTeamVCTopCell *)[tableView dequeueReusableCellWithIdentifier:[ZTTeamVCTopCell cellReuseIdentifier]];
        CGFloat height = [cell caculateRowHeight];
        return height;
    }else{
        if (indexPath.row == 0){
            return 80;
        }else{
            return 60;
        }
    }
}


- (void)delectMember:(NSInteger )row{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"移除成员后，成员将不在团队管理中，并不再接收团队任何消息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认移除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *uid =self.teamMemberArray[row].memberID;
        [PWNetworking requsetHasTokenWithUrl:PW_AccountRemove(uid) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:@"移除成功"];
                [self loadTeamMemberInfo];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"移除失败"];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"移除失败"];
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
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
        }
            break;
        case cloudServerType:{
            IssueSourceListVC *infoSource = [[IssueSourceListVC alloc]init];
            [self.navigationController pushViewController:infoSource animated:YES];
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
        }
            break;
        case server:{
            CloudCareVC  *makeFriendVC = [[CloudCareVC alloc]initWithTitle:@"服务" andURLString:PW_cloudcare];
            makeFriendVC.isHideProgress = NO;
            [self.navigationController pushViewController:makeFriendVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark ====导航栏的显示和隐藏====
- (void)initTopNavBar{
    self.topNavBar.titleLabel.text = @"团队";
    self.topNavBar.backBtn.hidden = YES;
    [self.topNavBar setFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
    [self.topNavBar addBottomSepLine];
}
- (void)zt_removeAllSubview{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NaviBarView class]]){
            [obj removeFromSuperview];
        }
    }];
}
#pragma mark =====系统导航栏设置=====
- (void)initSystemNav{
    self.navigationItem.title = @"";
    NSString *titleString = @"";
    if([getTeamState isEqualToString:PW_isTeam]){
        titleString = userManager.teamModel.name;
    }else{
        titleString = @"我的团队";
    }
    //导航栏左侧按钮设置
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    _changeTeamNavView = [[ZTChangeTeamNavView alloc] initWithTitle:titleString font:font];
    [_changeTeamNavView.navViewLeftBtn addTarget:self action:@selector(navLeftBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    _changeTeamNavView.navViewImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopArrow:)];
    [_changeTeamNavView.navViewImageView addGestureRecognizer:tap];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue <= 11.0) {
        _changeTeamNavView.frame = [_changeTeamNavView getChangeTeamNavViewFrame:NO];
    }
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:_changeTeamNavView];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
}

- (UIButton *)rightNavButton{
    if (!_rightNavButton){
        _rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightNavButton setImage:[UIImage imageNamed:@"team_message"] forState:UIControlStateNormal];
        [_rightNavButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_rightNavButton addTarget:self action:@selector(rightNavClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *redPoint = [[UIView alloc] init];
        redPoint.backgroundColor = [UIColor redColor];
        redPoint.bounds = CGRectMake(0, 0, 6, 6);
        redPoint.tag  = 20;
        redPoint.layer.cornerRadius = 3;
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
        ZYChangeTeamUIManager *mag = [ZYChangeTeamUIManager shareInstance];
        [mag showWithOffsetY:kTopHeight];
        mag.fromVC = self;
        mag.delegate = self;
    }else{
        [[ZYChangeTeamUIManager shareInstance] dismiss];
    }
}
- (void)tapTopArrow:(UITapGestureRecognizer *)ges{
    [self navLeftBtnclick:_changeTeamNavView.navViewLeftBtn];
}

#pragma mark ===通知回调=====
//团队切换
- (void)teamSwitch:(NSNotification *)notification{
    DLog(@"teamvc----无成员缓存团队切换---%@",userManager.teamModel.type);
    [self changeTopLeftNavTitleName];
    [self loadTeamMemberInfo];
}
- (void)hasMemberCacheTeamSwitch:(NSNotification *)notification{
    DLog(@"teamvc----有成员缓存团队切换");
    [self changeTopLeftNavTitleName];
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess) {
            [self dealWithDatas:member];
        }
    }];
}
//修改备注
- (void)editTeamNote:(NSNotification *)notification{
    DLog(@"teamvc----修改备注");
    [self loadTeamMemberInfo];
}
#pragma mark ====常用按钮交互=====
- (void)rightNavClick{
    static int i = 0;
    UIView *view = [self.rightNavButton viewWithTag:20];
    if (i % 2 == 0){
        view.hidden = YES;
    }else{
        view.hidden = NO;
    }
    i++;
    
    
    
    return;
    
    
    
    ZYChangeTeamUIManager *manger = [ZYChangeTeamUIManager shareInstance];
    if (manger.isShowTeamView){
        [manger dismiss];
    }
    MineMessageVC *messageVC = [[MineMessageVC alloc]init];
    messageVC.ownership = Team_Message;
    [self.navigationController pushViewController:messageVC animated:YES];
}
#pragma mark ====其他========
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clickTeamChangeViewBlackBG];
}
//点击切换团队阴影
- (void)clickTeamChangeViewBlackBG{
    [ZYChangeTeamUIManager shareInstance].dismissedBlock = ^(BOOL isDismissed) {
        if (isDismissed){
            _changeTeamNavView.navViewLeftBtn.selected = NO;
            //设置动画
            _changeTeamNavView.navViewLeftBtn.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                _changeTeamNavView.navViewImageView.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
            } completion:^(BOOL finished) {
                _changeTeamNavView.navViewLeftBtn.userInteractionEnabled = YES;
            }];
        }
    };
}
//补充团队信息
- (void)supplementMessage{
    DLog(@"补充信息");
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [PWCommonCtrl alertControllerWithTitle:nil message:@"此功能需要补充完整团队信息方可使用" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *add = [PWCommonCtrl actionWithTitle:@"补充团队信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ZTCreateTeamVC *vc = [ZTCreateTeamVC new];
        vc.dowhat = supplementTeamInfo;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:add];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
//    [[ZTBuChongTeamInfoUIManager shareInstance] show:^{
//        ZTCreateTeamVC *vc = [ZTCreateTeamVC new];
//        vc.dowhat = supplementTeamInfo;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
}
//判断用户有没有购买服务，如果有就添加专家
- (void)addSpecialist{
    NSDictionary *tags = userManager.teamModel.tags;
    if (tags == nil) return;
    NSDictionary *product = tags[@"product"];
    if (product == nil) return;
    NSString *managed = product[@"managed"];
    NSString *support = product[@"support"];
    if (managed != nil || support != nil){
        MemberInfoModel *model =[[MemberInfoModel alloc]init];
        model.isSpecialist = YES;
        model.name = @"王教授";
        model.mobile = @"400-882-3320";
        [self.teamMemberArray insertObject:model atIndex:1];
    }
}
- (UIView *)teamMemberCellHeaderView{
    UIView *view = [[UIView alloc] init];
    //团队名称
    UILabel *teamLab = [[UILabel alloc] init];
    NSString *titleString = @"";
    if([getTeamState isEqualToString:PW_isTeam]){
        titleString = userManager.teamModel.name;
    }else{
        titleString = @"我的团队";
    }
    teamLab.text = titleString;
    teamLab.font = RegularFONT(16);
    teamLab.textColor = [UIColor colorWithHexString:@"#140F26"];
    [view addSubview:teamLab];
    //团队人数
    UILabel *teamMemNumLab = [[UILabel alloc] init];
    teamMemNumLab.text = [NSString stringWithFormat:@"共 %lu 人",(unsigned long)self.teamMemberArray.count];
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
- (UIView *)teamProductCellHeaderView{
    UIView *view = [[UIView alloc] init];
    //团队名称
    UILabel *teamLab = [[UILabel alloc] init];
    teamLab.text = @"尊享权益";
    teamLab.font = RegularFONT(16);
    teamLab.textColor = [UIColor colorWithHexString:@"#140F26"];
    [view addSubview:teamLab];
    //布局
    [teamLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F7"];
    return view;
}
- (TeamMemberCell *)teamMemberCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    MemberInfoModel *model = self.teamMemberArray[indexPath.row];
    cell.model = model;
    cell.line.hidden = indexPath.row == self.teamMemberArray.count-1?YES:NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (userManager.teamModel.isAdmin) {//我是管理员
        if (!model.isAdmin && !model.isSpecialist){//可以对非管理员和非专家执行删除操作
            MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"]padding:10 callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
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
        [_changeTeamNavView changeTitle:@"我的团队"];
    }else{
        [_changeTeamNavView changeTitle:userManager.teamModel.name];
    }
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue <= 11.0) {
        _changeTeamNavView.frame = [_changeTeamNavView getChangeTeamNavViewFrame:YES];
    }
}
@end
