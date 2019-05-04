//
//  HomeViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "HomeViewController.h"
#import "PWScrollPageView.h"
#import "HomeViewIssueIndexVC.h"
#import "LibraryVC.h"
#import "ToolsVC.h"
#import "ScanViewController.h"
#import "RootNavigationController.h"
#import "ZYChangeTeamUIManager.h"
#import "FillinTeamInforVC.h"
@interface HomeViewController ()<ZYChangeTeamUIManagerDelegate>
@property (nonatomic, strong) NetworkToolboxView *toolsView;
@property (nonatomic, strong) PWScrollSegmentView *zysegmentView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    PWSegmentStyle *style = [[PWSegmentStyle alloc]init];
    style.titleFont = RegularFONT(17);
    style.selectTitleFont = RegularFONT(24);
    style.selectedTitleColor =RGBACOLOR(51, 51, 51, 1);
    style.normalTitleColor = PWTitleColor;
    style.showExtraButton = YES;
    style.titleMargin = 20;
    style.extraBtnMarginTitle = 20;
    style.extraBtnImageNames =@[@"icon_scan"];
    style.leftExtraBtnImageNames= @[@"icon_teamselect",@"arrow_down"];
    style.segmentHeight = kTopHeight+16;
    CGRect leftBtnFirst = CGRectMake(0, 0, ZOOM_SCALE(28), ZOOM_SCALE(28));
    CGRect leftArrow = CGRectMake(0, 0, ZOOM_SCALE(11), ZOOM_SCALE(11));
    style.leftExtraBtnFrames = @[[NSValue valueWithCGRect:leftBtnFirst],[NSValue valueWithCGRect:leftArrow]];
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    PWScrollPageView *scrollPageView = [[PWScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kTabBarHeight) segmentStyle:style childVcs:childVcs parentViewController:self];
    // 额外的按钮响应的block

    scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn,PWScrollSegmentView *segmentView){
        if(extraBtn.tag == 10){
        //判断团队切换界面如果弹出就让你消失
        ZYChangeTeamUIManager *manager =[ZYChangeTeamUIManager shareInstance];
        if (manager.isShowTeamView){
            [manager dismiss];
        }
        ScanViewController *scan = [[ScanViewController alloc]init];
        scan.isVideoZoom = YES;
        scan.libraryType = SLT_Native;
        scan.scanCodeType = SCT_QRCode;
        RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:scan];
        [self presentViewController:nav animated:YES completion:nil];
        }else{

            _zysegmentView = segmentView;
            UIButton *arrowBtn = [segmentView viewWithTag:21];
            arrowBtn.userInteractionEnabled = NO;
            arrowBtn.selected = !arrowBtn.selected;
            //设置动画
            [UIView animateWithDuration:0.2 animations:^{
                if (arrowBtn.selected){
                    arrowBtn.transform = CGAffineTransformMakeRotation(M_PI);
                }else{
                    arrowBtn.transform = CGAffineTransformIdentity;
                }
            } completion:^(BOOL finished) {
                arrowBtn.userInteractionEnabled = YES;
            }];
            //显示
            if (arrowBtn.isSelected){
                ZYChangeTeamUIManager *changeView=  [ZYChangeTeamUIManager shareInstance];
                [changeView showWithOffsetY:kTopHeight+16];
                changeView.delegate = self;
                changeView.fromVC = self;
            }else{
                [[ZYChangeTeamUIManager shareInstance] dismiss];
            }
        }
    };
    scrollPageView.tag = 500;
    [self.view addSubview:scrollPageView];
}
-(void)setSelectedIndex:(NSInteger)index{
    PWScrollPageView *scrollPageView = [self.view viewWithTag:500];
    HomeViewIssueIndexVC *vc1 = scrollPageView.childVcs[0];
    [scrollPageView setSelectedIndex:index animated:NO];
    [vc1.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [vc1.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}
- (NSArray *)setupChildVcAndTitle {
    HomeViewIssueIndexVC *vc1 = [HomeViewIssueIndexVC new];
    vc1.view.backgroundColor = PWBackgroundColor;
    vc1.title = @"情报";
    
    LibraryVC *vc2 = [LibraryVC new];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clickTeamChangeViewBlackBG];
}
//点击切换团队阴影
- (void)clickTeamChangeViewBlackBG{
    [ZYChangeTeamUIManager shareInstance].dismissedBlock = ^(BOOL isDismissed) {
        if (isDismissed){
            UIButton *arrowBtn = [_zysegmentView viewWithTag:21];
            arrowBtn.selected = NO;
            //设置动画
            arrowBtn.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                arrowBtn.transform = CGAffineTransformMakeRotation(0.01 *M_PI/180);
            } completion:^(BOOL finished) {
                arrowBtn.userInteractionEnabled = YES;
            }];
        }
    };
}

@end
