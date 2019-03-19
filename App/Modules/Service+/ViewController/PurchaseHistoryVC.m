//
//  PurchaseHistoryVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PurchaseHistoryVC.h"
#import "OrderListCell.h"
#import "OrderListModel.h"

@interface PurchaseHistoryVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *orderFooterView;
@end

@implementation PurchaseHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买记录";
    [self loadData];
    [self createUI];
}
- (void)loadData{
    self.dataSource = [NSMutableArray new];
    NSDictionary *param = @{@"content":@{@"form":@{@"status":@"Enabled",@"page":@1,@"size":@50}}};
    [PWNetworking requsetHasTokenWithUrl:PW_OrderList withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isKindOfClass:[NSNull class]] || [response[ERROR_CODE] isEqualToString:@""]) {
            if ([response[@"content"] isKindOfClass:NSNull.class]) {
               [self showNoDataImage];
            }else{
            NSDictionary *content = response[@"content"];
            
                NSArray *elements = [content mutableArrayValueForKey:@"elements"];
                if (elements.count>0) {
                    [self.dataSource addObjectsFromArray:elements];
                    [self.tableView reloadData];
                    self.tableView.tableFooterView = self.orderFooterView;
                }else{
                    [self showNoDataImage];
                }
            
            }}else{
            
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)createUI{
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.rowHeight = ZOOM_SCALE(45)+Interval(60);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:OrderListCell.class forCellReuseIdentifier:@"OrderListCell"];
    [self.view addSubview:self.tableView];
    
}
-(UIView *)orderFooterView{
    if (!_orderFooterView) {
        _orderFooterView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(40))];
        _orderFooterView.backgroundColor = PWBackgroundColor;
        UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectMake(0, Interval(20), kWidth, ZOOM_SCALE(17)) font:MediumFONT(12) textColor:[UIColor colorWithHexString:@"#C7C7CC"] text:@"以上所有商品与服务，由上海驻云信息科技有限公司提供支持"];
        tip.textAlignment = NSTextAlignmentCenter;
        [_orderFooterView addSubview:tip];
    }
    return _orderFooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
    NSError *error;
    OrderListModel *model = [[OrderListModel alloc]initWithDictionary:self.dataSource[indexPath.row] error:&error];
    cell.model = model;
    return cell;
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
