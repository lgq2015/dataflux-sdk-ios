//
//  CloudCareVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CloudCareVC.h"

@interface CloudCareVC ()
@end

@implementation CloudCareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CloudCare";
    [self createUI];
}
- (void)createUI{

   self.webView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight-kTopHeight);
   
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
