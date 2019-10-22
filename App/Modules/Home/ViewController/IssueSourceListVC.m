//
//  IssueSourceListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceListVC.h"
#import "InformationSourceCell.h"
#import "TeamInfoModel.h"
#import "IssueSourceManger.h"
#import "BaseReturnModel.h"
//#import "AddSourceVC.h"
#define TagNoDataImageView  150
@interface IssueSourceListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger  currentPage;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UIView *nodataView;
@end

@implementation IssueSourceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.issueSource", @"");
    [self createUI];
    [self loadData];
}
- (void)createUI{
    self.currentPage = 1;
    self.dataSource = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = self.header;
    
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.rowHeight = 100.f;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[InformationSourceCell class] forCellReuseIdentifier:@"InformationSourceCell"];
}

- (void)loadData{
    //拿本地数据

    if (_isLoading)return;

    _isLoading = YES;

    [self loadFromDB];

    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(BaseReturnModel *model) {
        [self.header endRefreshing];
        if (!model.isSuccess) {
            [iToast alertWithTitleCenter:model.errorMsg delay:1];
        } else {
            [self loadFromDB];
        }

        _isLoading = NO;
    }];

    //更新数据

}

- (void)loadFromDB {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[IssueSourceManger sharedIssueSourceManger] getFiltercCustomIssueSourceList];
        dispatch_async_on_main_queue(^{
            self.dataSource = [array mutableCopy];
            if (self.dataSource.count > 0) {
                [self removeNoDataImage];
                [self.tableView reloadData];
                self.tableView.tableFooterView = self.footView;
            } else {
                [self showNoDataViewWithStyle:NoDataViewWebAdd];
            }

        });

    });
}


-(void)showNoDataImageView{
    self.navigationItem.rightBarButtonItem = nil;
    if (self.tableView) {
        self.tableView.hidden = YES;
    }
    self.nodataView.hidden = NO;

}

-(void)headerRefreshing{
    self.currentPage = 1;
    [self loadData];
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DLog(@"list count");
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationSourceCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DLog(@"list cell");
    cell.model = [[IssueSourceViewModel alloc]initWithJsonDictionary:self.dataSource[indexPath.row]];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}





@end
