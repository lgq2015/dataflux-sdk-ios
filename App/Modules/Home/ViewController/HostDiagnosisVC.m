//
//  HostDiagnosisVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HostDiagnosisVC.h"

@interface HostDiagnosisVC ()

@end

@implementation HostDiagnosisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主机诊断";
    [self createUI];
}
- (void)createUI{
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, ZOOM_SCALE(674)+Interval(12));
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, ZOOM_SCALE(674))];
    contentView.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:contentView];
    
    UIImageView *hostImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_host"]];
    [contentView addSubview:hostImgView];
    [hostImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(ZOOM_SCALE(13));
        make.width.offset(ZOOM_SCALE(343));
        make.height.offset(ZOOM_SCALE(210));
        make.centerX.mas_equalTo(contentView);
    }];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:@"手机端不支持开启单机诊断，请前往 Web端（https://prof.wang) 进行操作"];
    tipLab.numberOfLines = 2;
    tipLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hostImgView.mas_bottom).offset(ZOOM_SCALE(6));
        make.width.offset(ZOOM_SCALE(250));
        make.height.offset(ZOOM_SCALE(40));
        make.centerX.mas_equalTo(contentView);
    }];
    
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@"什么是主机诊断"];
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab.mas_bottom).offset(ZOOM_SCALE(23));
        make.left.mas_equalTo(Interval(16));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UILabel *contentLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:[UIColor colorWithHexString:@"#595860"] text:@"主机诊断是指通过在您需诊断的主机上安装我们开发的探针程序，通过探针程序收集主机的相关检测指标并上报到王教授的诊断系统进行诊断并产生相关情报。"];
    contentLab.numberOfLines = 0;
    [contentView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(ZOOM_SCALE(8));
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.right.mas_equalTo(contentView).offset(-Interval(16));
    }];
    
    UIImageView *subImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"host_systerm"]];
    [contentView addSubview:subImg];
    [subImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentLab.mas_bottom).offset(ZOOM_SCALE(20));
        make.width.offset(ZOOM_SCALE(343));
        make.height.offset(ZOOM_SCALE(200));
        make.centerX.mas_equalTo(contentView);
    }];
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
