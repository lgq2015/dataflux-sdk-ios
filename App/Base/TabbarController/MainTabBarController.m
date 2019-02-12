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
//    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    [self.tabBar setTabIconWidth:30];
    [self.tabBar setBadgeTop:ZOOM_SCALE(6)];
}
- (void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    //    HomeViewController *homeVC = [[HomeViewController alloc]init];
    //    WaterFallListViewController *homeVC = [WaterFallListViewController new];
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [self setupChildViewController:homeVC title:@"王教授" imageName:@"icon_pw" seleceImageName:@"icon_pwselect"];
     homeVC.isHidenNaviBar= YES;

    //    MakeFriendsViewController *makeFriendVC = [[MakeFriendsViewController alloc]init];
     UIViewController  *makeFriendVC = [[UIViewController alloc]init];
    [self setupChildViewController:makeFriendVC title:@"服务+" imageName:@"icon_serve" seleceImageName:@"icon_serveselect"];
    
    //    MsgViewController *msgVC = [[MsgViewController alloc]init];
    TeamVC *team = [TeamVC new];
    [self setupChildViewController:team title:@"团队" imageName:@"icon_team" seleceImageName:@"icon_teamselect"];
    
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"icon_personal" seleceImageName:@"icon_personals"];
    
    self.viewControllers = _VCS;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
