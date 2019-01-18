//
//  SourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SourceVC.h"

@interface SourceVC ()

@end
@implementation SourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUIWithType:self.type];
    // Do any additional setup after loading the view.
}
- (void)createUIWithType:(SourceType)type{
    switch (type) {
        case SourceTypeAli:
            [self createSourceTypeAliUI];
            break;
            
        default:
            break;
    }
}
- (void)createSourceTypeAliUI{
    self.title = @"连接阿里云";
    [self addNavigationItemWithImageNames:@[@"icon_collection"] isLeft:NO target:self action:@selector(navRightBtnClick:) tags:@[@10]];
}
- (void)navRightBtnClick:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *edit = [PWCommonCtrl actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *delet = [PWCommonCtrl actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:edit];
    [alert addAction:delet];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
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
