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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"讨论" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick:)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupBadges];
    });
    return;

    
}
- (void)setupBadges{
    [self.navigationItem.rightBarButtonItem pp_addBadgeWithNumber:2];

}
- (void)navRightBtnClick:(UIBarButtonItem *)item{
    
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
