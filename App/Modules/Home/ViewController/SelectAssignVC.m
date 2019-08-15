//
//  SelectAssignVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectAssignVC.h"
#import "ZTSearchBar.h"
#import "TeamMemberCell.h"
#import "MemberInfoModel.h"
#import "ZTSearchBar.h"
#import "NoAssignCell.h"
#import "ZLChineseToPinyin.h"
#import "UITableView+SCIndexView.h"
#import "IssueListManger.h"
#import "TeamAccountListModel.h"
@interface SelectAssignVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ZTSearchBar *ztsearchbar;
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *results;
// 索引标题数组(排序后的出现过的拼音首字母数组)
@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation SelectAssignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.Assigned", @"");
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    _ztsearchbar = [[ZTSearchBar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    _ztsearchbar.backgroundColor = PWWhiteColor;
    WeakSelf
    _ztsearchbar.cancleClick = ^{
        [weakSelf updateSearchResultsForSearchBar:weakSelf.ztsearchbar];
    };
    [self.view addSubview:_ztsearchbar];
    self.dataSource = [NSMutableArray new];
    self.teamMemberArray = [NSMutableArray new];
    self.indexArr = [NSMutableArray new];
    self.results = [NSMutableArray new];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kWidth, kHeight-kTopHeight-55) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(60);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:TeamMemberCell.class forCellReuseIdentifier:@"TeamMemberCell"];
    [self.tableView registerClass:NoAssignCell.class forCellReuseIdentifier:@"NoAssignCell"];

    [[_ztsearchbar.tf rac_textSignal] subscribeNext:^(id x) {
        [weakSelf updateSearchResultsForSearchBar:weakSelf.ztsearchbar];
    }];
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
    }];
    [[PWHttpEngine sharedInstance] getCurrentTeamMemberListWithCallBack:^(id response) {
        TeamAccountListModel *model = response;
        if (model.isSuccess) {
            [userManager setTeamMember:model.list];
            [self dealMemberWithDatas:model.list];
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
- (void)dealMemberWithDatas:(NSArray *)content{
    
    if (self.teamMemberArray.count>0) {
        [self.teamMemberArray removeAllObjects];
    }
    [self removeNoDataImage];
    __block  NSInteger index = self.teamMemberArray.count>0?1:0;
    [content enumerateObjectsUsingBlock:^(MemberInfoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
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
    model.name = NSLocalizedString(@"local.AllAssigned", @"");
    model.memberID = ILMStringAll;
    MemberInfoModel *model2 = [MemberInfoModel new];
    model2.name = [NSString stringWithFormat:@"<%@>",NSLocalizedString(@"local.NoAssigned", @"")];
    model2.memberID = @"";
    
    NSArray *data = [self.teamMemberArray subarrayWithRange:NSMakeRange(index, self.teamMemberArray.count-index)];
    self.indexArr = [ZLChineseToPinyin indexWithArray:data Key:@"name"];
    self.dataSource = [ZLChineseToPinyin sortObjectArray:data Key:@"name"];
    [self.dataSource insertObject:[self.teamMemberArray subarrayWithRange:NSMakeRange(0, index)]  atIndex:0];
    [self.dataSource insertObject:@[model,model2] atIndex:0];
    
    [self.indexArr insertObject:@"" atIndex:0];
    [self.indexArr insertObject:@"" atIndex:1];
    self.tableView.sc_indexViewDataSource = self.indexArr;
    [self.results removeAllObjects];
    [self.results addObjectsFromArray:self.dataSource];
    [self.tableView reloadData];
    //    }
}
#pragma mark - UISearchResultsUpdating
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
    self.tableView.sc_indexViewDataSource = nil;
    self.isSearch = YES;
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
   
    if (self.isSearch == YES) {
        TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
        MemberInfoModel *model = self.results[indexPath.section][indexPath.row];
        NSArray *array =self.results[indexPath.section];
        cell.line.hidden = indexPath.row == array.count-1?YES:NO;
        cell.model = model;
        return cell;
    }else{
    if (indexPath.section == 0) {
        NoAssignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoAssignCell"];
        cell.model = self.results[indexPath.section][indexPath.row];
        return cell;
        
    }else{
        TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
        MemberInfoModel *model = self.dataSource[indexPath.section][indexPath.row];
        NSArray *array =self.results[indexPath.section];
        cell.line.hidden = indexPath.row == array.count-1?YES:NO;
        cell.model = model;
        return cell;
    }
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section== 1) {
        return NSLocalizedString(@"local.Me", @"");
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
    
    MemberInfoModel *model =self.results[indexPath.section][indexPath.row];
    if (self.itemClick) {
        self.itemClick(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    if (self.disMissClick) {
        self.disMissClick();
    }
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
