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
#import "ProblemDetailsVC.h"

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
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MonitorCell class] forCellReuseIdentifier:@"MonitorCell"];
    self.tempCell = [[MonitorCell alloc] initWithStyle:0 reuseIdentifier:@"MonitorCell"];
    NSArray *array = @[@{@"title":@"您的 ECS 还有5天过期几几年就能了立刻就看两节课老家看了",@"time":@"30分钟前",@"state":@"1",@"suggestion":@"张三：可能需要寻求协助，大家意见保持保持保持保…",@"attrs":@"仅剩5天过期"},@{@"title":@"您的 ECS 还有5天过期\n您的 ECS 还有5天",@"time":@"30分钟前",@"state":@"2",@"suggestion":@"张三：可能需要寻求协助，大家意见保持保持保持保…",@"attrs":@"仅剩5天过期"},@{@"title":@"您的 ECS 还有5天过期",@"time":@"30分钟前",@"state":@"3",@"suggestion":@"张三：可能需要寻求协助，大家意见保持保持保持保…",@"attrs":@"仅剩5天过期"},@{@"title":@"您的 ECS 还有5天过期您的 ECS 还有5天过期几几年就能了立您的 ECS 还有5天过期几几年就能了立您的 ECS 还有5天过期几几年就能了立您的 ECS 还有5天过期几几年就能了立您的 ECS 还有5天过期几几年就能了立",@"time":@"30分钟前",@"state":@"4",@"suggestion":@"张三：可能需要寻求协助，大家意见保持保持保持保…"}];
    self.dataSource = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        NSError *error;
        MonitorListModel *model = [[MonitorListModel alloc]initWithDictionary:dict error:&error];
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
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
    cell.model = self.dataSource[indexPath.row];
    cell.backgroundColor = PWWhiteColor;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProblemDetailsVC *detailVC = [[ProblemDetailsVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorListModel *model =self.dataSource[indexPath.row];
    if (model.cellHeight == 0 || !model.cellHeight) {
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
