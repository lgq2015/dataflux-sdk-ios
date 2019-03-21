//
//  NSDate+PWH.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (PWH)
- (BOOL)isThisYear;
/**
 
 时间戳
 */
+(NSString *)getNowTimeTimestamp;

-(NSString *)currentYearTimeStr;
-(NSString *)yearMonthDayTimeStr;
-(NSString *)currentYearHourMinutesTimeStr;
-(NSString *)hourMinutesTimeStr;
-(NSString *)yearMonthDayHourMinutesTimeStr;

@end

NS_ASSUME_NONNULL_END
