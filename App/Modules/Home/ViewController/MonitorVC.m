//
//  MonitorVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MonitorVC.h"
#import "MonitorCell.h"
#import "MonitorListModel.h"
#import "CreateQuestionVC.h"
@interface MonitorVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MonitorCell *tempCell;

@end

@implementation MonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"监控";
    
    [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
    [self addNavigationItemWithTitles:@[@"创建问题"] isLeft:NO target:self action:@selector(navBtnClick:) tags:@[@10]];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    [self.tableView registerClass:[MonitorCell class] forCellReuseIdentifier:@"MonitorCell"];
}
- (void)navBtnClick:(UIButton *)btn{
    CreateQuestionVC *creatVC = [[CreateQuestionVC alloc]init];
    [self.navigationController pushViewController:creatVC animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorListModel *model = self.dataSource[indexPath.row];
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:self.dataSource[indexPath.row]];
        // 缓存给model
        model.cellHeight = cellHeight;

        return cellHeight;
    } else {
        return model.cellHeight;
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
