//
//  ZTCreateTeamConfig.m
//  App
//
//  Created by tao on 2019/4/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTCreateTeamConfig.h"
#import "TeamInfoModel.h"

@implementation ZTCreateTeamConfig
- (void)createTeamConfige{
    TeamTF *nameTf = [TeamTF new];
    nameTf.title = @"团队名称";
    nameTf.placeholder = @"请输入您的团队名称";
    nameTf.showArrow = NO;
    TeamTF *placeTf = [TeamTF new];
    placeTf.title = @"所在地";
    placeTf.placeholder = @"请选择您的团队所在区域";
    placeTf.enabled = NO;
    TeamTF *industryTf = [TeamTF new];
    industryTf.title = @"行业";
    industryTf.placeholder = @"请选择您的团队所属行业";
    industryTf.enabled = NO;
    industryTf.showArrow = YES;
    self.showDescribe = YES;
    self.title = @"填写团队信息";
    nameTf.enabled = YES;
    placeTf.showArrow = YES;
    self.teamTfArray = [NSMutableArray arrayWithArray:@[nameTf,placeTf,industryTf]];
}
@end
