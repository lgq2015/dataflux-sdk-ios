//
//  HomeViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "HomeViewController.h"
#import "PWScrollPageView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    [self createUI];
}
- (void)createUI{
    PWSegmentStyle *style = [[PWSegmentStyle alloc]init];
    style.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
    style.selectTitleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 24];
    style.selectedTitleColor = [UIColor colorWithRed:255/255.0 green:78/255.0 blue:0/255.0 alpha:1.0];
    style.normalTitleColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
    style.showExtraButton = YES;
    style.titleMargin = ZOOM_SCALE(30);
    style.extraBtnMarginTitle = ZOOM_SCALE(36);
    style.extraBtnBackgroundImageName = @"icon_sacn_black";
    CGRect scanBtnFrame = CGRectMake(ZOOM_SCALE(15), ZOOM_SCALE(30), ZOOM_SCALE(24), ZOOM_SCALE(24));
    style.extraBtnFrame = scanBtnFrame;
    style.segmentHeight = ZOOM_SCALE(81);
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    PWScrollPageView *scrollPageView = [[PWScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -kTabBarHeight) segmentStyle:style childVcs:childVcs parentViewController:self];
    // 额外的按钮响应的block
    __weak typeof(self) weakSelf = self;
    scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
        weakSelf.title = @"点击了extraBtn";
        NSLog(@"点击了extraBtn");
        
    };
    [self.view addSubview:scrollPageView];
}
- (NSArray *)setupChildVcAndTitle {
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = PWBackgroundColor;
    vc1.title = @"情报";
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = PWBackgroundColor;
    vc2.title = @"智库";
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = PWBackgroundColor;
    vc3.title = @"服务";
    NSArray *childVcs = [NSArray arrayWithObjects:vc1, vc2, vc3, nil];
    return childVcs;
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
