//
//  ServiceDetailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ServiceDetailVC.h"
#import "FillinTeamInforVC.h"
#import "BookSuccessVC.h"
#import "ServiceDetailVC+ChangeNavColor.h"
//#import "UIViewController+ChangeNavBarColor.h"
@interface ServiceDetailVC ()<UIScrollViewDelegate>

@end

@implementation ServiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.isShowWhiteBack = YES;
    self.webView.scrollView.bounces = YES;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(-kStatusBarHeight, 0, 0, 0);
}
- (void)createUI{
    self.view.backgroundColor = PWBlueColor;
    if (self.isHidenNaviBar) {
        self.webView.frame = self.view.bounds;
        DLog(@"self offic = %@",NSStringFromCGPoint(self.webView.scrollView.contentOffset));
        DLog(@"self frame = %@",NSStringFromCGRect(self.webView.scrollView.frame));
    }
    [self.view bringSubviewToFront:self.whiteBackBtn];
    if (self.isShowCustomNaviBar){
        [self initTopNavBar];
    }
}
- (void)eventTeamCreate:(NSDictionary *)extra{
    FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
    [self.navigationController pushViewController:createTeam animated:YES];
}
-(void)eventBookSuccess:(NSDictionary *)extra{
    BookSuccessVC *successVC = [[BookSuccessVC alloc]init];
    [self presentViewController:successVC animated:YES completion:nil];
}

#pragma mark ====导航栏的显示和隐藏====
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self zt_changeColor:[UIColor whiteColor] scrolllView:scrollView];
}
- (void)initTopNavBar{
    [self.topNavBar setFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
    self.topNavBar.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.topNavBar];
    [self.topNavBar addBottomSepLine];
}
@end
