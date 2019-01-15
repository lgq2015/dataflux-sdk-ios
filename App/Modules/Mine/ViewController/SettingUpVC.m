//
//  SettingUpVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/25.
//  Copyright © 2018 hll. All rights reserved.
//

#import "SettingUpVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "UserManager.h"
#import "ChangePasswordVC.h"
#import "AboutUsVC.h"
@interface SettingUpVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SettingUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0, 5, kWidth, kHeight-kTopHeight-5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    MineCellModel *changePassword = [[MineCellModel alloc]initWithTitle:@"修改登录密码"];
    MineCellModel *gesturePassword = [[MineCellModel alloc]initWithTitle:@"手势密码解锁" switch:YES];
    MineCellModel *notification = [[MineCellModel alloc]initWithTitle:@"接收消息通知" switch:NO];
    MineCellModel *aboutUs = [[MineCellModel alloc]initWithTitle:@"关于我们"];
    MineCellModel *quit = [[MineCellModel alloc]initWithTitle:@"退出登录"];
    NSArray *array =@[changePassword,gesturePassword,notification];
    [self.dataSource addObject:[NSArray arrayWithArray:array]];
    [self.dataSource addObject:[NSArray arrayWithObject:aboutUs]];
    [self.dataSource addObject:[NSArray arrayWithObject:quit]];
    [self.tableView reloadData];
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    [self.view addSubview:self.tableView];

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
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
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeTitle];
        }else{
            [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeSwitch];
        }
    }else if (indexPath.section == 1){
        [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeTitle];
    }else{
        [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeButton];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定退出登录吗？" message:@"退出后不会删除内容记录，下次登录依然可以使用本账号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confim = [PWCommonCtrl actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UserManager sharedUserManager]logout:^(BOOL success, NSString *des) {
                
            }];
        }];
        [alert addAction:cancel];
        [alert addAction:confim];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (indexPath.section == 0 && indexPath.row ==0) {
        ChangePasswordVC *changeVC = [[ChangePasswordVC alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    if (indexPath.section == 1){
        AboutUsVC *about = [[AboutUsVC alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
