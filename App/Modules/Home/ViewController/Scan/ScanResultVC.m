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
    [userManager saveUserInfoLoginStateisChange:NO success:^(BOOL isSuccess) {
        KPostNotification(KNotificationTeamStatusChange,@YES);
        KPostNotification(KNotificationIssueSourceChange,nil);
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    [[IssueListManger sharedIssueListManger] doDownLoadAllIssueList];
    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(NSString * _Nonnull str) {
        
    }];
   
}
- (void)eventOfTeamViewWithExtra:(NSDictionary *)extra{
    NSString *path = [extra stringValueForKey:@"path" default:@""];
    if ([path isEqualToString:@"teamManager"]) {
        FillinTeamInforVC *teamvc = [[FillinTeamInforVC alloc]init];
        [self.navigationController pushViewController:teamvc animated:YES];
    }else if([path isEqualToString:@"index"]){
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
