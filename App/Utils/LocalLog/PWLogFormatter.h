//
//  PWLogFormatter.h
//  yunku3
//
//  Created by wqc on 2016/12/22.
//  Copyright © 2016年 wqc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLumberjack.h"

@interface PWLogFormatter : NSObject<DDLogFormatter>

/**
 *  日志格式
 *
 *  @param logMessage 日志信息
 *
 *  @return 返回日志内容
 */
-(NSString *)formatLogMessage:(DDLogMessage *)logMessage;

@end
