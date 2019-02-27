//
//  ChooseTradesVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChooseTradesVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
@interface ChooseTradesVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ChooseTradesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择行业";
    [self createUI];
    [self loadTradesData];
}
- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = ZOOM_SCALE(45);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    self.tableView.frame = CGRectMake(0, Interval(12),kWidth, kHeight-kTopHeight-Interval(12));
}
- (void)loadTradesData{
    self.dataSource = [NSMutableArray new];
    [SVProgressHUD show];
    NSDictionary *param = @{@"keys":@"industry"};
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content  =response[@"content"];
            [self.dataSource addObjectsFromArray:content[@"industry"]];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    NSDictionary *displayName = self.dataSource[indexPath.row][@"displayName"];
    MineCellModel *model = [[MineCellModel alloc]initWithTitle:displayName[@"zh_CN"]];
    [cell initWithData:model type:MineVCCellTypeOnlyTitle];
    if(indexPath.row == self.dataSource.count-1){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *displayName = self.dataSource[indexPath.row][@"displayName"];
    NSString *name = displayName[@"zh_CN"];
    if (self.itemClick) {
        self.itemClick(name);
        [self.navigationController popViewControllerAnimated:YES];
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
