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
#import "IgnoreListVC.h"
#import "AboutUsVC.h"
#import "SecurityPrivacyVC.h"

@interface SettingUpVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong)  UIButton *exitBtn;
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
    MineCellModel *changePassword = [[MineCellModel alloc]initWithTitle:@"安全与隐私"];
//    MineCellModel *ignore = [[MineCellModel alloc]initWithTitle:@"忽略情报"];
    MineCellModel *notification = [[MineCellModel alloc]initWithTitle:@"消息通知" isSwitch:NO];
    MineCellModel *aboutUs = [[MineCellModel alloc]initWithTitle:@"清除缓存"];
    NSArray *array =@[changePassword,notification,aboutUs];
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

    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(100);
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.offset(ZOOM_SCALE(47));
    }];
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc]init];
        [_exitBtn setBackgroundColor:PWBlueColor];
        [_exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _exitBtn.layer.cornerRadius = 4.0f;
        [_exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exitBtn];
    }
    return _exitBtn;
}
- (void)exitBtnClick{
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
- (void)showSwitchChangeAlert:(NSInteger)row{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关闭后，手机将不再接收新的消息" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
   __block  MineViewCell *cell = (MineViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [cell setSwitchBtnisOn:YES];
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    
        if (indexPath.row==0 ) {
            [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeTitle];
        }else if(indexPath.row == 1){
            [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeSwitch];
            cell.switchChange = ^(BOOL isOn){
                if(!isOn){
                    [self showSwitchChangeAlert:indexPath.row];
                }
            };
        }else{
            [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeTitle];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
        }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SecurityPrivacyVC *securityVC = [[SecurityPrivacyVC alloc]init];
        [self.navigationController pushViewController:securityVC animated:YES];
    }else if(indexPath.row == 2){
        UIAlertController *cleanAlert = [UIAlertController alertControllerWithTitle:@"确定清理所有缓存" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [cleanAlert addAction:confirm];
        [cleanAlert addAction:cancle];
        [self presentViewController:cleanAlert animated:YES completion:nil];
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
