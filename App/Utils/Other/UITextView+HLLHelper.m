//
//  UITextView+HLLHelper.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UITextView+HLLHelper.h"

@implementation UITextView (HLLHelper)
//限制UITextView的输入字数.0表示无限制.
- (NSInteger)hll_limitTextLength
{
    NSNumber *limit = objc_getAssociatedObject(self, @selector(hll_limitTextLength));
    return limit.integerValue;
}

- (void)setHll_limitTextLength:(NSInteger)hll_limitTextLength
{
    objc_setAssociatedObject(self, @selector(hll_limitTextLength), @(hll_limitTextLength), OBJC_ASSOCIATION_ASSIGN);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textViewTextDidChanged:(NSNotification *)notify
{
    if (self.hll_limitTextLength <= 0) {
        return;
    }
    
    UITextView *textView = notify.object;
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了.防止系统中文键盘输入bug
    if (selectedRange && pos) {
        return;
    }
    
    NSRange selection = textView.selectedRange;
    
//    NSInteger realLength = textView.text.length; //实际总长度
    
    NSString *headText = [textView.text substringToIndex:selection.location]; //光标前的文本
    NSString *tailText = [textView.text substringFromIndex:selection.location]; //光标后的文本
    
//    NSInteger restLength = self.hll_limitTextLength - tailText.length; //光标后允许输入的文本长度
    NSInteger len = [textView.text charactorNumber];

    if (len > self.hll_limitTextLength) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
        NSString *subHeadText = [headText subStringWithLength:2000];;
        textView.text = [subHeadText stringByAppendingString:tailText];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

@end
