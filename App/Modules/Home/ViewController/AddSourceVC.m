//
//  AddSourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddSourceVC.h"

@interface AddSourceVC ()

@end

@implementation AddSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加情报源";
    self.isShowLiftBack = NO;
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(navigationBtnClick:) tags:@[@5]];
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(navigationBtnClick:) tags:@[@6]];
}
- (void)navigationBtnClick:(UIButton *)button{
    if (button.tag == 5) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag == 6){
        
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
