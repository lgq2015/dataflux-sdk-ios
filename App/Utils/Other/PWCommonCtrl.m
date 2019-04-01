//
//  PWCommonCtrl.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWCommonCtrl.h"
#import "BaseTextField.h"

@implementation PWCommonCtrl
+(UIButton *)buttonWithFrame:(CGRect)frame type:(PWButtonType)type text:(NSString *)text{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];

    [button setTitle:text forState:UIControlStateNormal];
    switch (type) {
        case PWButtonTypeBuoy:
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 37;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#0D47A1"]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#01388C"]] forState:UIControlStateHighlighted];
            break;
        case PWButtonTypeWord:
            [button setTitleColor:[UIColor colorWithHexString:@"#027DFB"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#D50000"] forState:UIControlStateDisabled];
            break;
        case PWButtonTypeContain:
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#2A7AF7"]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#01388C"]] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#C7C7CC"]] forState:UIControlStateDisabled];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            break;
        case PWButtonTypeSummarize:
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button setTitleColor:[UIColor colorWithHexString:@"#595860"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#595860"] forState:UIControlStateDisabled];
            
            [button setBackgroundImage:[UIImage imageWithColor:PWBackgroundColor] forState:UIControlStateNormal];
         
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F7F7F7"]] forState:UIControlStateDisabled];
            //设置边框的颜色
            [button.layer setBorderColor:[UIColor colorWithHexString:@"#595860"].CGColor];
            //设置边框的粗细
            [button.layer setBorderWidth:1.0];
//            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                [button.layer setBorderWidth:0];
//            }];
            break;
    }
    return button;
}
+(UIAlertAction *)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *))handler{
    UIAlertAction *alert = [UIAlertAction actionWithTitle:title style:style handler:handler];
    switch (style) {
        case UIAlertActionStyleCancel:
            [alert setValue:PWCancelBtnColor forKey:@"_titleTextColor"];
            break;
        case UIAlertActionStyleDefault:
            [alert setValue:PWDefaultBtnColor forKey:@"_titleTextColor"];
            break;
        case UIAlertActionStyleDestructive:
            [alert setValue:PWDestructiveBtnColor forKey:@"_titleTextColor"];
            break;
    }
    return alert;
}
+(UITextField *)textFieldWithFrame:(CGRect)frame{
   return  [self textFieldWithFrame:frame font:MediumFONT(16)];
}
+(UITextField *)passwordTextFieldWithFrame:(CGRect)frame{
    return  [self passwordTextFieldWithFrame:frame font:MediumFONT(16)];
}
+(UITextField *)passwordTextFieldWithFrame:(CGRect)frame font:(UIFont *)font{
    BaseTextField *tf = [[BaseTextField alloc]initWithFrame:frame];
    [tf setFont:font];
    tf.textColor = PWTextBlackColor;
    //    [tf setValue:PWCancelBtnColor forKeyPath:@"_placeholderLabel.textColor"];
    UILabel *place = [[UILabel alloc]init];
    place.font = font;
    place.textColor =PWTextLight;
    place.numberOfLines = 0;
    [place sizeToFit];
    tf.secureTextEntry = YES;
    [tf addSubview:place];
    [tf setValue:place forKey:@"_placeholderLabel"];
    
    tf.clearButtonMode=UITextFieldViewModeWhileEditing;
    tf.textAlignment = NSTextAlignmentLeft;
    return tf;
}
+(UITextField *)textFieldWithFrame:(CGRect)frame font:(UIFont *)font{
    UITextField *tf = [[UITextField alloc]initWithFrame:frame];
    [tf setFont:font];
    tf.textColor = PWTextBlackColor;
//    [tf setValue:PWCancelBtnColor forKeyPath:@"_placeholderLabel.textColor"];
    UILabel *place = [[UILabel alloc]init];
    place.font = font;
    place.textColor =PWTextLight;
    place.numberOfLines = 0;
    [place sizeToFit];
    
    [tf addSubview:place];
    [tf setValue:place forKey:@"_placeholderLabel"];

    tf.clearButtonMode=UITextFieldViewModeWhileEditing;
    tf.textAlignment = NSTextAlignmentLeft;
    return tf;
}
+(UITextView *)textViewWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder font:(UIFont *)font{
    UITextView *textView = [[UITextView alloc]initWithFrame:frame];
    [textView setFont:font];
    textView.textColor = PWTextBlackColor;
    [textView setValue:PWCancelBtnColor forKeyPath:@"_placeholderLabel.textColor"];

    UILabel *place = [[UILabel alloc]init];
    place.text = placeHolder;
    place.font = font;
    place.textColor =PWTextLight;
    place.numberOfLines = 0;
    [place sizeToFit];

    [textView addSubview:place];
    [textView setValue:place forKey:@"_placeholderLabel"];
    return textView;
}
+(UILabel *)lableWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text{
    UILabel *lable = [[UILabel alloc]initWithFrame:frame];
    lable.font = font;
    lable.textColor = color;
    lable.text = text;
    return lable;
}
@end
