//
//  HomeViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "HomeViewController.h"
#import "PWScrollPageView.h"
#import "InformationVC.h"
#import "ThinkTankVC.h"
#import "ToolsVC.h"
#import <IQKeyboardManager/IQKeyboardManager.h>


@interface HomeViewController ()
@property (nonatomic, strong) NetworkToolboxView *toolsView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    PWSegmentStyle *style = [[PWSegmentStyle alloc]init];
    style.titleFont = MediumFONT(17);
    style.selectTitleFont = MediumFONT(24);
    style.selectedTitleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    style.normalTitleColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
    style.showExtraButton = YES;
    style.titleMargin = 20;
    style.extraBtnMarginTitle = 20;
    style.extraBtnImageNames =@[@"icon_scan"];
    style.segmentHeight = kTopHeight+16;
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    PWScrollPageView *scrollPageView = [[PWScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kTabBarHeight) segmentStyle:style childVcs:childVcs parentViewController:self];
    // 额外的按钮响应的block
//    WeakSelf;
    scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
//        if (extraBtn.tag == 10) {
//            [self.toolsView showInView:[UIApplication sharedApplication].keyWindow];
//            self.toolsView.itemClick = ^(PWToolType type){
//                [weakSelf dealWithType:type];
//            };
//        }else if(extraBtn.tag == 11){
//
//        }
    };
    [self.view addSubview:scrollPageView];
   
}
- (NSArray *)setupChildVcAndTitle {
    InformationVC *vc1 = [InformationVC new];
    vc1.view.backgroundColor = PWBackgroundColor;
    vc1.title = @"情报";
    
    ThinkTankVC *vc2 = [ThinkTankVC new];
    vc2.view.backgroundColor = PWBackgroundColor;
    vc2.title = @"手册";
   
    NSArray *childVcs = [NSArray arrayWithObjects:vc1, vc2, nil];
    return childVcs;
}
- (NetworkToolboxView *)toolsView{
    if (!_toolsView) {
        _toolsView = [[NetworkToolboxView alloc]init];
    }
    return _toolsView;
}
- (void)dealWithType:(PWToolType)type{
    ToolsVC *toolVC = [[ToolsVC alloc]init];
    toolVC.type = type;
    [self.navigationController pushViewController:toolVC animated:YES];
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
