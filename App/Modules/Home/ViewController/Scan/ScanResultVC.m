//
//  ScanResultVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ScanResultVC.h"
#import "IssueListManger.h"
#import "IssueSourceManger.h"
#import "FillinTeamInforVC.h"
#import "TeamInfoModel.h"
@interface ScanResultVC ()

@end

@implementation ScanResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{

}
-(void)eventSwitchToken:(NSDictionary *)extra{
    NSString *token = [extra stringValueForKey:@"token" default:@""];
    setXAuthToken(token);
    //请求成员
    [userManager requestMemberList:nil];
    [userManager saveUserInfoLoginStateisChange:NO success:^(BOOL isSuccess) {
        KPostNotification(KNotificationSwitchTeam, @YES);
        KPostNotification(KNotificationTeamStatusChange,@YES);
        KPostNotification(KNotificationConnectStateCheck,nil);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        [tabViewController setSelectedIndex:2];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

//    [[IssueListManger sharedIssueListManger] checkSocketConnectAndFetchIssue:^(BaseReturnModel *model) {
//        KPostNotification(KNotificationSwitchTeam, @YES);
//
//        if (!model.isSuccess) {
//            [iToast alertWithTitleCenter:model.errorMsg];
//        }
//    }];

}
- (void)eventOfTeamViewWithExtra:(NSDictionary *)extra{
    NSString *path = [extra stringValueForKey:@"path" default:@""];
    if ([path isEqualToString:@"teamManager"]) {
        FillinTeamInforVC *teamvc = [[FillinTeamInforVC alloc]init];
        [self.navigationController pushViewController:teamvc animated:YES];
    }else if([path isEqualToString:@"index"]){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        [tabViewController setSelectedIndex:2];
        [self dismissViewControllerAnimated:YES completion:nil];
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
