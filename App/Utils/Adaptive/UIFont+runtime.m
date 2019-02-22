//
//  UIFont+runtime.m
//  InfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/20.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "UIFont+runtime.h"
#import <objc/runtime.h>
#define MyUIScreen  375.0 // UI设计原型图的手机尺寸宽度(6), 6p的--414

@implementation UIFont (runtime)
+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    Method newMethod2 = class_getClassMethod([self class], @selector(fontWithName:adjustSize:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
    
    Method method2 = class_getClassMethod([self class], @selector(fontWithName:size:));
    method_exchangeImplementations(newMethod2, method2);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize];//* [UIScreen mainScreen].bounds.size.width/MyUIScreen
    return newFont;
}
+ (UIFont *)fontWithName:(NSString *)fontName adjustSize:(CGFloat)fontSize{
    UIFont *nameFont = nil;
    nameFont = [UIFont fontWithName:fontName adjustSize:fontSize * [UIScreen mainScreen].bounds.size.width/MyUIScreen];
    return nameFont;
}
@end
