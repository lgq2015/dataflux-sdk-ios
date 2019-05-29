//
//  AtListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/6.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AtListVC.h"
#import "PWScrollPageView.h"
#import "ReadUnreadListVC.h"
#import "MemberInfoModel.h"
#import "TeamInfoModel.h"
@interface AtListVC ()
@property (nonatomic, strong) PWScrollSegmentView *segmentView;

@end

@implementation AtListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"@列表";
    [self createUI];
}
- (void)createUI{
    PWSegmentStyle *style = [[PWSegmentStyle alloc]init];
    style.titleFont = RegularFONT(14);
    style.selectTitleFont =RegularFONT(14);
    style.selectedTitleColor =PWBlueColor;
    style.normalTitleColor = PWTitleColor;
    style.showExtraButton = NO;
    style.titleMargin = 0;
    style.segmentHeight = 48;
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    PWScrollPageView *scrollPageView = [[PWScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) segmentStyle:style childVcs:childVcs parentViewController:self];
    [self.view addSubview:scrollPageView];
}
- (NSArray *)setupChildVcAndTitle {
    NSArray *readAccounts = PWSafeArrayVal(self.atStatus, @"readAccounts");
    NSArray *unreadAccounts = PWSafeArrayVal(self.atStatus, @"unreadAccounts");
    __block NSMutableArray *readAccountsAry = [NSMutableArray new];
    __block NSMutableArray *unreadAccountsAry = [NSMutableArray new];
    if (self.isHasStuff) {
        if ([self addSpecialist123]) {
            [readAccountsAry addObject:[self addSpecialist123]];
        }
    }
    [readAccounts enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [userManager getTeamMenberWithId:[obj stringValueForKey:@"accountId" default:@""]  memberBlock:^(NSDictionary *member) {
            NSError *error;
            MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:member error:&error];
            [readAccountsAry addObject:model];
        }];
    }];
    [unreadAccounts enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [userManager getTeamMenberWithId:[obj stringValueForKey:@"accountId" default:@""]  memberBlock:^(NSDictionary *member) {
            NSError *error;
            MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:member error:&error];
            [unreadAccountsAry addObject:model];
        }];
    }];
    ReadUnreadListVC *vc1 = [ReadUnreadListVC new];
    vc1.view.backgroundColor = PWBackgroundColor;
    vc1.atStatusAry =[readAccountsAry copy];
    vc1.title =[NSString stringWithFormat:@"已读 (%ld)",readAccountsAry.count];
    
    ReadUnreadListVC *vc2 = [ReadUnreadListVC new];
    vc2.view.backgroundColor = PWBackgroundColor;
    vc2.atStatusAry =[unreadAccountsAry copy];
    vc2.title = [NSString stringWithFormat:@"未读 (%ld)",unreadAccounts.count];;
    
    NSArray *childVcs = [NSArray arrayWithObjects:vc2, vc1, nil];
    return childVcs;
}
- (MemberInfoModel *)addSpecialist123{
    TeamInfoModel *model = [userManager getTeamModel];
    NSDictionary *tags = model.tags;
    NSArray *ISPs = PWSafeArrayVal(tags, @"ISPs");
    NSArray *constISPs = [userManager getTeamISPs];

    if (ISPs == nil || ISPs.count == 0) return nil;

        NSString *displayName = constISPs[0][@"displayName"][@"zh_CN"];
        NSString *mobile = constISPs[0][@"mobile"];
        NSString *ISP = constISPs[0][@"ISP"];
        MemberInfoModel *model1 =[[MemberInfoModel alloc]init];
        model1.mobile = mobile;
        model1.name = displayName;
        model1.ISP = ISP;
        model1.isSpecialist = YES;
    return model1;
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
