//
//  IssueChartListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartListVC.h"
#import "ClassifyModel.h"
#import "IssueCell.h"
#import "IssueListViewModel.h"
#import "IssueDetailsVC.h"
#import "IssueSelectHeaderView.h"
#import "HLSafeMutableArray.h"
#import "OriginModel.h"
#import "SourceModel.h"
#import "MemberInfoModel.h"
#import "ZhugeIOIssueHelper.h"

@interface IssueChartListVC ()<UITableViewDelegate,UITableViewDataSource,IssueSelectHeaderDelegate>
@property (nonatomic, strong) NSMutableArray *issueData;
@property (nonatomic, strong) SelectObject *currentSelect;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IssueSelectHeaderView *headerView;
@property (nonatomic, strong) HLSafeMutableArray *datas;

@end

@implementation IssueChartListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    [kNotificationCenter addObserver:self
                                  selector:@selector(updateAllData)
                                      name:KNotificationUpdateIssueList
                                    object:nil];
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    [self resetCurrentSelect];
    self.datas = [HLSafeMutableArray new];
    self.currentPage = 1;
    self.view.backgroundColor = PWWhiteColor;
    self.issueData = [NSMutableArray new];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, ZOOM_SCALE(42), kWidth, kHeight-kTopHeight-ZOOM_SCALE(42));
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.headerView =[[IssueSelectHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(42)) selectObject:self.currentSelect type:SelectHeaderStatistical classifyType:self.model.type];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
          //让tableview不显示分割线
    if (@available(iOS 11.0, *)){
       self.tableView.estimatedRowHeight = 0; //修复 ios 11 reload data 闪动问题
        } else{
        self.tableView.estimatedRowHeight = 44;
        }
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[IssueCell class] forCellReuseIdentifier:@"IssueCell"];
    [self updateAllData];
    [self dealDatas];
}
-(SelectObject *)currentSelect{
    if (!_currentSelect) {
        _currentSelect = [SelectObject new];
    }
    return _currentSelect;
}
-(void)resetCurrentSelect{
    self.currentSelect.issueType = IssueTypeAll;
    self.currentSelect.issueLevel = self.level;
    _currentSelect.issueSortType = IssueSortTypeCreate;
    _currentSelect.issueFrom = IssueFromAll;

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
    switch (self.model.type) {
        case ClassifyTypeCrontab:
        self.currentSelect.issueOrigin.origin = @"crontab";
            break;
        case ClassifyTypeTask:
        self.currentSelect.issueType = IssueTypeTask;
            break;
        case ClassifyTypeAlarm:
        self.currentSelect.issueType = IssueTypeAlarm;
        self.currentSelect.issueOrigin.origin = @"alertHub";
        self.currentSelect.issueOrigin.name = @"";
            break;
        case ClassifyTypeReport:
        self.currentSelect.issueType = IssueTypeReport;

            break;
    }
}
- (void)dealDatas{
    [self.issueData removeAllObjects];
    if (self.datas.count == 0) {
        [self showNoDataViewWithStyle:NoDataViewIssueList height:ZOOM_SCALE(42)];
       }else{
        [self removeNoDataImage];
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
}
- (void)updateAllData{
    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
            [self.datas removeAllObjects];
              NSArray *issueData = [[IssueListManger sharedIssueListManger] getIssueListWithSelectObject:self.currentSelect];
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
#pragma mark ========== IssueSelectHeaderDelegate ==========
-(void)selectIssueSelectObject:(SelectObject *)sel{
    self.currentSelect = sel;
       
    [self.datas removeAllObjects];
    NSArray *issueData = [[IssueListManger sharedIssueListManger] getIssueListWithSelectObject:sel];
    if (issueData.count>0) {
        [self.datas addObjectsFromArray:issueData];
    }
    [self dealDatas];
}
#pragma mark ========== UITableViewDelegate ==========
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.issueData[indexPath.row];
    
    return model.titleHeight+ZOOM_SCALE(48)+82;
    
}
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.issueData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell" forIndexPath:indexPath];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.selObj = self.currentSelect;
       [cell setModel:self.issueData[indexPath.row]];
       cell.backgroundColor = PWWhiteColor;
       return cell;
}
-(void)cancleBtnClick{
    if (_headerView.selView.isShow) {
        [_headerView.selView disMissView];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
