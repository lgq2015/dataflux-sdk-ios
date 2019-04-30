//
//  TeamVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamVC.h"
#import "FillinTeamInforVC.h"
#import "TeamHeaderView.h"
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
#define DeletBtnTag 100
@interface TeamVC ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
@property (nonatomic, strong) UILabel *feeLab;
@property (nonatomic, strong) NSDictionary *teamDict;
@property (nonatomic, strong) TeamHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) UIButton *leftNavBtn;
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
    
    [self judgeIsTeam];
    if (self.isShowCustomNaviBar){
        [self initTopNavBar];
    }else{
        [self initSystemNav];
    }
}
- (void)judgeIsTeam{
    
    NSString *team = getTeamState;
   if([team isEqualToString:PW_isTeam]){
        [self createTeamUI];
    }else if([team isEqualToString:PW_isPersonal]){
        [self createPersonalUI];
    }else{
        [userManager judgeIsHaveTeam:^(BOOL isSuccess, NSDictionary *content) {
            if (isSuccess) {
                if([getTeamState isEqualToString:PW_isTeam]){
                    [self createTeamUI];
                }else if([getTeamState isEqualToString:PW_isPersonal]){
                    [self createPersonalUI];
                }
            }else{
             
            }
        }];
    }
}
- (void)addTeamSuccess:(NSNotification *)notification
{
    self.isHidenNaviBar = YES;
    BOOL isTeam = [notification.object boolValue];
    if (isTeam) {
        [userManager addTeamSuccess:^(BOOL isSuccess) {
            if (isSuccess) {
            [self zt_removeAllSubview];
            [self createTeamUI];
            }
        }];
    }else{
        [self zt_removeAllSubview];
        [self createPersonalUI];
    }
    }

- (void)createTeamUI{
    [self zt_removeAllSubview];
    self.view.backgroundColor = PWBackgroundColor;
    self.tableView.mj_header = self.header;
     WeakSelf;
    self.headerView.itemClick =^(NSInteger tag){
        if (tag == InvateTag) {
            InviteMembersVC *invite = [[InviteMembersVC alloc]init];
            [weakSelf.navigationController pushViewController:invite animated:YES];
        }else if (tag == InfoSourceTag){
            IssueSourceListVC *infoSource = [[IssueSourceListVC alloc]init];
            [weakSelf.navigationController pushViewController:infoSource animated:YES];
        }else if(tag == ServeTag){
            ServiceLogVC *monitor = [[ServiceLogVC alloc]init];
            [weakSelf.navigationController pushViewController:monitor animated:YES];
        }else{
            FillinTeamInforVC *fillVC = [[FillinTeamInforVC alloc]init];
            fillVC.changeSuccess = ^(){
                [userManager addTeamSuccess:^(BOOL isSuccess) {
                    if (isSuccess) {
                [weakSelf.headerView setTeamName:userManager.teamModel.name];
            }
                }];};
            fillVC.count = weakSelf.teamMemberArray.count;
            [weakSelf.navigationController pushViewController:fillVC animated:YES];
        }
    };

    [self.headerView setTeamName:userManager.teamModel.name];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(58);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TeamMemberCell class] forCellReuseIdentifier:@"TeamMemberCell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView reloadData];
    [self loadTeamProductData];
    [self loadTeamMemberInfo];

}
- (void)headerRefreshing{
    if ([getTeamState isEqualToString:PW_isPersonal]) {
        [userManager addTeamSuccess:^(BOOL isSuccess) {
            self.isHidenNaviBar = YES;
            if (isSuccess) {
                [self zt_removeAllSubview];
                [self createTeamUI];
            }
            [self.header endRefreshing];
        }];
        [self.header endRefreshing];
    }else{
        [self loadTeamProductData];
        [self loadTeamMemberInfo];
    }
}
- (void)loadTeamProductData{
    [userManager getTeamProduct:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess) {
         [self.headerView setTeamProduct:member];
         CGFloat height = ZOOM_SCALE(24)*member.count+Interval(18);
         self.headerView.frame = CGRectMake(0, 0, kWidth, ZOOM_SCALE(364)+kStatusBarHeight+height);
        [self.tableView setTableHeaderView: self.headerView];
        }
    }];
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamProduct withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            [self.headerView setTeamProduct:content];
            CGFloat height = ZOOM_SCALE(24)*content.count+Interval(18);
            self.headerView.frame = CGRectMake(0, 0, kWidth, ZOOM_SCALE(364)+kStatusBarHeight+height);
            [self.tableView setTableHeaderView: self.headerView];
            [userManager setTeamProduct:content];
        }
         [self.header endRefreshing];
    } failBlock:^(NSError *error) {
         [self.header endRefreshing];
        [SVProgressHUD dismiss];
    }];
}
- (void)createPersonalUI{
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, kHeight);
    self.mainScrollView.mj_header = self.header;
    self.view.backgroundColor = PWBackgroundColor;
    NSArray *datas = @[@{@"icon":@"team_infoSource",@"title":@"情报源",@"subTitle":@"开放基础诊断情报源上限为 3 个，为您提供更多的诊断空间"},@{@"icon":@"team_cooperation",@"title":@"协作",@"subTitle":@"支持邀请成员加入团队，共享情报信息；支持主动记录问题，与团队成员共同解决"},@{@"icon":@"team_serve",@"title":@"服务",@"subTitle":@"云资源购买优惠，多领域的解决方案，总有一款是您想要的"}];
    UIView *temp = nil;
    CGFloat itemHeight = ZOOM_SCALE(74)+Interval(36);
    for (NSInteger i=0; i<datas.count; i++) {
        UIView *item = [self itemWithData:datas[i]];
        if (i==0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(Interval(16));
                make.right.mas_equalTo(self.view).offset(-Interval(16));
                make.top.mas_equalTo(self.mainScrollView).offset(kTopHeight-20);
                make.height.offset(itemHeight);
            }];
            temp = item;
        }else{
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(Interval(16));
                make.right.mas_equalTo(self.view).offset(-Interval(16));
                make.top.mas_equalTo(temp.mas_bottom).offset(Interval(12));
                make.height.offset(itemHeight);
            }];
            temp = item;
        }
    }
    
    UIButton *createTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"创建团队"];
    [createTeam addTarget:self action:@selector(createTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:createTeam];
    [createTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(temp.mas_bottom).offset(Interval(57));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
    
}
-(TeamHeaderView *)headerView{
    if (!_headerView) {
     _headerView = [[TeamHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(364)+kStatusBarHeight)];
    }
    return _headerView;
}
-(UIView *)itemWithData:(NSDictionary *)dict{
    UIView *item = [[UIView alloc]initWithFrame:CGRectZero];
    item.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:item];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(9), Interval(9), ZOOM_SCALE(30), ZOOM_SCALE(30))];
    icon.image = [UIImage imageNamed:dict[@"icon"]];
    [item addSubview:icon];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:dict[@"title"]];
    [item addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(8));
        make.centerY.mas_equalTo(icon);
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *subTitle = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:dict[@"subTitle"]];
    subTitle.numberOfLines = 2;
    
    [item addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(item).offset(Interval(12));
        make.top.mas_equalTo(icon.mas_bottom).offset(Interval(10));
        make.right.mas_equalTo(item).offset(-Interval(12));
        make.height.offset(ZOOM_SCALE(45));
    }];
    item.layer.cornerRadius = 4.0f;
    return item;
}

-(UILabel *)feeLab{
    if (!_feeLab) {
        _feeLab = [[UILabel alloc]init];
        _feeLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:30];
        _feeLab.textColor = PWWhiteColor;
    }
    return _feeLab;
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
    } failBlock:^(NSError *error) {
        [error errorToast];
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
    [self.headerView setTeamName:userManager.teamModel.name];
    [self.headerView setTeamNum:[NSString stringWithFormat:@"共%lu人",(unsigned long)self.teamMemberArray.count]];
    [self.tableView reloadData];
}
- (void)createTeamClick{
    FillinTeamInforVC *fillVC = [[FillinTeamInforVC alloc]init];
    [self.navigationController pushViewController:fillVC animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teamMemberArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 80;
    }else{
        return 60;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *memberID= [self.teamMemberArray[indexPath.row].memberID stringByReplacingOccurrencesOfString:@"-" withString:@""];
      MemberInfoVC *member = [[MemberInfoVC alloc]init];
      member.isHidenNaviBar = YES;
    if ([memberID isEqualToString:getPWUserID]) {
         member.type = PWMemberViewTypeMe;
    }else{
        member.type = PWMemberViewTypeTeamMember;
        member.teamMemberRefresh =^(){
            [self loadTeamMemberInfo];
        };
        member.model = self.teamMemberArray[indexPath.row];
       
    }
     [self.navigationController pushViewController:member animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    cell.model = self.teamMemberArray[indexPath.row];
    cell.line.hidden = indexPath.row == self.teamMemberArray.count-1?YES:NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *memberID= [self.teamMemberArray[indexPath.row].memberID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.phoneBtn.hidden = NO;
    if (userManager.teamModel.isAdmin) {
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
    if ([memberID isEqualToString:getPWUserID]) {
        cell.phoneBtn.hidden = YES;
    }
    return cell;
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
#pragma mark ====导航栏的显示和隐藏====
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.view bringSubviewToFront:self.topNavBar];
//    [self scrollViewDidScroll:self.tableView];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self zt_changeColor:[UIColor whiteColor] scrolllView:self.tableView];
//}
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
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [ZYChangeTeamUIManager shareInstance].dismissedBlock = ^(BOOL isDismissed) {
        if (isDismissed){
            self.leftNavBtn.selected = NO;
            //设置动画
            self.leftNavBtn.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.leftNavBtn.imageView.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
            } completion:^(BOOL finished) {
                self.leftNavBtn.userInteractionEnabled = YES;
            }];
        }
    };
}
- (UIButton *)leftNavBtn{
    if (!_leftNavBtn){
        CGFloat spacing = 7.0;
        _leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftNavBtn setTitle:@"我的团队" forState:UIControlStateNormal];
        [_leftNavBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [_leftNavBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateHighlighted];
        [_leftNavBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_leftNavBtn setTitleColor:[UIColor colorWithHexString:@"#140F26"] forState:UIControlStateNormal];
        [_leftNavBtn sizeToFit];
        [_leftNavBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        // 图片右移
        CGSize imageSize = _leftNavBtn.imageView.frame.size;
        _leftNavBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        // 文字左移
        CGSize titleSize = _leftNavBtn.titleLabel.frame.size;
        _leftNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    }
    return _leftNavBtn;
}
- (void)click:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    sender.selected = !sender.selected;
    //设置动画
    [UIView animateWithDuration:0.2 animations:^{
        if (sender.selected){
            self.leftNavBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            self.leftNavBtn.imageView.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
        }
    } completion:^(BOOL finished) {
        sender.userInteractionEnabled = YES;
    }];
    //显示
    if (sender.isSelected){
        [[ZYChangeTeamUIManager shareInstance] showWithOffsetY:kTopHeight];
        [ZYChangeTeamUIManager shareInstance].fromVC = self;
    }else{
        [[ZYChangeTeamUIManager shareInstance] dismiss];
    }
}

#pragma mark ===通知回调=====
//团队切换
- (void)teamSwitch:(NSNotification *)notification{
    DLog(@"teamvc----团队切换");
    [self loadTeamMemberInfo];
}
@end
