//
//  ChangeUserInfoVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChangeUserInfoVC.h"

@interface ChangeUserInfoVC ()

@end

@implementation ChangeUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    [self createNav];
    [self createUI];
}
- (void)createNav{
    
}
- (void)createUI{
    switch (self.type) {
        case ChangeUITPhoneNumber:
            self.title = @"修改手机";
            break;
        case ChangeUITPassword:
            self.title = @"修改密码";
            break;
        case ChangeUITEmail:
            self.title = @"修改邮箱";
            break;
    }
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, Interval(58), kWidth, ZOOM_SCALE(50)) font:MediumFONT(18) textColor:PWTextBlackColor text:@"为了保障您的账号安全 \n请选择一种身份验证"];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
    
}
- (UIView *)itemViewWithData:(NSDictionary *)data{
    UIView *item = [[UIView alloc]init];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(24), 0, ZOOM_SCALE(36), ZOOM_SCALE(36))];
    icon.image = [UIImage imageNamed:data[@"icon"]];
    CGPoint center = icon.center;
    center.y = item.centerY;
    icon.center = center;
    return item;
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
