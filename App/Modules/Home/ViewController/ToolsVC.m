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
