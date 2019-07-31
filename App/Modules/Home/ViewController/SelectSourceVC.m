//
//  SelectSourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectSourceVC.h"
#import "IssueSourceManger.h"
#import "SelectSourceCell.h"
#import "ZTSearchBar.h"
#import "SourceModel.h"
@interface SelectSourceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZTSearchBar *ztsearchbar;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation SelectSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"云服务";
    [self createUI];
}
- (void)createUI{
    _ztsearchbar = [[ZTSearchBar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    _ztsearchbar.backgroundColor = PWWhiteColor;
    WeakSelf
    _ztsearchbar.cancleClick = ^{
       [weakSelf updateSearchResultsForSearchBar:weakSelf.ztsearchbar];
    };
    self.dataSource = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(44);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:SelectSourceCell.class forCellReuseIdentifier:@"SelectSourceCell"];
    self.tableView.tableHeaderView = self.ztsearchbar;
    
    [[_ztsearchbar.tf rac_textSignal] subscribeNext:^(id x) {
        [weakSelf updateSearchResultsForSearchBar:weakSelf.ztsearchbar];
    }];
    [self loadFromDB];
    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(BaseReturnModel *model) {
        [self loadFromDB];
    }];
}
- (void)loadFromDB {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:@[@{@"name":@"全部云服务",@"id":@"ALL"},@{@"name":@"<无云服务>"}]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceList];
        dispatch_async_on_main_queue(^{
            
            if (array.count > 0) {
                [self.dataSource addObjectsFromArray:array];
                [self.results removeAllObjects];
                [self.results addObjectsFromArray:self.dataSource];
                [self.tableView reloadData];
            }
            
        });
        
    });
}
- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchBar:(ZTSearchBar *)searchBar{
    NSString *inputStr = searchBar.tf.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    //排除直接点击searchbar显示问题
    if (inputStr == nil || inputStr.length == 0){
        [self.results addObjectsFromArray:self.dataSource];
        [self.tableView reloadData];
        return;
    }
    [self.dataSource enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
       NSString *name =[obj stringValueForKey:@"name" default:@""];
        if (name != nil &&[name rangeOfString:inputStr].location != NSNotFound) {
            [self.results addObject:obj];
        }
    }];
    [self.tableView reloadData];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        SelectSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectSourceCell"];
        cell.source = self.results[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSError *error;
    SourceModel *model = [[SourceModel alloc]initWithDictionary:self.results[indexPath.row] error:&error];
    if (self.itemClick) {
        self.itemClick(model);
    }
    [self.navigationController popViewControllerAnimated:YES];    
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
