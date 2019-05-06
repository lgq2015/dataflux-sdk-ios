//
//  AtListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/6.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AtListVC.h"
#import "PWScrollPageView.h"
#import "ReadUnreadListVC.h"

@interface AtListVC ()
@property (nonatomic, strong) PWScrollSegmentView *segmentView;

@end

@implementation AtListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"@列表";
    [self createUI];
}
- (void)createUI{
    PWSegmentStyle *style = [[PWSegmentStyle alloc]init];
    style.titleFont = RegularFONT(14);
    style.selectTitleFont =RegularFONT(14);
    style.selectedTitleColor =PWBlueColor;
    style.normalTitleColor = PWTitleColor;
    style.showExtraButton = NO;
    style.titleMargin = 0;
    style.segmentHeight = 48;
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    PWScrollPageView *scrollPageView = [[PWScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) segmentStyle:style childVcs:childVcs parentViewController:self];
    [self.view addSubview:scrollPageView];
}
- (NSArray *)setupChildVcAndTitle {
    ReadUnreadListVC *vc1 = [ReadUnreadListVC new];
    vc1.view.backgroundColor = PWBackgroundColor;
    vc1.title = @"已读（4）";
    
    ReadUnreadListVC *vc2 = [ReadUnreadListVC new];
    vc2.view.backgroundColor = PWBackgroundColor;
    vc2.title = @"未读（1）";
    
    NSArray *childVcs = [NSArray arrayWithObjects:vc1, vc2, nil];
    return childVcs;
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
