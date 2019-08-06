//
//  ClusterDiagnosisVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ClusterDiagnosisVC.h"
#import "BorderView.h"

@interface ClusterDiagnosisVC ()

@end

@implementation ClusterDiagnosisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"先见数据平台";
    [self createUI];
}
- (void)createUI{
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-Interval(20)-ZOOM_SCALE(47));
    self.mainScrollView.contentSize = CGSizeMake(kWidth, ZOOM_SCALE(850)+Interval(12));
    self.mainScrollView.showsVerticalScrollIndicator = NO;

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, ZOOM_SCALE(1124))];
    contentView.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:contentView];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(13), kWidth-Interval(32), ZOOM_SCALE(25)) font:RegularFONT(18) textColor:PWTextBlackColor text:@"什么是先见数据平台"];
    [contentView addSubview:titleLab];
    UILabel *titleContent = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"先见数据平台是驻云基于开源监控平台 Prometheus 开发的，针对集群环境，部署在用户的本地用于收集系统和应用相关数据指标的监控服务平台，同时先见数据平台会在用户允许的范围内将部分数据指标上报到王教授的诊断系统进行分析诊断并产生相关情报。"];
    titleContent.numberOfLines = 0;
    [contentView addSubview:titleContent];
    [titleContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(ZOOM_SCALE(8));
        make.right.mas_equalTo(contentView).offset(-Interval(16));
    }];
    
    UIImageView *prophetImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_prophet"]];
    [contentView addSubview:prophetImgView];
    [prophetImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleContent.mas_bottom).offset(ZOOM_SCALE(11));
        make.width.offset(ZOOM_SCALE(354));
        make.height.offset(ZOOM_SCALE(337));
        make.centerX.mas_equalTo(contentView);
    }];
    UILabel *mediumTitle = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@"怎样才能使用先见数据平台？"];
    [contentView addSubview:mediumTitle];
    [mediumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(prophetImgView.mas_bottom).offset(ZOOM_SCALE(6));
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *mediumContent = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"购买了先见数据平台后，用户如果需要使用先见数据平台并通过王教授进行分析诊断，需要发送服务请求到我们的服务工程师，我们的服务工程师会帮你部署先见数据平台并按照用户需求安装 exporter。"];
    mediumContent.numberOfLines = 0;
    [contentView addSubview:mediumContent];
    [mediumContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.top.mas_equalTo(mediumTitle.mas_bottom).offset(ZOOM_SCALE(8));
        make.right.mas_equalTo(contentView).offset(-Interval(16));
    }];
    

    
    BorderView *boder = [[BorderView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(690), kWidth, ZOOM_SCALE(46))];
    boder.backgroundColor = PWWhiteColor;
    [contentView addSubview:boder];
    
    
    UILabel *progress1 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTextBlackColor text:@"邀请专家"];
    UILabel *progress2 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTextBlackColor text:@"服务工程师部署"];
    UILabel *progress3 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTextBlackColor text:@"等待数据上报"];
    UILabel *progress4 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTextBlackColor text:@"完成"];
    [contentView addSubview:progress1];
    [contentView addSubview:progress2];
    [contentView addSubview:progress3];
    [contentView addSubview:progress4];
    [progress1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(Interval(26));
        make.centerY.mas_equalTo(boder);
        make.height.offset(ZOOM_SCALE(17));
    }];
    [progress2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(Interval(16)+ZOOM_SCALE(100));
        make.centerY.mas_equalTo(boder);
        make.height.offset(ZOOM_SCALE(17));
    }];
    [progress3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(Interval(16)+ZOOM_SCALE(207));
        make.centerY.mas_equalTo(boder);
        make.height.offset(ZOOM_SCALE(17));
    }];
    [progress4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView).offset(-Interval(32));
        make.centerY.mas_equalTo(boder);
        make.height.offset(ZOOM_SCALE(17));
    }];

    UIView *subview = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-kTopHeight-ZOOM_SCALE(47-Interval(40)), kWidth, ZOOM_SCALE(47)+Interval(40))];
    subview.backgroundColor = PWWhiteColor;
    [self.view  addSubview:subview];
    UIButton *commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"去购买"];
    [commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [subview addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.right.mas_equalTo(contentView).offset(-Interval(16));
        make.bottom.mas_equalTo(subview).offset(-Interval(24));
        make.height.offset(ZOOM_SCALE(47));
    }];
}
- (void)commitClick{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
