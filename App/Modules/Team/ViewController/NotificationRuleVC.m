//
//  NotificationRuleVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NotificationRuleVC.h"
#import "AddNotiRuleVC.h"
#import "BaseListReturnModel.h"
#import "NotiRuleModel.h"
#import "NotiRuleCell.h"
#import "NotiRuleListModel.h"
#import "TeamInfoModel.h"
@interface NotificationRuleVC ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation NotificationRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.notificationRule", @"");
    [self createUI];
    self.dataSource = [NSMutableArray new];
      self.currentPage = 1;
    [self loadData];
    [kNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:KNotificationReloadRuleList object:nil];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    [self addNavigationItemWithTitles:@[NSLocalizedString(@"local.addNotificationRule", @"")] isLeft:NO target:self action:@selector(navBtnClick) tags:@[@11]];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset =  UIEdgeInsetsMake(12, 0, 0, 0);

    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(80);
    self.tableView.delegate = self;
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:NotiRuleCell.class forCellReuseIdentifier:@"NotiRuleCell"];

}
- (void)navBtnClick{
    AddNotiRuleVC *addRule = [[AddNotiRuleVC alloc]initWithStyle:AddNotiRuleAdd];
    [self.navigationController pushViewController:addRule animated:YES];
}
- (void)loadData{
    [SVProgressHUD show];
    [[PWHttpEngine sharedInstance] getNotificationRuleListWithPage:self.currentPage callBack:^(id response) {
        [self endRefreshing];
        [SVProgressHUD dismiss];
        NotiRuleListModel *model = response;
        if (model.isSuccess) {
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
                
            }
            [self.dataSource addObjectsFromArray:model.list];
            if (model.list.count == 0 && self.currentPage==1) {
                [self showNoDataImage];
            }else{
            if(model.list.count<10 ){
                [self showNoMoreDataFooter];
            }else{
            self.currentPage ++;
            }
            [self.tableView reloadData];
            }
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}


-(void)headerRefreshing{
    self.currentPage = 1;
    [self showLoadFooterView];
    [self loadData];
}
-(void)footerRefreshing{
    [self loadData];
}
- (void)endRefreshing{
    [self.header endRefreshing];
    [self.footer endRefreshing];
}
- (void)delectRule:(NSInteger)index{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您正在进行删除通知规则操作" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NotiRuleModel *model = self.dataSource[index];
        NSString *ruleId =model.ruleId;
        [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] deleteNotificationRuleWithRuleId:ruleId callBack:^(id response) {
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self loadData];
            }else{
                [SVProgressHUD dismiss];
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
       
//    }];
//    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    [alert addAction:confirm];
//    [alert addAction:cancle];
//    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark ========== UITableViewDataSource ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotiRuleModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotiRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotiRuleCell"];
   
    cell.model = self.dataSource[indexPath.row];
   
    if([self handlePermissonWithModel:cell.model]){
   WeakSelf
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"]padding:10 callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
         [weakSelf delectRule:indexPath.row];
        return YES;
    }];
    
    MGSwipeButton *button2 = [MGSwipeButton buttonWithTitle:@"编辑" icon:[UIImage imageNamed:@"icon_edit"] backgroundColor:PWBlueColor padding:10 callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        AddNotiRuleVC *detailVC = [[AddNotiRuleVC alloc]initWithStyle:AddNotiRuleEdit];
        detailVC.sendModel = weakSelf.dataSource[indexPath.row];
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
        return YES;
    }];
    button.titleLabel.font = RegularFONT(14);
    button.tag = indexPath.row +1;
    [button centerIconOverTextWithSpacing:5];
    button2.titleLabel.font = RegularFONT(14);
    button2.tag = indexPath.row +100;
    [button2 centerIconOverTextWithSpacing:5];
    cell.rightButtons = @[button,button2];
    cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (BOOL )handlePermissonWithModel:(NotiRuleModel *)model{
    if (model.isDefault) {
        return NO;
    }
    if (model.teamId&& userManager.teamModel.isAdmin) {
        return YES;
    }
    if (model.accountId && [model.accountId isEqualToString:userManager.curUserInfo.userID]) {
        return YES;
    }
    return NO;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    AddNotiRuleVC *detailVC = [[AddNotiRuleVC alloc]initWithStyle:AddNotiRuleEdit];
//    detailVC.model = self.dataSource[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
-(BOOL)swipeTableCell:(nonnull MGSwipeTableCell *)cell shouldHideSwipeOnTap:(CGPoint) point{
   
    return YES;
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
