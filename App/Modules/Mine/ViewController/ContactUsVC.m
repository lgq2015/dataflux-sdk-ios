//
//  ContactUsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ContactUsVC.h"
#import "PPBadgeView.h"

@interface ContactUsVC ()

@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    [self createUI];
}
- (void)createUI{
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, Interval(28), ZOOM_SCALE(160), ZOOM_SCALE(160))];
    iconImg.image = [UIImage imageNamed:@"mine_contacticon"];
    CGPoint center = iconImg.center;
    center.x = self.view.centerX;
    iconImg.center = center;
    [self.view addSubview:iconImg];
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
