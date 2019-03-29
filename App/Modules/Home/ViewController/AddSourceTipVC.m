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
        if(isteam){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tabBarController setSelectedIndex:1];
            });
        }else{
            [self.tabBarController setSelectedIndex:2];
            [self.navigationController popViewControllerAnimated:NO];
        }
    };
}
-(void)backBtnClicked{
    
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
