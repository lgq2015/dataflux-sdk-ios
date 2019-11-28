//
//  SearchIssueVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/9/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SearchIssueVC.h"
#import "SearchBarView.h"
#import "SearchHistoryView.h"
#import "IssueSelectHeaderView.h"
#import "HLSafeMutableArray.h"
#import "IssueListViewModel.h"
#import "IssueCell.h"
#import "IssueDetailsVC.h"
#import "ZhugeIOIssueHelper.h"
#import "OriginModel.h"
#import "SourceModel.h"
#import "MemberInfoModel.h"
@interface SearchIssueVC ()<SearchBarViewDelegate,SearchHistoryViewDelegate,IssueSelectHeaderDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SearchBarView *searchBar;
@property (nonatomic, strong) SearchHistoryView *historyView;
@property (nonatomic, strong) IssueSelectHeaderView *headerView;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *issueData;
@property (nonatomic, strong) HLSafeMutableArray *datas;
@property (nonatomic, strong) IssueCell *tempCell;
@property (nonatomic, strong) SelectObject *currentSelect;
@property (nonatomic, assign) BOOL isSecondSearch;
@end

@implementation SearchIssueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotificationCenter addObserver:self
                            selector:@selector(updateAllData)
                                name:KNotificationUpdateIssueList
                              object:nil];
    [self createUI];
}
- (void)createUI{
    [self resetCurrentSelect];
    self.searchBar.placeHolder = NSLocalizedString(@"local.search", @"");
    self.historyView.hidden = NO;
    self.currentPage = 1;
    self.view.backgroundColor = PWWhiteColor;
    self.issueData = [NSMutableArray new];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, kTopHeight+ZOOM_SCALE(42), kWidth, kHeight-kTopHeight-ZOOM_SCALE(42));
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.headerView = [[IssueSelectHeaderView alloc]initWithFrame:CGRectMake(0, kTopHeight, kWidth, ZOOM_SCALE(42)) selectObject:self.currentSelect type:SelectHeaderSearch];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    self.headerView.hidden = YES;
    //让tableview不显示分割线
    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0; //修复 ios 11 reload data 闪动问题
    } else{
        self.tableView.estimatedRowHeight = 44;
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[IssueCell class] forCellReuseIdentifier:@"IssueCell"];
    self.tempCell = [[IssueCell alloc] initWithStyle:0 reuseIdentifier:@"IssueCell"];
    self.tableView.hidden = YES;
}
-(void)dealDatas{
    [self.issueData removeAllObjects];
    NSArray *currentData;
    if (self.datas.count>=self.currentPage*10) {
        currentData = [self.datas subarrayWithRange:NSMakeRange(0, self.currentPage*10)];
        self.tableView.tableFooterView = self.footer;
    }else{
        currentData = [self.datas copy];
        self.tableView.tableFooterView = self.footView;
    }
    [currentData enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:obj];
        [_issueData addObject:model];
    }];
    [self.tableView reloadData];
}
- (void)updateAllData{
    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
          [self.datas removeAllObjects];
             NSArray *issueData = [[IssueListManger sharedIssueListManger] getIssueListWithSelectObject:self.currentSelect issueTitle:self.searchText];
             [self.datas addObjectsFromArray:issueData];
             [self dealDatas];
       }                                           getAllDatas:NO];
   
}
-(void)footerRefreshing{
    self.currentPage++;
    [self addDatas];
}
- (void)addDatas{
    NSArray *currentData;
    NSInteger addCount;
    if (self.datas.count<=self.currentPage*10) {
        addCount = self.datas.count%10==0?10:self.datas.count%10;
        if (self.datas.count == (self.currentPage-1)*10) {
            addCount = 0;
        }
        self.tableView.tableFooterView = self.footView;
    }else{
        addCount = 10;
        self.tableView.tableFooterView = self.footer;
    }
    
    currentData = [self.datas subarrayWithRange:NSMakeRange((self.currentPage-1)*10, addCount)];
    WeakSelf
    [currentData enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:obj];
        [weakSelf.issueData addObject:model];
    }];
    [self.tableView reloadData];
    [self.footer endRefreshing];
}
-(SelectObject *)currentSelect{
    if (!_currentSelect) {
        _currentSelect = [SelectObject new];
    }
    return _currentSelect;
}
-(void)resetCurrentSelect{
    self.currentSelect.issueType = IssueTypeAll;
    _currentSelect.issueFrom = IssueFromAll;
    _currentSelect.issueLevel = IssueLevelAll;
    _currentSelect.issueSortType = IssueSortTypeCreate;
     OriginModel *origin = [OriginModel new];
     origin.name =  NSLocalizedString(@"local.AllOrigin", @"");
     origin.origin =ILMStringAll;
     _currentSelect.issueOrigin = origin;
     SourceModel *source = [SourceModel new];
     source.sourceID =ILMStringAll;
     source.name = NSLocalizedString(@"local.AllIssueSource", @"");
     _currentSelect.issueSource = source;
     MemberInfoModel *model = [MemberInfoModel new];
     model.memberID = ILMStringAll;
     model.name = NSLocalizedString(@"local.AllAssigned", @"");
     _currentSelect.issueAssigned = model;
}
-(HLSafeMutableArray *)datas{
    if (!_datas) {
        _datas = [HLSafeMutableArray new];
    }
    return _datas;
}
- (SearchBarView *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
        _searchBar.isClear = YES;
        [self.view addSubview:_searchBar];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
-(SearchHistoryView *)historyView{
    if (!_historyView) {
        _historyView = [[SearchHistoryView alloc]initWithFrame:CGRectMake(0, kTopHeight, kWidth, kHeight-kTopHeight)];
        _historyView.delegate = self;
        [self.view addSubview:_historyView];
    }
    return _historyView;
}
- (void)dealWithSearchText:(NSString *)text SelectObject:(SelectObject *)sel{
    self.historyView.hidden = YES;
    [self.datas removeAllObjects];
   NSArray *issueData = [[IssueListManger sharedIssueListManger] getIssueListWithSelectObject:sel issueTitle:self.searchText];
    if (issueData.count == 0) {
        if (!self.isSecondSearch) {
            self.headerView.hidden = YES;
            [self showNoDataViewWithStyle:NoDataViewIssueList];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showNoDataViewWithStyle:NoDataViewIssueList height:kTopHeight+ZOOM_SCALE(45)+10];
            });
        }
    }else{
        self.headerView.hidden = NO;
        [self removeNoDataImage];
        [self.datas addObjectsFromArray:issueData];
        [self dealDatas];
    }
}

#pragma mark ========== SearchBarViewDelegate ==========
-(void)cancleBtnClick{
    if (_headerView.selView.isShow) {
        [_headerView.selView disMissView];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchWithText:(NSString *)text {
    self.searchText = text;
    self.isSecondSearch = NO;
    [self resetCurrentSelect];
    [self dealWithSearchText:text SelectObject:self.currentSelect];
    [self.historyView saveHistoryData:text];
}
-(void)textFieldClear{
    [self removeNoDataImage];
    [self resetCurrentSelect];
    self.tableView.hidden = YES;
    self.headerView.hidden = YES;
    self.historyView.hidden = NO;
    [self.historyView reloadHistoryData];
}
-(void)searcgBarTextFieldBecomeFirstResponder{
    [self.headerView disMissView];
    [self removeNoDataImage];
    [self resetCurrentSelect];
    self.tableView.hidden = YES;
    self.headerView.hidden = YES;
    self.historyView.hidden = NO;
    [self.historyView reloadHistoryData];
}
#pragma mark ========== SearchHistoryViewDelegate ==========
-(void)searchHistoryWithText:(NSString *)text{
    self.isSecondSearch = NO;
    [self resetCurrentSelect];
    self.searchText = text;
    self.searchBar.searchText = text;
    [self dealWithSearchText:text SelectObject:self.currentSelect];
}
#pragma mark ========== IssueSelectHeaderDelegate ==========
-(void)selectIssueSelectObject:(SelectObject *)sel{
     self.currentSelect = sel;
     self.isSecondSearch = YES;
     [self dealWithSearchText:self.searchText SelectObject:sel];
}

#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.issueData[indexPath.row];
    model.isRead = YES;
    IssueDetailsVC *detailsVC = [[IssueDetailsVC alloc]init];
    detailsVC.model = model;
    WeakSelf
    detailsVC.updateAllClick = ^(void){
        [weakSelf updateAllData];
    };
    [self.navigationController pushViewController:detailsVC animated:YES];
    [self.tableView reloadData];
    [[[ZhugeIOIssueHelper new] eventLookIssue] track];
}
#pragma mark ========== UITableViewDataSource ==========
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.issueData[indexPath.row];
    
    return model.titleHeight+ZOOM_SCALE(48)+82;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.issueData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selObj = self.currentSelect;
    [cell setModel:self.issueData[indexPath.row]];
    cell.backgroundColor = PWWhiteColor;
    return cell;
}
-(void)viewDidDisappear:(BOOL)animated{
   if (_headerView.selView.isShow) {
        [_headerView.selView disMissView];
    }
}
-(void)dealloc{
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
