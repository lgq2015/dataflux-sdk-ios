//
//  NSDate+PWH.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NSDate+PWH.h"

@implementation NSDate (PWH)
- (BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return selfCmps.year == nowCmps.year;
    
}
/**
 *  返回这种格式的日期 yyyy-MM-dd
 */
- (NSDate *)dateWithPWH
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}
-(NSString *)currentYearTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return  selfStr;
}
-(NSString *)yearMonthDayTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}
-(NSString *)currentYearHourMinutesTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日 HH:mm";
    NSString *selfStr = [fmt stringFromDate:self];
    return  selfStr;
}
-(NSString *)hourMinutesTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}
-(NSString *)yearMonthDayHourMinutesTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}


@end
