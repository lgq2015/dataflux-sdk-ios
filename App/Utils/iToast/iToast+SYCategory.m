//
//  iToast+SYCategory.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/7/30.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "iToast+SYCategory.h"

@implementation iToast (SYCategory)

// 实例化iToast
+ (void)alertWithTitle:(NSString *)title
{
    if ([self isNullNSStringWithText:title])
    {
        return ;
    }
    
    [[iToast shareIToast] showText:title postion:iToastPositionTop];
}

+ (void)alertWithTitleCenter:(NSString *)title
{
    if ([self isNullNSStringWithText:title])
    {
        return ;
    }
    
    [[iToast shareIToast] showText:title postion:iToastPositionCenter];
}

+ (void)alertWithTitleBottom:(NSString *)title
{
    if ([self isNullNSStringWithText:title])
    {
        return ;
    }
    
    [[iToast shareIToast] showText:title postion:iToastPositionBottom];
}

// 隐藏iToast
+ (void)hiddenIToast
{
    [[iToast shareIToast] hidden];
}

/// 字符非空判断（可以是空格字符串）
+ (BOOL)isNullNSStringWithText:(NSString *)text
{
    if (!text || [text isEqualToString:@""] || 0 == text.length)
    {
        return YES;
    }
    
    return NO;
}


+(void)alertWithTitleCenter:(NSString *)title delay:(NSInteger)seconds {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self alertWithTitleCenter:title];
    });

}

@end
