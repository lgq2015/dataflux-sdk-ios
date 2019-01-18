//
//  InformationSourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InformationSourceVC.h"
#import "InformationSourceCell.h"
#import "AddSourceVC.h"
#import "SourceVC.h"
@interface InformationSourceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation InformationSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报源";
    [self createUI];
}
- (void)createUI{
    NSArray *title = @[@"添加"];
    [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
    NSArray *array = @[@{@"icon":@"",@"title":@"我的阿里云",@"state":@1},@{@"icon":@"",@"title":@"www.cloudcare.cn",@"state":@2},@{@"icon":@"",@"title":@"oa-web-02",@"state":@3}];
    self.dataSource = [NSMutableArray arrayWithArray:array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.rowHeight = 100.f;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[InformationSourceCell class] forCellReuseIdentifier:@"InformationSourceCell"];
}
- (void)addInfoSource{
    AddSourceVC *addVC = [[AddSourceVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationSourceCell"];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SourceVC *source = [[SourceVC alloc]init];
    source.type = SourceTypeAli;
    [self.navigationController pushViewController:source animated:YES];
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
