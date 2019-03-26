//
//  ExpertsMoreVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/21.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ExpertsMoreVC.h"

@interface ExpertsMoreVC ()

@end

@implementation ExpertsMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    self.isShowWhiteBack = YES;
    [self createUI];
}
- (void)createUI{
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.backgroundColor = PWWhiteColor;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, ZOOM_SCALE(850));
    UIImageView *bigAvatarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*3/4.0+kTopHeight-64)];
    bigAvatarImgView.image = [UIImage imageNamed:@"expert_avatar"];
    [self.mainScrollView addSubview:bigAvatarImgView];
    UIView *shadeView = [[UIView alloc]initWithFrame:bigAvatarImgView.frame];
    shadeView.backgroundColor = PWBlackColor;
    shadeView.alpha = 0.4;
    [bigAvatarImgView addSubview:shadeView];
    
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(20) textColor:PWWhiteColor text:@"CloudCare 服务专家团队"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.mainScrollView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainScrollView).offset(Interval(5)+kTopHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.offset(ZOOM_SCALE(28));
    }];
    
    NSArray *iconAry = @[@"expert_major",@"expert_senior",@"expert_powerful"];
    NSArray *titleAry = @[@"专业",@"资深",@"强大"];
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:@"符合 ISO20000、270001 的合格认证"];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range = [@"符合 ISO20000、270001 的合格认证" rangeOfString:@"ISO20000、270001"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = PWTextBlackColor;
    //赋值
    [string1 addAttributes:dic range:range];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:@"服务了 5000+ 各行各业的客户"];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range2 = [@"服务了 5000+ 各行各业的客户" rangeOfString:@"5000+"];
    
    //赋值
    [string2 addAttributes:dic range:range2];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:@"超过 250+ 专业云认证工程师"];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range3 = [@"超过 250+ 专业云认证工程师" rangeOfString:@"250+"];
    //赋值
    [string3 addAttributes:dic range:range3];
    NSArray *subTitleAry = @[string1,string2,string3];
    UIView *temp = nil;
    for (NSInteger i=0; i<subTitleAry.count; i++) {
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconAry[i]]];
        [self.mainScrollView addSubview:icon];
        UILabel *itemTitleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTextBlackColor text:titleAry[i]];
        [self.mainScrollView addSubview:itemTitleLab];
        UILabel *subTitleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWSubTitleColor text:@""];
        [self.mainScrollView addSubview:subTitleLab];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == nil) {
                make.top.mas_equalTo(bigAvatarImgView.mas_bottom).offset(Interval(36));
            }else{
                make.top.mas_equalTo(temp.mas_bottom).offset(Interval(13));
            }
                make.left.mas_equalTo(self.view).offset(Interval(6));
                make.width.height.offset(ZOOM_SCALE(60));
        }];
        [itemTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(Interval(5));
            make.top.mas_equalTo(icon).offset(Interval(7));
            make.height.offset(ZOOM_SCALE(22));
        }];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(Interval(5));
            make.top.mas_equalTo(itemTitleLab.mas_bottom).offset(Interval(5));
            make.height.offset(ZOOM_SCALE(20));
        }];
        subTitleLab.attributedText = subTitleAry[i];
        temp = icon;
    }
    UILabel *detailLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTitleColor text:@"为您提供云时代最优质的 IT 服务，是我们的使命。\n\n汇集网络、安全、监控、运维等各领域的技术顾问，以及在 SAP、Oracle 等大型企业级应用软件多年经验沉淀的领域专家。\n\n全面覆盖您在 IT 实践过程中所可能遇到的场景，协助您处理相关问题，让您的 IT 再无后顾之优。"];
    detailLab.numberOfLines = 0;
    [self.mainScrollView addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab).offset(Interval(16));
        make.right.mas_equalTo(titleLab).offset(-Interval(16));
        make.top.mas_equalTo(bigAvatarImgView.mas_bottom).offset(ZOOM_SCALE(267));
    }];
    UIButton *detailBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"查看详情"];
    detailBtn.layer.cornerRadius = 0;
    [self.mainScrollView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bigAvatarImgView);
        make.height.offset(ZOOM_SCALE(47));
        //    make.top.mas_equalTo(self.mainScrollView).offset(ZOOM_SCALE(803));
        make.bottom.mas_equalTo(self.view);
    }];
    [detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [self.view bringSubviewToFront:self.whiteBackBtn];

}
- (void)detailBtnClick{
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
