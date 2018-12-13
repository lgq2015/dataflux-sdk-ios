//
//  VerifyCodeLoginVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "VerifyCodeLoginVC.h"
#import "UserManager.h"
@interface VerifyCodeLoginVC ()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation VerifyCodeLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(130), ZOOM_SCALE(88), ZOOM_SCALE(100), ZOOM_SCALE(56))];
        _iconImg.image = [UIImage imageNamed:@""];
        [self.view addSubview:_iconImg];
    }
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(164), kWidth, ZOOM_SCALE(25))];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.text = @"验证码登录/注册";
        _titleLab.textColor = PWTextColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLab];
    }
}
#pragma mark ========== 获取验证码 ==========
- (void)getVerifyCode{
    [[UserManager sharedUserManager]getVerificationCodeType:CodeTypeCode WithParams:@{} completion:^(CodeStatus status, NSString *des) {
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
