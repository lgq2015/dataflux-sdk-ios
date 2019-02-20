//
//  SecurityPrivacyVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SecurityPrivacyVC.h"
#import "MineCellModel.h"
#import "MineViewCell.h"
#import "ChangeUserInfoVC.h"
@interface SecurityPrivacyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SecurityPrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全与隐私";
    [self createUI];
}
- (void)createUI{
    MineCellModel *changeWord = [[MineCellModel alloc]initWithTitle:@"修改密码"];
//    MineCellModel *serviceContract = [[MineCellModel alloc]initWithTitle:@"服务协议"];
    MineCellModel *privacyPolicy = [[MineCellModel alloc]initWithTitle:@"隐私权政策"];
    NSArray *group1 = @[changeWord];
    NSArray *group2 =@[privacyPolicy];
    self.dataSource = [NSArray new];
    self.dataSource = @[group1,group2];
    self.tableView.rowHeight = ZOOM_SCALE(45);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,Interval(16), 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    [self.view addSubview:self.tableView];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arry = [self.dataSource objectAtIndex:section];
    if (arry&&arry.count) {
        return arry.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeTitle];
    NSArray *array =self.dataSource[indexPath.section];
    if(indexPath.row == array.count-1){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
    }
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         //修改密码
        ChangeUserInfoVC *changeVC = [[ChangeUserInfoVC alloc]init];
        changeVC.isHidenNaviBar = YES;
        changeVC.isShowCustomNaviBar = YES;
         changeVC.type = ChangeUITPassword;
        [self.navigationController pushViewController:changeVC animated:YES];
    }else{
        if (indexPath.row == 0) {
         //服务协议
        }else{
         //隐私权政策
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 12)];
    //自定义颜色
    view.backgroundColor = PWBackgroundColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
@end
