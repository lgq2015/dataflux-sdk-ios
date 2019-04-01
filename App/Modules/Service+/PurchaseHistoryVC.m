//
//  PurchaseHistoryVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PurchaseHistoryVC.h"

@interface PurchaseHistoryVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
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
            NSDictionary *content = response[@"content"];
            NSArray *elements = content[@"elements"];
            [self.dataSource addObjectsFromArray:elements];
        }else{
            
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)createUI{
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.rowHeight = ZOOM_SCALE(45)+Interval(60);
    [self.view addSubview:self.tableView];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
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
