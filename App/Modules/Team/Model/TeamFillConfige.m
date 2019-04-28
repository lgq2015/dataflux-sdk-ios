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
    NSString *city = model.city.length>0?model.city:model.province;

    if (userManager.teamModel == nil) {
        self.type = FillinTeamTypeAdd;
        self.title = @"填写团队信息";
        nameTf.enabled = YES;
        placeTf.showArrow = YES;
    }else if(userManager.teamModel.isAdmin){
        self.title = @"团队管理";
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
        self.title = @"团队管理";
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
