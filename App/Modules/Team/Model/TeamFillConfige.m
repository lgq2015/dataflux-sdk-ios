//
//  TeamFillConfige.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamFillConfige.h"
#import "TeamInfoModel.h"

@implementation TeamFillConfige
-(instancetype)init{
    if (self = [super init]) {
        [self setTeamFillConfige];
    }
    return self;
}
- (void)setTeamFillConfige{
    TeamInfoModel *model = userManager.teamModel;
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
    NSString *city = model.city.length>0?model.city:model.province;

    if (userManager.teamModel == nil) {
        self.type = FillinTeamTypeAdd;
        self.title = NSLocalizedString(@"local.FillInTeamInformation", @"");
        nameTf.enabled = YES;
        placeTf.showArrow = YES;
    }else if(userManager.teamModel.isAdmin){
        self.title = NSLocalizedString(@"local.TeamManagement", @"");
        self.type = FillinTeamTypeIsAdmin;
        nameTf.enabled = YES;
        nameTf.text = model.name;
        placeTf.showArrow = YES;
        placeTf.text = city;
        industryTf.text = model.industry;
        self.currentProvince = model.province;
        self.currentCity = city;
        self.describeStr = [model.tags stringValueForKey:@"introduction" default:@""];
    }else{
        self.type = FillinTeamTypeIsMember;
        self.title = NSLocalizedString(@"local.TeamManagement", @"");
        nameTf.enabled = NO;
        nameTf.text = model.name;
        placeTf.showArrow = NO;
        placeTf.text = city;
        industryTf.showArrow = NO;
        industryTf.text = model.industry;
        if ([[model.tags stringValueForKey:@"introduction" default:@""] isEqualToString:@""]) {
            self.showDescribe = NO;
        }else{
            self.describeStr = [model.tags stringValueForKey:@"introduction" default:@""];
        }
    }
    self.teamTfArray = [NSMutableArray arrayWithArray:@[nameTf,placeTf,industryTf]];
}
@end
