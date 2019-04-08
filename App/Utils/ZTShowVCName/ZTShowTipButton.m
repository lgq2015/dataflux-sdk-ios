//
//  ZTShowTipButton.m
//  123
//
//  Created by tao on 2019/4/2.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTShowTipButton.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)

@implementation ZTShowTipButton
+ (instancetype)shareInstance{
    static ZTShowTipButton *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZTShowTipButton alloc] init];
    });
    return instance;
}
- (UIButton *)tipBtn{
    if (!_tipBtn){
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(IS_IPHONE_6){
            _tipBtn.frame = CGRectMake(10, 10, 200, 30);
        }else{
            _tipBtn.frame = CGRectMake(10, 30, 200, 30);
        }
        _tipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _tipBtn.userInteractionEnabled = NO;
        [_tipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _tipBtn;
}
@end
