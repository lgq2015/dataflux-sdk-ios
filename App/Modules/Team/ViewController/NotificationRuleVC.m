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
#import "TouchLargeButton.h"
#import "SelectNotiRuleTypeView.h"
@interface NotificationRuleVC ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *customDataSource;
@property (nonatomic, strong) NSMutableArray *dingDataSource;
@property (nonatomic, strong) NSMutableArray *basicDataSource;
@property (nonatomic, assign) NotiRuleStyle ruleStyle;
@property (nonatomic, strong) TouchLargeButton *titleBtn;
@property (nonatomic, strong) SelectNotiRuleTypeView *selectView;
@end

@implementation NotificationRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = NSLocalizedString(@"local.notificationRule", @"");
    [self createUI];
    self.dataSource = [NSMutableArray new];
    self.customDataSource = [NSMutableArray new];
    self.basicDataSource = [NSMutableArray new];
    self.dingDataSource = [NSMutableArray new];
      self.currentPage = 1;
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    self.ruleStyle = NotiRuleBasic;
    self.navigationItem.titleView = self.titleBtn;
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
    AddNotiRuleVC *addRule = [[AddNotiRuleVC alloc]initWithStyle:AddNotiRuleAdd ruleStyle:self.ruleStyle];
    WeakSelf
    addRule.refreshList = ^{
        [weakSelf headerRefreshing];
    };
    [self.navigationController pushViewController:addRule animated:YES];
}
- (void)loadData{
    NSMutableArray *array ;
    switch (self.ruleStyle) {
        case NotiRuleBasic:
            array = self.basicDataSource;
            break;
        case NotiRuleDing:
            array = self.dingDataSource;
            break;
        case NotiRuleCustom:
            array = self.customDataSource;
            break;
    }
    [SVProgressHUD show];
    [[PWHttpEngine sharedInstance] getNotificationRuleListWithRuleStyle:self.ruleStyle page:self.currentPage callBack:^(id response) {
        [self endRefreshing];
        [SVProgressHUD dismiss];
        NotiRuleListModel *model = response;
        if (model.isSuccess) {
            if (self.currentPage == 1) {
                [array removeAllObjects];
            }
            [array addObjectsFromArray:model.list];
            if (model.list.count == 0 && self.currentPage==1) {
                [self showNoDataImage];
            }else{
            if(model.list.count<10 ){
                [self removeNoDataImage];
                [self showNoMoreDataFooter];
            }else{
            self.currentPage ++;
            }
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
            }
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
}
-(TouchLargeButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn =[[TouchLargeButton alloc]init];
        _titleBtn.largeWidth = 20;
        _titleBtn.largeHeight = 14;
        [_titleBtn setTitle:NSLocalizedString(@"local.BasicNotificationRule", @"") forState:UIControlStateNormal];
        [_titleBtn setTitleColor:PWBlackColor forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = MediumFONT(18);
       
        [_titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtn setImage:[UIImage imageNamed:@"arrow_downs"] forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"arrow_ups"] forState:UIControlStateSelected];
        [_titleBtn sizeToFit];
        
        _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_titleBtn.imageView.frame.size.width - _titleBtn.frame.size.width + _titleBtn.titleLabel.frame.size.width, 0, 0);
        
        _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_titleBtn.titleLabel.frame.size.width - _titleBtn.frame.size.width + _titleBtn.imageView.frame.size.width);
        
    }
    return _titleBtn;
}
- (SelectNotiRuleTypeView *)selectView{
    if (!_selectView) {
        _selectView = [[SelectNotiRuleTypeView alloc]initWithTop:kTopHeight];
        WeakSelf
        _selectView.selectClick = ^(NotiRuleStyle style){
            weakSelf.ruleStyle = style;
            switch (style) {
                case NotiRuleBasic:
                    [weakSelf.titleBtn setTitle:NSLocalizedString(@"local.BasicNotificationRule", @"") forState:UIControlStateNormal];
                    break;
                case NotiRuleDing:
                    [weakSelf.titleBtn setTitle:NSLocalizedString(@"local.DingNotificationRule", @"") forState:UIControlStateNormal];
                    break;
                case NotiRuleCustom:
                    [weakSelf.titleBtn setTitle:NSLocalizedString(@"local.CustomNotificationRule", @"") forState:UIControlStateNormal];
                    break;
            }
            [weakSelf.titleBtn sizeToFit];
            weakSelf.titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -weakSelf.titleBtn.imageView.frame.size.width - weakSelf.titleBtn.frame.size.width + weakSelf.titleBtn.titleLabel.frame.size.width, 0, 0);
            
            weakSelf.titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -weakSelf.titleBtn.titleLabel.frame.size.width - weakSelf.titleBtn.frame.size.width + _titleBtn.imageView.frame.size.width);
            [weakSelf switchNotiRuleStyle];
        };
        _selectView.disMissClick = ^(void){
            weakSelf.titleBtn.selected = NO;
        };
    }
    return _selectView;
}
-(void)switchNotiRuleStyle{
    self.currentPage = 1;
    [self loadData];
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
- (void)titleBtnClick{
    self.titleBtn.selected = !self.titleBtn.selected;
    if(self.selectView.isShow){
        [self.selectView disMissView];
    }else{
        [self.selectView showInView:[UIApplication sharedApplication].keyWindow notiRuleStyle:self.ruleStyle];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    if (self.selectView.isShow) {
        [self.selectView disMissView];
    }
}
- (void)delectRule:(NSInteger)index{

        NotiRuleModel *model = self.dataSource[index];
        NSString *ruleId =model.ruleId;
        [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] deleteNotificationRuleWithRuleId:ruleId callBack:^(id response) {
            BaseReturnModel *model = response;
            if (model.isSuccess||[model.errorCode isEqualToString:@"home.team.notificationRuleNotExists"]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.SuccessfullyDeleted", @"")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self headerRefreshing];
                });
            }else{
                [SVProgressHUD dismiss];
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
    
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
    cell.ruleStyle = self.ruleStyle;
    cell.model = self.dataSource[indexPath.row];
   
    
   WeakSelf
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"local.delete", @"") icon:[UIImage imageNamed:@"team_trashcan"] backgroundColor:[UIColor colorWithHexString:@"#F6584C"]padding:10 callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
         [weakSelf delectRule:indexPath.row];
        return NO;
    }];
    button.titleLabel.font = RegularFONT(14);
    [button centerIconOverTextWithSpacing:5];

    cell.rightButtons = @[button];
    cell.delegate = self;
   
    cell.tag = indexPath.row+1;
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
    AddNotiRuleViewStyle style;
    style = [self handlePermissonWithModel:self.dataSource[indexPath.row]]?AddNotiRuleEdit:AddNotiRuleLookOver;
    AddNotiRuleVC *detailVC = [[AddNotiRuleVC alloc]initWithStyle:style ruleStyle:self.ruleStyle];
    detailVC.sendModel = self.dataSource[indexPath.row];
    WeakSelf
    detailVC.refreshList = ^{
        [weakSelf headerRefreshing];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

-(BOOL)swipeTableCell:(nonnull MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point{
 return  [self handlePermissonWithModel:self.dataSource[cell.tag-1]];
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
