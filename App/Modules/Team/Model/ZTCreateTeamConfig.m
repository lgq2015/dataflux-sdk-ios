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
    nameTf.title = NSLocalizedString(@"local.TeamName", @"");
    nameTf.placeholder = NSLocalizedString(@"local.PleaseInputTeamName", @"");
    nameTf.showArrow = NO;
    TeamTF *placeTf = [TeamTF new];
    placeTf.title = NSLocalizedString(@"local.location", @"");
    placeTf.placeholder = NSLocalizedString(@"local.placeholder.selectLocation", @"");
    placeTf.enabled = NO;
    TeamTF *industryTf = [TeamTF new];
    industryTf.title = NSLocalizedString(@"local.industry", @"");
    industryTf.placeholder = NSLocalizedString(@"local.placeholder.selectIndustry", @"");
    industryTf.enabled = NO;
    industryTf.showArrow = YES;
    self.showDescribe = YES;
    self.title = NSLocalizedString(@"local.FillInTeamInformation", @"");
    nameTf.enabled = YES;
    placeTf.showArrow = YES;
    self.teamTfArray = [NSMutableArray arrayWithArray:@[nameTf,placeTf,industryTf]];
}
@end
