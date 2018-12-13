//
//  NSString+verify.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (verify)
/**
 检验是否为手机号
 */
+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;
/**
 检验密码格式是否正确
 */
+ (BOOL)validatePassWordForm:(NSString *)password;
/**
  返回手机型号
 */
+ (NSString *)getCurrentDeviceModel;
@end
