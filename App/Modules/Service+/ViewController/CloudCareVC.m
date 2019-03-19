//
//  CloudCareVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CloudCareVC.h"
#import "PurchaseHistoryVC.h"
#import "ServiceDetailVC.h"

@interface CloudCareVC ()
@end

@implementation CloudCareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
   
   self.webView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-kTopHeight);
    [self addNavigationItemWithTitles:@[@"购买记录"] isLeft:NO target:self action:@selector(navRightBtnClick) tags:@[@11]];
}
- (void)navRightBtnClick{
    PurchaseHistoryVC *order = [[PurchaseHistoryVC alloc]init];
    [self.navigationController pushViewController:order animated:YES];
}
-(void)eventOfOpenWithExtra:(NSDictionary *)extra{
    NSString *url = extra[@"url"];
    BOOL hideTitleWhenScroll = extra[@"hideTitleWhenScroll"];
    BOOL isOverLayTitleBar = extra[@"isOverLayTitleBar"];
    ServiceDetailVC *detailVC = [[ServiceDetailVC alloc]initWithURL:[NSURL URLWithString:url]];
    detailVC.hideTitleWhenScroll = hideTitleWhenScroll;
    if (isOverLayTitleBar) {
        detailVC.isHidenNaviBar = YES;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
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
