//
//  ServiceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "ServiceVC.h"

@interface ServiceVC ()

@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.backgroundColor = PWBackgroundColor;
    [self setRefreshHeader];
    // Do any additional setup after loading the view.
}
- (void)headerRereshing{
    [self.mainScrollView.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
