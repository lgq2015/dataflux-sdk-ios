//
//  AboutUsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AboutUsVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"

@interface AboutUsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self createUI];
}
- (void)createUI{
    MineCellModel *service = [[MineCellModel alloc]initWithTitle:@"服务协议"];
    MineCellModel *privacy = [[MineCellModel alloc]initWithTitle:@"隐私权政策"];
    MineCellModel *newVersion = [[MineCellModel alloc]initWithTitle:@"检测新版本"];
    MineCellModel *encourage = [[MineCellModel alloc]initWithTitle:@"鼓励我们"];
    self.dataSource = [NSMutableArray arrayWithArray:@[service,privacy,newVersion,encourage]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 100, kWidth, self.dataSource.count*45);
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            [[AppDelegate shareAppDelegate] DetectNewVersion];
            break;
        case 3:
            [self evaluateSkip];
            break;
        default:
            break;
    }
}
- (void)evaluateSkip{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE_AFTER_IOS11]];
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE]];
#endif
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeTitle];
    return cell;
}


@end
