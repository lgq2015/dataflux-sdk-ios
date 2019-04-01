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
    UIImageView *logo_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_care_logo_icon"]];
    UIImageView *logo_text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_care_logo_text"]];


    self.navigationController.title =@"";
    self.navigationItem.titleView = [UIView new];

    [self.navigationItem.titleView addSubview:logo_text];

    [logo_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.navigationItem.titleView);
    }];

    [self.navigationItem.titleView addSubview:logo_icon];

    [logo_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.navigationItem.titleView);
        make.right.mas_equalTo(logo_text.mas_left).offset(0);

    }];
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
