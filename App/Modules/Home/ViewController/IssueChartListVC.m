//
//  IssueChartListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartListVC.h"
#import "ClassifyModel.h"
#import "IssueCell.h"
#import "IssueListManger.h"
#import "IssueListViewModel.h"
#import "IssueDetailsVC.h"
#import "IssueSelectHeaderView.h"
@interface IssueChartListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *issueData;
@property (nonatomic, strong) SelectObject *currentSelect;

@end

@implementation IssueChartListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    
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
