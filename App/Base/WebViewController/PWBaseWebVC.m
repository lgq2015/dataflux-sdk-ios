//
//  PWBaseWebVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWBaseWebVC.h"
#import <WebKit/WebKit.h>

@interface PWBaseWebVC ()
@end

@implementation PWBaseWebVC
- (instancetype)initWithTitle:(NSString *)title andURLString:(nonnull NSString *)urlString{
     return [self initWithTitle:title andURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithTitle:(NSString *)title andURL:(NSURL *)url{
    if (self = [super init]) {
        self.title = title;
        self.webUrl = url;
    }
    return self;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
