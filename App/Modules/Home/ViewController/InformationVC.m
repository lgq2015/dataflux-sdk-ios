//
//  InformationVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "InformationVC.h"
#import "PWInfoBoard.h"
#import "HomeNoticeScrollView.h"
@interface InformationVC ()

@end

@implementation InformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.backgroundColor = PWBackgroundColor;
    [self setRefreshHeader];
    [self createUI];
}
- (void)createUI{
    PWInfoBoard *infoboard = [[PWInfoBoard alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(394)) style:PWInfoBoardStyleNotConnected];
    [self.mainScrollView addSubview:infoboard];
    HomeNoticeScrollView *notice = [[HomeNoticeScrollView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(400), kWidth, ZOOM_SCALE(60))];
    [self.mainScrollView addSubview:notice];

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
