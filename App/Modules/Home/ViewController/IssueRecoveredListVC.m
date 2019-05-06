//
//  IssueRecoveredListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueRecoveredListVC.h"
#import "IssueCell.h"
#import "IssueDetailVC.h"
#import "IssueProblemDetailsVC.h"
#import "HLSafeMutableArray.h"
#import "IssueListManger.h"

@interface IssueRecoveredListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) HLSafeMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageMaker;
@property (nonatomic, strong) IssueCell *tempCell;
@property (nonatomic, strong) UIView *recoverFooterView;
@end

@implementation IssueRecoveredListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"过去 24 小时恢复的情报";
    [kNotificationCenter addObserver:self
                            selector:@selector(recoveredOnNewIssueUpdate:)
                                name:KNotificationNewIssue
                              object:nil];
    [kNotificationCenter addObserver:self
                            selector:@selector(recoveredOnNewIssueUpdate:)
                                name:KNotificationUpdateIssueList
                              object:nil];
    [self createUI];
}
- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = self.header;
//    self.tableView.mj_footer = self.footer;
    self.tableView.tableFooterView = self.footView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[IssueCell class] forCellReuseIdentifier:@"IssueCell"];
    self.tempCell = [[IssueCell alloc] initWithStyle:0 reuseIdentifier:@"IssueCell"];
    NSArray *data = [[IssueListManger sharedIssueListManger] getRecoveredIssueListWithIssueType:self.type];
    if (data.count>0) {
        [data enumerateObjectsUsingBlock:^(IssueModel *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:dict];
            [self.dataSource addObject:model];
        }];
        [self.tableView reloadData];
    }else{
        [self showNoDataViewWithStyle:NoDataViewLastDay];
    }
    
}
- (void)recoveredOnNewIssueUpdate:(NSNotification *)notification{
    NSDictionary *pass = [notification userInfo];
    if ([pass boolValueForKey:@"updateView" default:NO]) {
        [self headerRefreshing];
    }
}
- (void)noDataBtnClick{
    
}
-(void)headerRefreshing{
    NSArray *data = [[IssueListManger sharedIssueListManger] getRecoveredIssueListWithIssueType:self.type];
    [self.header endRefreshing];
    if (data.count>0) {
        [self.dataSource removeAllObjects];
        [data enumerateObjectsUsingBlock:^(IssueModel *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            IssueListViewModel *model = [[IssueListViewModel alloc]initWithJsonDictionary:dict];
            [self.dataSource addObject:model];
        }];
        [self.tableView reloadData];
    }else{
        [self showNoDataViewWithStyle:NoDataViewLastDay];
    }
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [HLSafeMutableArray new];
    }
    return _dataSource;
}
-(UIView *)recoverFooterView{
    if (!_recoverFooterView) {
        _recoverFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        _recoverFooterView.backgroundColor = PWBackgroundColor;
        UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"DDDDDD"]]];
        line.frame = CGRectMake(0, 60-ZOOM_SCALE(20), kWidth, 1);
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        btn.titleLabel.font = RegularFONT(13);
        btn.titleLabel.textColor =PWSubTitleColor;
        btn.backgroundColor = PWBackgroundColor;
        NSString *title = @"想要查看过去全部的情报？进入日历";
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:title];
        NSRange range = [title rangeOfString:@"进入日历"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = PWBlueColor;
        //赋值
        [attribut addAttributes:dic range:range];
        [btn setAttributedTitle:attribut forState:UIControlStateNormal];
        [btn sizeToFit];
        [_recoverFooterView addSubview:line];
        [_recoverFooterView addSubview:btn];
        CGFloat width = btn.frame.size.width;
        [btn addTarget:self action:@selector(noDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(line);
            make.height.offset(ZOOM_SCALE(20));
            make.width.offset(width+10);
        }];
    }
    return _recoverFooterView;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell"];
    cell.model = self.dataSource[indexPath.row];
    cell.backgroundColor = PWWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.dataSource[indexPath.row];
    model.isRead = YES;
    if (model.isFromUser) {
        IssueProblemDetailsVC *detailVC = [[IssueProblemDetailsVC alloc]init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        IssueDetailVC *infodetial = [[IssueDetailVC alloc]init];
        infodetial.model = model;
        [self.navigationController pushViewController:infodetial animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueListViewModel *model =self.dataSource[indexPath.row];
    if (model.cellHeight == 0 || !model.cellHeight) {
        CGFloat cellHeight = [self.tempCell heightForModel:self.dataSource[indexPath.row]];
        // 缓存给model
        model.cellHeight = cellHeight;
        
        return cellHeight;
    } else {
        return model.cellHeight;
    }
}
-(void)dealloc{
    [kNotificationCenter postNotificationName:KNotificationUpdateIssueList object:nil];
    [kNotificationCenter postNotificationName:KNotificationNewIssue object:nil];

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
