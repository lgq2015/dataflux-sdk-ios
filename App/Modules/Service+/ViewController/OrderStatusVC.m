//
//  OrderStatusVC.m
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "OrderStatusVC.h"
#import "ZTOrderListCell.h"
#import "UITableViewCell+ZTCategory.h"
#import "ZTTopCustomTabHeaderView.h"
#import "UIView+PWFrame.h"
#import "RootViewController+ZYChangeNavColor.h"
#import "OrderStatusWithNumAndTime.h"
#import "OrderStatusWithMoneyCell.h"
#import "OrderStatusStepCell.h"
#import "NSString+Regex.h"

@interface OrderStatusVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZTTopCustomTabHeaderView *customHeaderView;
@end

@implementation OrderStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //显示白色返回按钮
    [self.view bringSubviewToFront:self.whiteBackBtn];
    [self.whiteBackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(Interval(32));
    }];
    [self initTopNavBar];
}

- (void)createUI{
    self.title = @"订单列表";
    self.tableView.tableHeaderView = self.customHeaderView;
    self.customHeaderView.orderStatusType = payed_status;
    self.dataSource = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //ios 11 适配
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[OrderStatusWithNumAndTime cellWithNib] forCellReuseIdentifier:[OrderStatusWithNumAndTime cellReuseIdentifier]];
    [self.tableView registerNib:[OrderStatusWithMoneyCell cellWithNib] forCellReuseIdentifier:[OrderStatusWithMoneyCell cellReuseIdentifier]];
    [self.tableView registerClass:[OrderStatusStepCell class] forCellReuseIdentifier:[OrderStatusStepCell cellReuseIdentifier]];
}
#pragma mark ========== UITableViewDataSource ==========
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        OrderStatusWithNumAndTime *cell = (OrderStatusWithNumAndTime *)[tableView dequeueReusableCellWithIdentifier:[OrderStatusWithNumAndTime cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }else if (indexPath.row == 1){
        OrderStatusWithMoneyCell *cell = (OrderStatusWithMoneyCell *)[tableView dequeueReusableCellWithIdentifier:[OrderStatusWithMoneyCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }else{
        OrderStatusStepCell *cell = (OrderStatusStepCell *)[tableView dequeueReusableCellWithIdentifier:[OrderStatusStepCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = nil;
        return  cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 89 + 12;
    }else if (indexPath.row == 1){
        OrderStatusWithMoneyCell *cell = (OrderStatusWithMoneyCell *)[tableView dequeueReusableCellWithIdentifier:[OrderStatusWithMoneyCell cellReuseIdentifier]];
        CGFloat height = [cell caculateRowHeight:nil];
        return height;
    }else{
        return [self getHeight];
    }
}

//获取描述文本高度
- (CGFloat)getHeight{
    NSArray *titles = @[@"上云迁移实施上云迁移实施上云迁移实施上云迁移实施上云迁移实施",@"互联网应用托管服务互联网应用托管服务互联网应用托管服务互联网应用托管服务互联网应用托管服务",@"云资源（消费）-财务倒入云资源（消费）-财务倒入云资源（消费）-财务倒入云资源（消费）-财务倒入云资源（消费）-财务倒入"];
    CGFloat heigth = 0;
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        heigth += [title zt_getHeight:RegularFONT(16) width:kWidth - 16];
    }
    return heigth + (titles.count - 1) * 35 + 20 + 49;
}

#pragma mark ---lazy---
- (ZTTopCustomTabHeaderView *)customHeaderView{
    if (!_customHeaderView){
        _customHeaderView = [[ZTTopCustomTabHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(170))];
    }
    return _customHeaderView;
}

#pragma mark ====导航栏的显示和隐藏====
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self zy_changeColor:[UIColor whiteColor] scrolllView:scrollView];
}
- (void)initTopNavBar{
    self.topNavBar.titleLabel.text = @"支付取消";
    self.topNavBar.titleLabel.textColor = [UIColor clearColor];
    [self.topNavBar setFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
    self.topNavBar.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.topNavBar];
    [self.topNavBar addBottomSepLine];
    self.topNavBar.lineView.hidden = YES;
    self.topNavBar.backBtn.hidden = YES;
}

- (void)dealloc{
    DLog(@"%s",__func__);
}
@end
