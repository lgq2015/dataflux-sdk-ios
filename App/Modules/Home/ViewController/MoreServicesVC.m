//
//  MoreServicesVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MoreServicesVC.h"

@interface MoreServicesVC ()

@end

@implementation MoreServicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多诊断服务";
    [self createUI];
}
- (void)createUI{
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-Interval(40)-ZOOM_SCALE(47));
    self.mainScrollView.contentSize = CGSizeMake(kWidth, ZOOM_SCALE(500)+Interval(26));
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = PWBackgroundColor;
    UIImageView *topImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigcard"]];
    [self.mainScrollView addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainScrollView).offset(Interval(12));
        make.left.mas_equalTo(self.mainScrollView).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(127));
    }];
    UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWWhiteColor text:@"在云平台诊断与深度的主机诊断和先知监控基础之上，如果您希望进一步拓展诊断内容的覆盖范围，我们还为您提供了更多定制化专业化的诊断选项。"];
    tip.numberOfLines = 0;
    [self.mainScrollView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topImg).offset(Interval(19));
        make.right.mas_equalTo(topImg).offset(-Interval(19));
        make.top.mas_equalTo(topImg).offset(Interval(24));
    }];
    
    UIView *subCotentView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(26)+ZOOM_SCALE(127), kWidth, ZOOM_SCALE(450))];
    subCotentView.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:subCotentView];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_netscan"]];
    UIImageView *iconUrl = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_url"]];
    
    [subCotentView addSubview:icon];
    [subCotentView addSubview:iconUrl];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(subCotentView).offset(Interval(16));
        make.top.mas_equalTo(subCotentView).offset(Interval(16));
        make.width.offset(ZOOM_SCALE(56));
        make.height.offset(ZOOM_SCALE(38));
    }];
    UILabel *titlenet = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:@"网站安全扫描"];
    [subCotentView addSubview:titlenet];
    [titlenet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(18));
        make.centerY.mas_equalTo(icon);
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *netContent = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWSubTitleColor text:@"结合情报大数据、白帽渗透测试实战经验和深度机器学习的全面网站威胁检测，包括漏洞、涉政暴恐色情内容、网页篡改、挂马暗链、垃圾广告等，第一时间助您精准发现您的网站资产和关联资产存在的安全风险，满足合规要求，同时避免遭受品牌形象和经济损失。"];
    netContent.numberOfLines = 0;
    [subCotentView addSubview:netContent];
    [netContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(icon.mas_bottom).offset(Interval(12));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
    }];
    
    [iconUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(subCotentView).offset(Interval(16));
        make.top.mas_equalTo(netContent.mas_bottom).offset(Interval(15));
        make.width.offset(ZOOM_SCALE(56));
        make.height.offset(ZOOM_SCALE(38));
    }];
    UILabel *titleurl = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:@"网站安全扫描"];
    [subCotentView addSubview:titleurl];
    [titleurl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconUrl.mas_right).offset(Interval(18));
        make.centerY.mas_equalTo(iconUrl);
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *urlContent = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWSubTitleColor text:@"为您检测您的 URL 在多个地域下的访问速度，及时发现可能存在的访问故障，帮助您避免业务遭受影响。"];
    urlContent.numberOfLines = 0;
    [subCotentView addSubview:urlContent];
    [urlContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(iconUrl.mas_bottom).offset(Interval(12));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
    }];
    UIView *subview = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-kTopHeight-ZOOM_SCALE(47-Interval(40)), kWidth, ZOOM_SCALE(47)+Interval(40))];
    subview.backgroundColor = PWWhiteColor;
    [self.view  addSubview:subview];
    UIButton *commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"更多内容"];
    [commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [subview addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.bottom.mas_equalTo(subview).offset(-Interval(24));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
}
- (void)commitClick{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
