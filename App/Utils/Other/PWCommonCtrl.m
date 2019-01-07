//
//  PWCommonCtrl.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWCommonCtrl.h"

@implementation PWCommonCtrl
+(UIButton *)buttonWithFrame:(CGRect)frame type:(PWButtonType)type text:(NSString *)text{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    switch (type) {
        case PWButtonTypeBuoy:
            break;
        case PWButtonTypeWord:
            [button setTitleColor:[UIColor colorWithHexString:@"#027DFB"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#D50000"] forState:UIControlStateDisabled];
            break;
        case PWButtonTypeContain:
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#0D47A1"]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#01388C"]] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#6790D1"]] forState:UIControlStateDisabled];
            break;
        case PWButtonTypeSummarize:
            break;
    }
    return button;
}
-(UIButton *)WordButtonWithFrame:(CGRect)frame text:(NSString *)text{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    return button;
}
@end
