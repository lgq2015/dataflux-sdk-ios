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

@interface ServiceDetailVC ()

@end

@implementation ServiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    self.view.backgroundColor = PWBlueColor;
    if (self.isHidenNaviBar) {
        self.webView.frame = CGRectMake(0, 0, kWidth, kHeight+1);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
