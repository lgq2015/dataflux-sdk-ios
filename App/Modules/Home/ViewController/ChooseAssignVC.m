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
#import "ZTSearchBar.h"
@interface ChooseAssignVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
// 索引标题数组(排序后的出现过的拼音首字母数组)
@property(nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) MemberInfoModel *currentModel;
@property (nonatomic, strong) ZTSearchBar *ztsearchbar;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *results;


@end

@implementation ChooseAssignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指派处理人";
    [self createUI];
}
- (void)createUI{
    _results= [NSMutableArray new];
    _ztsearchbar = [[ZTSearchBar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    _ztsearchbar.backgroundColor = PWWhiteColor;
    WeakSelf
    _ztsearchbar.cancleClick = ^{
        [weakSelf updateSearchResultsForSearchBar:weakSelf.ztsearchbar];
    };
    [self.view addSubview:_ztsearchbar];
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(navBtnClick) tags:@[@11]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kWidth, kHeight-kTopHeight-55) style:UITableViewStylePlain];
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
    //对搜索框中输入的内容进行监听
    [[_ztsearchbar.tf rac_textSignal] subscribeNext:^(id x) {
        [weakSelf updateSearchResultsForSearchBar:weakSelf.ztsearchbar];
    }];
}
- (void)updateSearchResultsForSearchBar:(ZTSearchBar *)searchBar{
    NSString *inputStr = searchBar.tf.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    //排除直接点击searchbar显示问题
    if (inputStr == nil || inputStr.length == 0){
        self.tableView.sc_indexViewDataSource = self.indexArr;
        self.isSearch = NO;
        [self.results addObjectsFromArray:self.dataSource];
        [self hideNoSearchView];
        [self.tableView reloadData];
        return;
    }
    self.isSearch = YES;
    self.tableView.sc_indexViewDataSource = nil;
    NSMutableArray *array = [NSMutableArray new];
    [self.teamMemberArray enumerateObjectsUsingBlock:^(MemberInfoModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name =obj.name;
        if (name != nil &&[name rangeOfString:inputStr].location != NSNotFound) {
            [array addObject:obj];
        }
    }];
    if (array.count == 0) {
        [self showNoSearchView];
    }else{
        [self.results addObject:array];
        [self hideNoSearchView];
    }
    [self.tableView reloadData];
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

    
        NSArray *data = [self.teamMemberArray subarrayWithRange:NSMakeRange(index, self.teamMemberArray.count-index)];
        self.indexArr = [ZLChineseToPinyin indexWithArray:data Key:@"name"];
        self.dataSource = [ZLChineseToPinyin sortObjectArray:data Key:@"name"];
        [self.dataSource insertObject:[self.teamMemberArray subarrayWithRange:NSMakeRange(0, index)]  atIndex:0];
        [self.dataSource insertObject:@[model] atIndex:0];
        
        [self.indexArr insertObject:@"" atIndex:0];
        [self.indexArr insertObject:@"" atIndex:1];
        self.tableView.sc_indexViewDataSource = self.indexArr;
        [self.results removeAllObjects];
        [self.results addObjectsFromArray:self.dataSource];
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
    return self.results.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *sectionItem = self.results[section];
    return sectionItem.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearch) {
        TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
        MemberInfoModel *model = self.results[indexPath.section][indexPath.row];
        model.isMultiChoice = YES;
        NSArray *array =self.results[indexPath.section];
        cell.line.hidden = indexPath.row == array.count-1?YES:NO;
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    if (indexPath.section == 0 && indexPath.row == 0) {
    NoAssignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoAssignCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.model = self.results[indexPath.section][indexPath.row];
    return cell;

    }else{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    MemberInfoModel *model = self.results[indexPath.section][indexPath.row];
    model.isMultiChoice = YES;
    NSArray *array =self.results[indexPath.section];
    cell.line.hidden = indexPath.row == array.count-1?YES:NO;
    cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    }
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
        MemberInfoModel *model =self.results[indexPath.section][indexPath.row];
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
