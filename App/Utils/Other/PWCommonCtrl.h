//
//  PWCommonCtrl.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PWButtonType) {
    PWButtonTypeWord = 0,         //文字按钮
    PWButtonTypeSummarize = 1,    //概述按钮
    PWButtonTypeContain,          //包含按钮
    PWButtonTypeBuoy,             //浮标按钮
};

@interface PWCommonCtrl : NSObject
@property (nonatomic, assign) NSString *placeHolder;
+(UIButton *)buttonWithFrame:(CGRect)frame
                          type:(PWButtonType)type
                          text:(NSString *)text;

+(UIAlertAction *)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler;
+(UITextField *)textFieldWithFrame:(CGRect)frame;
+(UITextView *)textViewWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder;
@end

