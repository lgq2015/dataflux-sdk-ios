//
//  AddSourceTipVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddSourceTipVC.h"
#import "AddSourceTipView.h"
#import "AddSourceVC.h"
#import "MainTabBarController.h"

@interface AddSourceTipVC ()

@end

@implementation AddSourceTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"添加情报源";
    [self createUI];
}
- (void)createUI{
    BOOL isteam = [getTeamState isEqualToString:PW_isTeam];
    AddSourceTipType type = isteam?AddSourceTipTypeTeam:AddSourceTipTypePersonal;
    AddSourceTipView *tipView = [[AddSourceTipView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, kHeight-kTopHeight-Interval(12)) type:type];
    [self.view addSubview:tipView];
    tipView.btnClick = ^(){
        DLog(@"count = %lu",self.navigationController.viewControllers.count);
        WeakSelf
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;UIViewController *controller = app.window.rootViewController;
        MainTabBarController *rvc = (MainTabBarController *)controller;
        if(isteam){
            
            [rvc setSelectedIndex:1];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        }else{
           
            [rvc setSelectedIndex:2];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
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
