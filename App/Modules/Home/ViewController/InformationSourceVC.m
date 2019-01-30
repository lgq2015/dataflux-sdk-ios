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
    [self loadData];
}
- (void)createUI{
    NSArray *title = @[@"添加"];
    [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
    NSArray *data = self.response[@"content"][@"data"];
    self.dataSource = [NSMutableArray arrayWithArray:data];
//    NSArray *array = @[@{@"icon":@"",@"title":@"我的阿里云",@"state":@1,@"type":@1},@{@"icon":@"",@"title":@"www.cloudcare.cn",@"state":@2,@"type":@8},@{@"icon":@"",@"title":@"oa-web-02",@"state":@3,@"type":@6},@{@"icon":@"",@"title":@"oa-web-02",@"state":@3,@"type":@5},@{@"icon":@"",@"title":@"cloudcare.cn",@"state":@1,@"type":@7},@{@"icon":@"",@"title":@"http://www.skghak.com.cn/chart.php",@"state":@2,@"type":@9}];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.rowHeight = 100.f;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[InformationSourceCell class] forCellReuseIdentifier:@"InformationSourceCell"];
}
- (void)loadData{
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        DLog(@"%@",response);
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *dict = response[@"content"];
            NSArray *data = dict[@"data"];
            if (data.count>0) {
            }
        }else if([response[@"errCode"] isEqualToString:@"home.auth.unauthorized"]){
        }
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
    }];
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
    
    cell.model = [[PWInfoSourceModel alloc]initWithJsonDictionary:self.dataSource[indexPath.row]];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     InformationSourceCell *cell = (InformationSourceCell *)[tableView cellForRowAtIndexPath:indexPath];
    SourceVC *source = [[SourceVC alloc]init];
    source.model = cell.model;
    source.isAdd = NO;
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
