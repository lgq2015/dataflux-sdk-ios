//
//  PersonalInfoVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "ChangeUserInfoVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
@interface PersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self createUI];
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    NSString *emailText =  userManager.curUserInfo.email ==nil? @"去绑定":userManager.curUserInfo.email;
    NSString *phoneText = userManager.curUserInfo.mobile ;
    NSString *nameText = userManager.curUserInfo.username==nil? phoneText:userManager.curUserInfo.username;
    MineCellModel *icon = [[MineCellModel alloc]initWithTitle:@"头像"];
    MineCellModel *name = [[MineCellModel alloc]initWithTitle:@"姓名" describeText:nameText];
    MineCellModel *phone = [[MineCellModel alloc]initWithTitle:@"手机号" describeText:phoneText];
    MineCellModel *email = [[MineCellModel alloc]initWithTitle:@"邮箱" describeText:emailText];

    NSArray *array =@[icon,name,phone,email];
    [self.dataSource addObjectsFromArray:array];
    self.tableView.frame = CGRectMake(0, 5, kWidth, self.dataSource.count*45);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, Interval(16), 0, 0);
    [self.tableView reloadData];
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    [self.view addSubview:self.tableView];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    
    if (indexPath.row==0 ) {
        [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeTitle];
    }else {
        [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypedDescribe];
    }
    
    if (indexPath.row == self.dataSource.count-1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
    }
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if(indexPath.row == 1){
        
    }else if(indexPath.row == 2){
        ChangeUserInfoVC *change = [[ChangeUserInfoVC alloc]init];
        change.type = ChangeUITPhoneNumber;
        change.isShowCustomNaviBar = YES;
        [self.navigationController pushViewController:change animated:YES];
    }else{
        ChangeUserInfoVC *change = [[ChangeUserInfoVC alloc]init];
        change.type = ChangeUITEmail;
        change.isShowCustomNaviBar = YES;
        [self.navigationController pushViewController:change animated:YES];
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
