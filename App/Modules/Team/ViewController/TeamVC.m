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
#import "MonitorVC.h"
#import "MemberInfoModel.h"
#import "TeamMemberCell.h"

@interface TeamVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *feeLab;
@property (nonatomic, strong) NSDictionary *teamDict;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *teamMemberArray;
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
    if (team == nil) {
        [userManager judgeIsHaveTeam:^(BOOL isHave,NSDictionary *content) {
            if(isHave){
                [self createTeamUI];
            }else{
                [self createPersonalUI];
            }
        }];
    }else if([team isEqualToString:PW_isTeam]){
        [self createTeamUI];
    }else{
        [self createPersonalUI];
    }

}
- (void)addTeamSuccess:(NSNotification *)notification
{
    BOOL isTeam = [notification.object boolValue];
    [self.view removeAllSubviews];
    if (isTeam) {
        [self createTeamUI];
        
    }else{
        [self createPersonalUI];
    }
    [self createTeamUI];
}
- (void)createTeamUI{
    [self loadTeamMemberInfo];
    TeamHeaderView *headerView = [[TeamHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(550)+kStatusBarHeight)];
    headerView.itemClick =^(NSInteger tag){
        if (tag == InvateTag) {
            InviteMembersVC *invite = [[InviteMembersVC alloc]init];
            [self.navigationController pushViewController:invite animated:YES];
        }else if (tag == InfoSourceTag){
            InformationSourceVC *infoSource = [[InformationSourceVC alloc]init];
            infoSource.isFromTeam = YES;
            [self.navigationController pushViewController:infoSource animated:YES];
        }else if(tag == ServeTag){
            MonitorVC *monitor = [[MonitorVC alloc]init];
            monitor.isFromTeam = YES;
            [self.navigationController pushViewController:monitor animated:YES];
        }else{
            FillinTeamInforVC *fillVC = [[FillinTeamInforVC alloc]init];
            fillVC.type = userManager.teamModel.isAdmin == YES? FillinTeamTypeIsAdmin:FillinTeamTypeIsMember;
            [self.navigationController pushViewController:fillVC animated:YES];
        }
    };
    DLog(@"%@",userManager.teamModel);
    [headerView setTeamName:userManager.teamModel.name];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(60);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 58, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[TeamMemberCell class] forCellReuseIdentifier:@"TeamMemberCell"];

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
- (void)dealWithDatas:(NSArray *)content{
    self.teamMemberArray = [NSMutableArray new];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    cell.model = self.teamMemberArray[indexPath.row];
    return cell;
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
