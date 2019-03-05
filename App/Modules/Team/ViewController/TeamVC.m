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
#import "InformationSourceVC.h"
#import "InviteMembersVC.h"
#import "ServiceLogVC.h"
#import "MemberInfoModel.h"
#import "TeamMemberCell.h"
#import "MemberInfoVC.h"

#define DeletBtnTag 100
@interface TeamVC ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
@property (nonatomic, strong) UILabel *feeLab;
@property (nonatomic, strong) NSDictionary *teamDict;

@property (nonatomic, strong) TeamHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@end

@implementation TeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addTeamSuccess:)
                                                 name:KNotificationTeamStatusChange
                                               object:nil];
    self.isHidenNaviBar = YES;
    [self judgeIsTeam];
}
- (void)judgeIsTeam{
    NSString *team = getTeamState;
    DLog(@"%@",team);
   if([team isEqualToString:PW_isTeam]){
        [self createTeamUI];
    }else{
        [self createPersonalUI];
    }

}
- (void)addTeamSuccess:(NSNotification *)notification
{
    self.isHidenNaviBar = YES;
    NSString *team = getTeamState;
    BOOL isTeam = [notification.object boolValue];
    if (isTeam) {
        [userManager addTeamSuccess:^(BOOL isSuccess) {
            if (isSuccess) {
                if ([team isEqualToString:PW_isTeam]) {
                     [self loadTeamMemberInfo];
                    [self.headerView setTeamName:userManager.teamModel.name];
                }else{
            [self.view removeAllSubviews];
            [self createTeamUI];
            }}
        }];
    }else{
        [self.view removeAllSubviews];
        [self createPersonalUI];
    }
    }

- (void)createTeamUI{
    self.view.backgroundColor = PWBackgroundColor;
    self.headerView = [[TeamHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(550)+kStatusBarHeight)];
     WeakSelf;
    self.headerView.itemClick =^(NSInteger tag){
        if (tag == InvateTag) {
            InviteMembersVC *invite = [[InviteMembersVC alloc]init];
            [weakSelf.navigationController pushViewController:invite animated:YES];
        }else if (tag == InfoSourceTag){
            InformationSourceVC *infoSource = [[InformationSourceVC alloc]init];
            infoSource.isFromTeam = YES;
            [weakSelf.navigationController pushViewController:infoSource animated:YES];
        }else if(tag == ServeTag){
            ServiceLogVC *monitor = [[ServiceLogVC alloc]init];
            [weakSelf.navigationController pushViewController:monitor animated:YES];
        }else{
            FillinTeamInforVC *fillVC = [[FillinTeamInforVC alloc]init];
            fillVC.type = userManager.teamModel.isAdmin == YES? FillinTeamTypeIsAdmin:FillinTeamTypeIsMember;
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
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight);
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
    [self loadTeamMemberInfo];

}
- (void)createPersonalUI{
    self.view.backgroundColor = PWBackgroundColor;
    NSArray *datas = @[@{@"icon":@"team_infoSource",@"title":@"情报源",@"subTitle":@"开放基础诊断情报源上限为3个，为您提供更多的诊断空间"},@{@"icon":@"team_cooperation",@"title":@"协作",@"subTitle":@"支持邀请成员加入团队，共享情报信息；支持主动记录问题，与成员共同解决"},@{@"icon":@"team_serve",@"title":@"服务",@"subTitle":@"云资源购买优惠，多领域的解决方案，总有一款是你想要的"}];
    UIView *temp = nil;
    CGFloat itemHeight = ZOOM_SCALE(74)+Interval(36);
    for (NSInteger i=0; i<datas.count; i++) {
        UIView *item = [self itemWithData:datas[i]];
        if (i==0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(Interval(16));
                make.right.mas_equalTo(self.view).offset(-Interval(16));
                make.top.mas_equalTo(self.view).offset(kTopHeight-20);
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
    [self.view addSubview:createTeam];
    [createTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(temp.mas_bottom).offset(Interval(57));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
    
}
-(UIView *)itemWithData:(NSDictionary *)dict{
    UIView *item = [[UIView alloc]initWithFrame:CGRectZero];
    item.backgroundColor = PWWhiteColor;
    [self.view addSubview:item];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(9), Interval(9), ZOOM_SCALE(30), ZOOM_SCALE(30))];
    icon.image = [UIImage imageNamed:dict[@"icon"]];
    [item addSubview:icon];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:dict[@"title"]];
    [item addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(8));
        make.centerY.mas_equalTo(icon);
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *subTitle = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTitleColor text:dict[@"subTitle"]];
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
    
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamAccount withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            [self dealWithDatas:content];
        }
        [SVProgressHUD dismiss];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
-(NSMutableArray<MemberInfoModel *> *)teamMemberArray{
    if (!_teamMemberArray) {
        _teamMemberArray = [NSMutableArray new];
    }
    return _teamMemberArray;
}
- (void)dealWithDatas:(NSArray *)content{
    if (self.teamMemberArray.count>0) {
        [self.teamMemberArray removeAllObjects];
    }
    NSMutableArray *admin = [NSMutableArray new];
    [content enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:dict error:&error];
        NSString *memberID= [model.memberID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([memberID  isEqualToString:getPWUserID]) {
            [self.teamMemberArray insertObject:model atIndex:0];
        }else if(model.isAdmin){
            [admin addObject:model];
        }else{
            [self.teamMemberArray addObject:model];
        }
    }];
    if (admin.count>0) {
        [self.teamMemberArray addObjectsFromArray:admin];
    }
    [self.headerView setTeamNum:[NSString stringWithFormat:@"共%lu人",(unsigned long)self.teamMemberArray.count]];
    [self.tableView reloadData];
}
- (void)createTeamClick{
    FillinTeamInforVC *fillVC = [[FillinTeamInforVC alloc]init];
    fillVC.type = FillinTeamTypeAdd;
    [self.navigationController pushViewController:fillVC animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teamMemberArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 60;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row !=0){
    MemberInfoVC *member = [[MemberInfoVC alloc]init];
    member.isHidenNaviBar = YES;
    member.isInfo = YES;
    member.teamMemberRefresh =^(){
       [self loadTeamMemberInfo];
    };
    member.model = self.teamMemberArray[indexPath.row];
    [self.navigationController pushViewController:member animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    cell.model = self.teamMemberArray[indexPath.row];
    cell.phoneBtn.hidden = indexPath.row == 0?YES:NO;
    cell.line.hidden = indexPath.row == self.teamMemberArray.count-1?YES:NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (userManager.teamModel.isAdmin && indexPath.row!=0) {
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"]padding:10 callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            [self delectMember:indexPath.row];
            return NO;
        }];
        button.titleLabel.font = MediumFONT(14);
        button.tag = indexPath.row + DeletBtnTag;
//        button.callback = ^BOOL(MGSwipeTableCell * _Nonnull cell) {
//
//        };
        [button centerIconOverTextWithSpacing:5];
        cell.rightButtons = @[button];
        cell.delegate = self;
    }
    return cell;
}
- (void)delectMember:(NSInteger )row{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"移除成员后，成员将不在团队管理中，并不再接收团队任何消息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认移除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *uid =self.teamMemberArray[row].memberID;
        [PWNetworking requsetHasTokenWithUrl:PW_AccountRemove(uid) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[@"errCode"] isEqualToString:@""]) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
