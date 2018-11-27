//
//  BaseWebVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/19.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "BaseWebVC.h"
#import <WebKit/WebKit.h>
@interface BaseWebVC ()
@property (nonatomic, strong) NSURL *webUrl;
@end

@implementation BaseWebVC
-(id)initWithTitle:(NSString *)title andWebUrl:(NSURL *)webUrl{
    if (self = [super init]) {
        self.navigationController.title = title;
        self.webUrl = webUrl;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
