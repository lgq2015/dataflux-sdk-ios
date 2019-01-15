//
//  ToolsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ToolsVC.h"
#import "MineCellModel.h"
#import "MineViewCell.h"

@interface ToolsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ToolsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小工具";
    [self createUI];
}
- (void)createUI{
    MineCellModel *whois = [[MineCellModel alloc]initWithTitle:@"Whois查询" toolType:MineToolTypeWhois];
    MineCellModel *websiteRecord = [[MineCellModel alloc]initWithTitle:@"网站备案查询" toolType:MineToolTypeWebsiteRecord];
    MineCellModel *ip = [[MineCellModel alloc]initWithTitle:@"IP查询" toolType:MineToolTypeIP];
    MineCellModel *ping = [[MineCellModel alloc]initWithTitle:@"Ping检测" toolType:MineToolTypePing];
    MineCellModel *dns = [[MineCellModel alloc]initWithTitle:@"DNS查询" toolType:MineToolTypeDNS];
    MineCellModel *nslookup = [[MineCellModel alloc]initWithTitle:@"nslookup查询" toolType:MineToolTypeNslookup];
    MineCellModel *traceroute =[[MineCellModel alloc]initWithTitle:@"路由追踪" toolType:MineToolTypeTraceroute];
    MineCellModel *port = [[MineCellModel alloc]initWithTitle:@"端口检测" toolType:MineToolTypePortDetection];
    MineCellModel *ssh = [[MineCellModel alloc]initWithTitle:@"在线SSH" toolType:MineToolTypeSSH];
    self.dataSource = [NSMutableArray arrayWithArray:@[whois,websiteRecord,ip,ping,dns,nslookup,traceroute,port,ssh]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    [self.view addSubview:self.tableView];
    
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeTitle];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCellModel *model = self.dataSource[indexPath.row];
    switch (model.toolType) {
        case MineToolTypePortDetection:{
            
        }
            break;
        case MineToolTypeTraceroute:
            break;
        case MineToolTypeNslookup:
            break;
        case MineToolTypeDNS:
            break;
        case MineToolTypePing:
            break;
        case MineToolTypeIP:
            break;
        case MineToolTypeWebsiteRecord:
            break;
        case MineToolTypeWhois:
            break;
        case MineToolTypeSSH:
            break;
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
