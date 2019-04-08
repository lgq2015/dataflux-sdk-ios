//
//  ExpertsDetailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/21.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ExpertsDetailVC.h"
#import "MemberInfoVC.h"

@interface ExpertsDetailVC ()
@property (nonatomic, strong) NSString *profilesStr;
@end

@implementation ExpertsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    self.isShowWhiteBack = YES;
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    NSString *avatarName = self.data[@"expertGroup"];
    NSURL *avatarUrl = [NSURL URLWithString:PW_ExpertAvatarBig(avatarName)];
    UIImageView *bigAvatarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*3/4.0+kTopHeight-64)];
    [bigAvatarImgView sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@""]];
    [self.view addSubview:bigAvatarImgView];
    UIView *shadeView = [[UIView alloc]initWithFrame:bigAvatarImgView.frame];
    shadeView.backgroundColor = PWBlackColor;
    shadeView.alpha = 0.4;
    [bigAvatarImgView addSubview:shadeView];
    NSString *expertNameStr = self.data[@"displayName"][@"zh_CN"];
    UILabel *expertName = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWWhiteColor text:expertNameStr];
    [self.view addSubview:expertName];
    __block NSString *profileStr = @"证书";
    NSArray *profileAry = self.data[@"profile"][@"tags"];
    
    [profileAry enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *displayName = obj[@"displayName"];
        NSString *name = [displayName stringValueForKey:@"zh_CN" default:@""];
        profileStr = [profileStr stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    }];
    self.profilesStr = profileStr;
    UILabel *profileLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWWhiteColor text:profileStr];
    profileLab.numberOfLines = 0;
    [self.view addSubview:profileLab];
    
    [expertName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.bottom.mas_equalTo(bigAvatarImgView.mas_bottom).offset(-Interval(34)-ZOOM_SCALE(22));
        make.height.offset(ZOOM_SCALE(25));
    }];
    [profileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(expertName.mas_bottom).offset(Interval(9));
    }];
    UIButton *inviteBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"邀请加入讨论"];
   
    [inviteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FFC163"]] forState:UIControlStateNormal];
     [inviteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FFC163"]] forState:UIControlStateHighlighted];
    [self.view addSubview:inviteBtn];
    [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bigAvatarImgView.mas_bottom).offset(Interval(51));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
    UIButton *callBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"预约电话沟通"];
    [self.view addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inviteBtn.mas_bottom).offset(Interval(30));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    [self.view bringSubviewToFront:self.whiteBackBtn];
    [callBtn addTarget:self action:@selector(callBtnClick) forControlEvents:UIControlEventTouchUpInside];

}
- (void)callBtnClick{
    NSString *avatarName = self.data[@"expertGroup"];
    NSDictionary *expert = @{@"name":self.data[@"displayName"][@"zh_CN"],@"url":PW_ExpertAvatarSmall(avatarName),@"content":self.profilesStr};
    MemberInfoVC *infoVC = [[MemberInfoVC alloc]init];
    infoVC.isHidenNaviBar = YES;
    infoVC.expertDict = expert;
    infoVC.isExpert = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
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
