//
//  CloudCareVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CloudCareVC.h"
#import "PurchaseHistoryVC.h"
#import "ServiceDetailVC.h"
#import "ZTCreateTeamVC.h"
#import "ZYChangeTeamUIManager.h"
#import "TeamInfoModel.h"
@interface CloudCareVC ()<ZYChangeTeamUIManagerDelegate>
@property (nonatomic, strong)UIView *customHeader;
@property (nonatomic, strong)NSMutableArray *teamLists;
@end

@implementation CloudCareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadTeamList];
}
- (void)createUI{
    self.webView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-kTabBarHeight);
    [self addNavigationItemWithTitles:@[@"购买记录"] isLeft:NO target:self action:@selector(navRightBtnClick) tags:@[@11]];
    UIImageView *logo_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_care_logo_icon"]];
    UIImageView *logo_text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_care_logo_text"]];


    self.navigationController.title =@"";
    self.navigationItem.titleView = [UIView new];

    [self.navigationItem.titleView addSubview:logo_text];

    [logo_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.navigationItem.titleView);
    }];

    [self.navigationItem.titleView addSubview:logo_icon];

    [logo_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.navigationItem.titleView);
        make.right.mas_equalTo(logo_text.mas_left).offset(0);

    }];
}
- (void)navRightBtnClick{
//    [[ZYChangeTeamUIManager shareInstance] showWithOffsetY:kTopHeight];
//    [ZYChangeTeamUIManager shareInstance].delegate = self;
    [self.navigationController pushViewController:[PurchaseHistoryVC new] animated:YES];
}
-(void)eventOfOpenWithExtra:(NSDictionary *)extra{
    NSString *url = extra[@"url"];
    BOOL hideTitleWhenScroll = extra[@"hideTitleWhenScroll"];
    BOOL isOverLayTitleBar = extra[@"isOverLayTitleBar"];
    ServiceDetailVC *detailVC = [[ServiceDetailVC alloc]initWithURL:[NSURL URLWithString:url]];
    detailVC.isHidenNaviBar = YES;
    detailVC.hideTitleWhenScroll = hideTitleWhenScroll;
    if (isOverLayTitleBar) {
        detailVC.isShowCustomNaviBar = YES;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ---test 团队列表请求---
- (void)loadTeamList{
    [self.teamLists removeAllObjects];
    [PWNetworking requsetHasTokenWithUrl:PW_AuthTeamList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count == 0 || content == nil){
                return ;
            }
            for(NSDictionary *dic in content){
                NSError * error = nil;
                TeamInfoModel *model = [[TeamInfoModel alloc] initWithDictionary:dic error:&error];
                //存储默认团队teamID
                if (model.isDefault){
                    setPWDefaultTeamID(model.teamID);
                }
                [self.teamLists addObject:model];
            }
            //缓存团队列表
            [userManager setAuthTeamList:self.teamLists];
        }
    } failBlock:^(NSError *error) {
    }];
}

- (NSMutableArray *)teamLists{
    if (!_teamLists){
        _teamLists = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _teamLists;
}
- (void)didClickChangeTeamWithGroupID:(NSString *)groupID{
    NSLog(@"groupID----%@",groupID);
    NSDictionary *params = @{@"data":@{@"teamId":groupID}};
    [PWNetworking requsetHasTokenWithUrl:PW_AuthSwitchTeam withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSString *token = response[@"content"][@"authAccessToken"];
            //存储最新token
            setXAuthToken(token);
            //存储默认团队IDO
            setPWDefaultTeamID(groupID);
            //发送团队切换通知
            KPostNotification(KNotificationSwitchTeam, nil);
            //更新团队列表中的默认团队
            [userManager updateTeamModelWithGroupID:groupID];
            //重新发送loadlist请求
            [self loadTeamList];
           NSString *name =  userManager.teamModel.name;
            NSLog(@"nameZt----%@",name);
        }
    } failBlock:^(NSError *error) {
    }];

}
@end
