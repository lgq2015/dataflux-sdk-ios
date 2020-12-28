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
#import "AboutUsVC.h"
#import "SecurityPrivacyVC.h"
#import "ClearCacheTool.h"
#import "PrivacySecurityControls.h"
#import "ZhugeIOMineHelper.h"
#import <FTMobileAgent.h>
@interface SettingUpVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong)  UIButton *exitBtn;
@end

@implementation SettingUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.SettingUp", @"");
    [self createUI];
    [self calculateStorage];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchBtnUpdate)
                                                 name:KNotificationAppResignActive
                                               object:nil];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    BOOL isSwitch=  [self checkNotification];
    self.dataSource = [NSMutableArray new];
    MineCellModel *changePassword = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.SecurityAndPrivacy", @"")];

    MineCellModel *notification = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.notification", @"") isSwitch:isSwitch];
    MineCellModel *aboutUs = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.ClearCache", @"") describeText:@""];

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
        make.left.mas_equalTo(self.view).offset(36);
        make.right.mas_equalTo(self.view).offset(-36);
        make.height.offset(ZOOM_SCALE(44));
    }];
   
}
- (BOOL)checkNotification{
    BOOL canNoti=  [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone;
    if (canNoti == YES ) {
        return NO;
    }else{
        if(getUserNotificationSettings == nil){
        BOOL userNoti =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            userNoti == YES?setUserNotificationSettings(PWRegister):setUserNotificationSettings(PWUnRegister);
        return userNoti;
        }else{
             BOOL userNoti =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            return [getUserNotificationSettings isEqualToString:PWRegister];
        }
    }
}
- (void)switchBtnUpdate{
    BOOL isSwitch = [self checkNotification];
    if (self.tableView) {
        NSIndexPath *index= [NSIndexPath indexPathForRow:1 inSection:0];
        __block  MineViewCell *cell = (MineViewCell *)[self.tableView cellForRowAtIndexPath:index];
            [cell setSwitchBtnisOn:isSwitch];
    }
}
- (void)calculateStorage{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

    NSString *totalSize = [ClearCacheTool getCacheSizeWithFilePath:path];
    
    DLog(@"%@",totalSize);
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
    MineViewCell *cell = (MineViewCell *)[self.tableView cellForRowAtIndexPath:index];
    [cell setDescribeLabText:totalSize];
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc]init];
        [_exitBtn setBackgroundColor:PWBlueColor];
        [_exitBtn setTitle:NSLocalizedString(@"local.SignOut", @"") forState:UIControlStateNormal];
        _exitBtn.layer.cornerRadius = 4.0f;
        [_exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exitBtn];
    }
    return _exitBtn;
}
- (void)exitBtnClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"local.tip.logoutJudgeTip", @"") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[[[ZhugeIOMineHelper new] eventLoginOut] attrResultCancel] track];
    }];
    UIAlertAction *confim = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.verify", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //发送退出登录请求，让后台清空存储的token
        [[[[ZhugeIOMineHelper new] eventLoginOut] attrResultLogout] track];

        [self requestLoginOut];
                [[UserManager sharedUserManager]logout:^(BOOL success, NSString *des) {

                }];
            }];
    [alert addAction:cancel];
    [alert addAction:confim];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showSwitchChangeAlert:(NSInteger)row isOn:(BOOL)isOn{
    if (isOn) {
        BOOL isSwitch = [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone;
        if (isSwitch) {
            [self privacySecurityControlsAlert];

        } else {
            [[[[ZhugeIOMineHelper new] eventSetNotifySwitch] attrResultReceive] track];

            [[UIApplication sharedApplication] registerForRemoteNotifications];
            setUserNotificationSettings(PWRegister);
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"local.tip.closeNotiTip", @"") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.ConfirmClosed", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[[[ZhugeIOMineHelper new] eventSetNotifySwitch] attrResultNoReceive] track];
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            setUserNotificationSettings(PWUnRegister);
        }];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        __block MineViewCell *cell = (MineViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [cell setSwitchBtnisOn:YES];
        }];
        [alert addAction:confirm];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)privacySecurityControlsAlert{
    PrivacySecurityControls *privacy = [[PrivacySecurityControls alloc]init];
    privacy.refuseBlock = ^(){
        NSIndexPath *index= [NSIndexPath indexPathForRow:1 inSection:0];
        BOOL isSwitch=  [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone;
        __block  MineViewCell *cell = (MineViewCell *)[self.tableView cellForRowAtIndexPath:index];
        [cell setSwitchBtnisOn:!isSwitch];
    };
    [privacy getPrivacyStatusIsGrantedWithType:PrivacyTypeUserNotification controller:self];
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
                
                    [self showSwitchChangeAlert:indexPath.row isOn:isOn];
                
            };
        }else{
            [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypedDescribe];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
        }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [[[ZhugeIOMineHelper new] eventClickSecurityPrivacy] track];

        SecurityPrivacyVC *securityVC = [[SecurityPrivacyVC alloc]init];
        [self.navigationController pushViewController:securityVC animated:YES];
    }else if(indexPath.row == 2){
        UIAlertController *cleanAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"local.tip.cleanUpTip", @"") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.verify", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            [ClearCacheTool clearCacheWithFilePath:path];
            NSString *totalSize = [ClearCacheTool getCacheSizeWithFilePath:path];
            DLog(@"%@", totalSize);
            NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
            MineViewCell *cell = (MineViewCell *) [self.tableView cellForRowAtIndexPath:index];
            [cell setDescribeLabText:totalSize];

            [[[ZhugeIOMineHelper new] eventClearCache] track];
        }];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [cleanAlert addAction:confirm];
        [cleanAlert addAction:cancle];
        [self presentViewController:cleanAlert animated:YES completion:nil];
    }else if(indexPath.row == 3){

    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---登出请求---
- (void)requestLoginOut{
    [PWNetworking requsetHasTokenWithUrl:PW_loginOut withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:nil failBlock:nil];
}

@end
