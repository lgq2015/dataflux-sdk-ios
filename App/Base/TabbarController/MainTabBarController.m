//
//  MainTabBarController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/14.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "MainTabBarController.h"
#import "RootViewController.h"
#import "RootNavigationController.h"
#import "UITabBar+CustomBadge.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "TeamVC.h"
#import "PWTabBar.h"
#import "WEBViewController.h"
#import "IssueListVC.h"
#import "LibraryVC.h"
#import "HomeIssueListVC.h"
#import "CalendarVC.h"
#import "ZhugeIOIssueHelper.h"
#import "ZhugeIOCalendarHelper.h"
#import "ZhugeIOLibraryHelper.h"
#import "ZhugeIOTeamHelper.h"
#import "ZhugeIOMineHelper.h"

@interface MainTabBarController ()
@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[PWTabBar new] forKey:@"tabBar"];
    //通过这两个参数来调整badge位置
    [self.tabBar setTabIconWidth:30];
    [self.tabBar setBadgeTop:ZOOM_SCALE(6)];
}
- (void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    HomeIssueListVC *homeVC = [[HomeIssueListVC alloc]init];
    homeVC.isHidenNaviBar = YES;
    [self setupChildViewController:homeVC title:@"情报" imageName:@"issuetab_nor" seleceImageName:@"issuetab_sel"];
    CalendarVC *calendar = [[CalendarVC alloc]init];
    calendar.isHidenNaviBar = YES;
     [self setupChildViewController:calendar title:@"日历" imageName:@"calender_nor" seleceImageName:@"calender_sel"];
    LibraryVC *libriary = [[LibraryVC alloc]init];
    libriary.isHidenNaviBar = YES;

    [self setupChildViewController:libriary title:@"智库" imageName:@"handbook_nor" seleceImageName:@"handbook_sel"];
    TeamVC *team = [TeamVC new];
    team.isHidenNaviBar = YES;
    [self setupChildViewController:team title:@"团队" imageName:@"icon_team" seleceImageName:@"icon_teamselect"];

    MineViewController *mineVC = [[MineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"icon_personal" seleceImageName:@"icon_personals"];

    self.viewControllers = _VCS;

    self.delegate =self;
}
-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CTabbarTextColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];

    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:PWBlueColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];

    //    [self addChildViewController:nav];
    [_VCS addObject:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    switch( tabBarController.selectedIndex){
        case 0:
            [[[ZhugeIOIssueHelper new] eventClickBottomTab] track];
            break;
        case 1:
            [[[ZhugeIOCalendarHelper new] eventClickBottomTab] track];

            break;
        case 2:
            [[[ZhugeIOLibraryHelper new] eventClickBottomTab] track];

            break;
        case 3:
            [[[ZhugeIOTeamHelper new] eventBottomTab] track];

            break;
        case 4:
            [[[ZhugeIOMineHelper new] eventBottomTab] track];

            break;

        default:
            break;
    }

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
