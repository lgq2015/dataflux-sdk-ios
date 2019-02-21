//
//  ContactUsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ContactUsVC.h"
#import "PPBadgeView.h"
#define TagPhoneBtn  100  // 右侧图片
#define TagEmailBtn 200
@interface ContactUsVC ()

@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    [self createUI];
}
- (void)createUI{
    self.view.backgroundColor = PWWhiteColor;
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, Interval(28), ZOOM_SCALE(160), ZOOM_SCALE(160))];
    iconImg.image = [UIImage imageNamed:@"mine_contacticon"];
    CGPoint center = iconImg.center;
    center.x = self.view.centerX;
    iconImg.center = center;
    [self.view addSubview:iconImg];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(24) textColor:PWTextBlackColor text:@"王教授"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImg.mas_bottom).offset(Interval(30));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(33));
    }];
    UIButton *phoneBtn = [[UIButton alloc]init];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"icon_csm"] forState:UIControlStateNormal];
    phoneBtn.tag = TagPhoneBtn;
    [phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(100));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(Interval(25));
        make.width.height.offset(ZOOM_SCALE(50));
    }];
    UIButton *emailBtn = [[UIButton alloc]init];
    [emailBtn setBackgroundImage:[UIImage imageNamed:@"mine_email"] forState:UIControlStateNormal];
    [self.view addSubview:emailBtn];
    [emailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    emailBtn.tag = TagEmailBtn;
    [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(100));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(Interval(25));
        make.width.height.offset(ZOOM_SCALE(50));
    }];
    
    UILabel *phoneLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWSubTitleColor text:@"拨打电话"];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneBtn.mas_left);
        make.top.mas_equalTo(phoneBtn.mas_bottom).offset(Interval(12));
        make.width.offset(ZOOM_SCALE(50));
        make.height.offset(ZOOM_SCALE(17));
    }];
    UILabel *emailLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWSubTitleColor text:@"发送邮件"];
    emailLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:emailLab];
    [emailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(emailBtn.mas_left);
        make.top.mas_equalTo(emailBtn.mas_bottom).offset(Interval(12));
        make.width.offset(ZOOM_SCALE(50));
        make.height.offset(ZOOM_SCALE(17));
    }];
    UIView *downView = [[UIView alloc]init];
    downView.backgroundColor = PWBackgroundColor;
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emailLab.mas_bottom).offset(Interval(40));
        make.width.offset(kWidth);
        make.bottom.mas_equalTo(self.view);
    }];
    
    UIImageView *logoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_logo"]];
    [downView addSubview:logoIcon];
    logoIcon.frame = CGRectMake(0, Interval(13), ZOOM_SCALE(32), ZOOM_SCALE(32));
    CGPoint logoCenter = logoIcon.center;
    logoCenter.x = self.view.centerX;
    logoIcon.center = logoCenter;
    
    UILabel *subPhone = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWTitleColor text:@"400-882-3320"];
    [downView addSubview:subPhone];
    [subPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(96));
        make.top.mas_equalTo(logoIcon.mas_bottom).offset(Interval(10));
        make.height.offset(ZOOM_SCALE(17));
    }];
    UILabel *zoonLab =[PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWBlueColor text:@"上海浦东新区"];
    [downView addSubview:zoonLab];
    [zoonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(96));
        make.top.mas_equalTo(logoIcon.mas_bottom).offset(Interval(10));
        make.height.offset(ZOOM_SCALE(17));
    }];
    
    UILabel *addressLab =[PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWTitleColor text:@"上海市浦东新区科苑路399号张江创新园7号楼"];
    [downView addSubview:addressLab];
    addressLab.textAlignment = NSTextAlignmentCenter;
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zoonLab.mas_bottom).offset(Interval(10));
        make.height.offset(ZOOM_SCALE(17));
        make.width.offset(kWidth);
    }];
}
- (void)btnClick:(UIButton *)button{
    if (button.tag == TagPhoneBtn) {
        
    }else{
        
    }
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
