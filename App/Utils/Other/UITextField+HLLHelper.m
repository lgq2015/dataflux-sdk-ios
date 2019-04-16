//
//  UITextField+HLLHelper.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UITextField+HLLHelper.h"

@implementation UITextField (HLLHelper)
- (NSInteger)hll_limitTextLength
{
    NSNumber *limit = objc_getAssociatedObject(self, @selector(hll_limitTextLength));
    return limit.integerValue;
}
- (void)setHll_limitTextLength:(NSInteger)hll_limitTextLength
{
    objc_setAssociatedObject(self, @selector(hll_limitTextLength), @(hll_limitTextLength), OBJC_ASSOCIATION_ASSIGN);
    
    [self removeTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextDidChanged:(UITextField *)textField
{
    if (self.hll_limitTextLength <= 0) {
        return;
    }
    
    NSString *contentText = textField.text;
    //防止系统中文键盘输入bug
    // 获取高亮内容的范围
    UITextRange *selectedRange = [textField markedTextRange];
    // 获取高亮内容的长度
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    // 没有高亮内容时,对已输入的文字进行操作
    if (markedTextLength == 0) {
        NSInteger len = [contentText charactorNumber];
        if (len > self.hll_limitTextLength) {
            [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
            // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range.(eg:😈)
        
            NSString *rsStr = [contentText subStringWithLength:self.hll_limitTextLength];
            
            textField.text = rsStr;
        }
    }
}
@end
