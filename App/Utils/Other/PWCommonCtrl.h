//
//  PWCommonCtrl.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

typedef NS_ENUM(NSInteger, PWButtonType) {
    PWButtonTypeWord = 0,         //文字按钮
    PWButtonTypeSummarize = 1,    //概述按钮
    PWButtonTypeContain,          //包含按钮
    PWButtonTypeBuoy,             //浮标按钮
};
NS_ASSUME_NONNULL_BEGIN
@interface PWCommonCtrl : NSObject
@property (nonatomic, assign) NSString *placeHolder;
+(UIButton *)buttonWithFrame:(CGRect)frame
                          type:(PWButtonType)type
                          text:(NSString *)text;

+(UIAlertAction *)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;
+(UITextField *_Nullable)textFieldWithFrame:(CGRect)frame;
+(UITextField *_Nullable)textFieldWithFrame:(CGRect)frame font:(UIFont *_Nullable)font;
+(UITextView *_Nullable)textViewWithFrame:(CGRect)frame placeHolder:(NSString *_Nullable)placeHolder font:(UIFont *_Nullable)font;
+(UILabel *_Nullable)lableWithFrame:(CGRect)frame font:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text;
+(UITextField *_Nullable)passwordTextFieldWithFrame:(CGRect)frame font:(UIFont *_Nullable)font;
+(UITextField *_Nullable)passwordTextFieldWithFrame:(CGRect)frame;
+(YYLabel *_Nullable)zy_lableWithFrame:(CGRect)frame font:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nonnull)text;
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)style;
@end
NS_ASSUME_NONNULL_END
