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

@interface ToolsVC ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ToolsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小工具";
    [self createUI];
}
- (void)createUI{
    switch (self.type) {
        case PWToolTypeIP:
            self.title = @"IP 查询";
            break;
        case PWToolTypeDNS:
            self.title = @"DNS 查询";
            break;
        case PWToolTypePing:
            self.title = @"Ping 查询";
            break;
        case PWToolTypeWhois:
            self.title = @"whois 查询";
            break;
        case PWToolTypeNslookup:
            self.title = @"nslook 查询";
            break;
        case PWToolTypeTraceroute:
            self.title = @"路由追踪";
            break;
        case PWToolTypePortDetection:
            self.title = @"端口检测";
            break;
        case PWToolTypeWebsiteRecord:
            self.title = @"备案查询";
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
