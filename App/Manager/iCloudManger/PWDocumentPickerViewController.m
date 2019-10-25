//
//  PWDocumentPickerViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2019/10/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWDocumentPickerViewController.h"

@interface PWDocumentPickerViewController ()

@end

@implementation PWDocumentPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)viewWillAppear:(BOOL)animated{
    [UINavigationBar appearance].tintColor = PWBlueColor;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
     if (@available(iOS 13.0, *)) {
          return  UIStatusBarStyleDarkContent;
        } else {
         return   UIStatusBarStyleDefault;
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
