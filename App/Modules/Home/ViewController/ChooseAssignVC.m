//
//  ChooseAssignVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChooseAssignVC.h"
#import "ZLChineseToPinyin.h"
#import "UITableView+SCIndexView.h"
#import "TeamMemberCell.h"
#import "NoAssignCell.h"
#import "IssueListViewModel.h"
@interface ChooseAssignVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
// 索引标题数组(排序后的出现过的拼音首字母数组)
@property(nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) MemberInfoModel *currentModel;
@end

@implementation ChooseAssignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指派处理人";
    [self createUI];
}
- (void)createUI{
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(navBtnClick) tags:@[@11]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kTopHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 67;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:TeamMemberCell.class forCellReuseIdentifier:@"TeamMemberCell"];
    [self.tableView registerClass:NoAssignCell.class forCellReuseIdentifier:@"NoAssignCell"];
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
    configuration.indexItemSelectedBackgroundColor = PWClearColor;
    configuration.indexItemSelectedTextColor = PWTextColor;
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_translucentForTableViewInNavigationBar = NO;
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess) {
            [self dealMemberWithDatas:member];
        }else{
            [self showNoDataImage];
        }
        [PWNetworking requsetHasTokenWithUrl:PW_TeamAccount withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSArray *content = response[@"content"];
                [userManager setTeamMember:content];
                [self dealMemberWithDatas:content];
            }
        } failBlock:^(NSError *error) {
            [error errorToast];
        }];
    }];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
-(NSMutableArray<MemberInfoModel *> *)teamMemberArray{
    if (!_teamMemberArray) {
        _teamMemberArray = [NSMutableArray new];
    }
    return _teamMemberArray;
}
- (void)dealMemberWithDatas:(NSArray *)content{
    
    if (self.teamMemberArray.count>0) {
        [self.teamMemberArray removeAllObjects];
    }
     [self removeNoDataImage];
    __block  NSInteger index = self.teamMemberArray.count>0?1:0;
    [content enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:dict error:&error];
        if([model.memberID isEqualToString:self.assignID]){
            model.isSelect = YES;
            self.currentModel = model;
        }
        if ([model.memberID isEqualToString:userManager.curUserInfo.userID]) {
            [self.teamMemberArray insertObject:model atIndex:0];
            index+=1;
        }else{
            [self.teamMemberArray addObject:model];
        }
        
    }];
    
    [self dealGroupDataWithIgnoreIndex:index];

}
- (void)dealGroupDataWithIgnoreIndex:(NSInteger)index{
    if (self.teamMemberArray.count == 0) {
        [self showNoDataImage];
        return;
    }
    MemberInfoModel *model = [MemberInfoModel new];
    model.noAssign = YES;
    model.isSelect = self.assignID?NO:YES;
    if (model.isSelect) {
        self.currentModel = model;
    }
//    if (self.teamMemberArray.count == index) {
//        [self.dataSource addObject:self.teamMemberArray];
//    }else{
    
        NSArray *data = [self.teamMemberArray subarrayWithRange:NSMakeRange(index, self.teamMemberArray.count-index)];
        self.indexArr = [ZLChineseToPinyin indexWithArray:data Key:@"name"];
        self.dataSource = [ZLChineseToPinyin sortObjectArray:data Key:@"name"];
        [self.dataSource insertObject:[self.teamMemberArray subarrayWithRange:NSMakeRange(0, index)]  atIndex:0];
        [self.dataSource insertObject:@[model] atIndex:0];
        
        [self.indexArr insertObject:@"" atIndex:0];
        [self.indexArr insertObject:@"" atIndex:1];
        self.tableView.sc_indexViewDataSource = self.indexArr;
        [self.tableView reloadData];
//    }
}
- (void)navBtnClick{
    NSString *accountId;
    if (self.currentModel.noAssign) {
        accountId = @"";
        if (!self.assignID) {
         [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }else{
        accountId = self.currentModel.memberID;
        if ([accountId isEqualToString:self.assignID]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [SVProgressHUD show];
    WeakSelf
    [[PWHttpEngine sharedInstance] modifyIssueWithIssueid:self.model.issueId assignedToAccountId:accountId callBack:^(id response) {
        BaseReturnModel *model = response;
        [SVProgressHUD dismiss];
        if (model.isSuccess) {
            KPostNotification(KNotificationReloadIssueList, nil);
            if (weakSelf.MemberInfo) {
                weakSelf.MemberInfo(self.currentModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *sectionItem = self.dataSource[section];
    return sectionItem.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
    NoAssignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoAssignCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;

    }else{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    MemberInfoModel *model = self.dataSource[indexPath.section][indexPath.row];
    model.isMultiChoice = YES;
    NSArray *array =self.dataSource[indexPath.section];
    cell.line.hidden = indexPath.row == array.count-1?YES:NO;
    cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    //    cell.line.hidden = indexPath.row == self.teamMemberArray.count-1?YES:NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section== 1) {
        return @"我";
    }
    return self.indexArr[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 0.1;
    }else{
        return 30;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        self.currentModel.isSelect = NO;
//        TeamMemberCell *cell = (TeamMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
        MemberInfoModel *model =self.dataSource[indexPath.section][indexPath.row];
        model.isSelect = YES;
        self.currentModel = model;
        [self.tableView reloadData];
//        [cell setTeamMemberSelect:YES];

    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
