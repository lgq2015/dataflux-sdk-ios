//
//  ZTShowTipButton.m
//  123
//
//  Created by tao on 2019/4/2.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTShowTipButton.h"

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
        _tipBtn.frame = CGRectMake(10, 30, 200, 30);
        _tipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_tipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _tipBtn;
}
@end
