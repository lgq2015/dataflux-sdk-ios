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
    fmt.dateFormat = [NSString stringWithFormat:@"MM %@ dd %@",NSLocalizedString(@"local.Date.Month", @""),NSLocalizedString(@"local.Date.Day", @"")];
    NSString *selfStr = [fmt stringFromDate:self];
    return  selfStr;
}
-(NSString *)yearMonthDayTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat =[NSString stringWithFormat:@"yyyy%@MM%@dd%@",NSLocalizedString(@"local.Date.Year", @""),NSLocalizedString(@"local.Date.Month", @""),NSLocalizedString(@"local.Date.Day", @"")];
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}
-(NSString *)listThisYearHourMinutesFormatTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = [NSString stringWithFormat:@"MM %@ dd %@",NSLocalizedString(@"local.Date.Month", @""),NSLocalizedString(@"local.Date.Day", @"")];
    NSString *selfStr = [fmt stringFromDate:self];
    return  selfStr;
}
-(NSString *)currentYearHourMinutesTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat =[NSString stringWithFormat:@"MM %@ dd %@ HH:mm",NSLocalizedString(@"local.Date.Month", @""),NSLocalizedString(@"local.Date.Day", @"")];
    NSString *selfStr = [fmt stringFromDate:self];
    return  selfStr;
}
-(NSString *)hourMinutesTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}
-(NSString *)listYearMonthDayHourMinutesFormatTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd%@",NSLocalizedString(@"local.Date.Year", @""),NSLocalizedString(@"local.Date.Month", @""),NSLocalizedString(@"local.Date.Day", @"")];
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}
-(NSString *)yearMonthDayHourMinutesTimeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat =[NSString stringWithFormat:@"yyyy%@MM%@dd%@ HH:mm",NSLocalizedString(@"local.Date.Year", @""),NSLocalizedString(@"local.Date.Month", @""),NSLocalizedString(@"local.Date.Day", @"")];
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}
+(NSString *)getCurrentTimestamp{
    
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
-(NSString *)getNowUTCTimeStr{
    return [[NSDate date] getUTCTimeStr];
}
- (NSString *)getTimeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //   createTime    __NSCFString *    @"2019-04-10T12:21:45.000Z"    0x00000001708527b0
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}
- (NSString *)getMonthDayTimeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MM-dd"];
    //   createTime    __NSCFString *    @"2019-04-10T12:21:45.000Z"    0x00000001708527b0
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}
-(NSString *)getUTCTimeStr{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
     //   createTime    __NSCFString *    @"2019-04-10T12:21:45.000Z"    0x00000001708527b0
        NSString *dateString = [dateFormatter stringFromDate:self];
        
        return dateString;
}
-(NSArray *)getDateMonthFirstLastDayTimeStamp{
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:self];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }
    NSInteger firstTime =[[NSNumber numberWithDouble:[firstDate timeIntervalSince1970]] integerValue];
    NSInteger lastTime =[[NSNumber numberWithDouble:[lastDate timeIntervalSince1970]] integerValue];

    return @[[NSNumber numberWithInteger:firstTime], [NSNumber numberWithInteger:lastTime]];
}
- (NSInteger )getTimeStamp
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
   
  
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setYear:[self year]?:0];
    [datecomps setMonth:[self month]?:0];
    [datecomps setDay:[self day]?:0];
    NSDate *calculatedate = [calendar dateFromComponents:datecomps];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    DLog(@"[self year] == %ld,[self month] == %ld,[self day] == %ld,calculatedate ==%@ ",[self year],[self month],[self day],calculatedate);

    return [calculatedate timeIntervalSince1970];
    
    
}

- (NSString *)getCalenarTimeStr{
    NSString *week;
    switch ((long)[self weekday]) {
        case 1:
            week = NSLocalizedString(@"local.Sunday", @"");
            break;
        case 2:
            week = NSLocalizedString(@"local.Monday", @"");
            break;
        case 3:
            week = NSLocalizedString(@"local.Tuesday", @"");
            break;
        case 4:
            week = NSLocalizedString(@"local.Wednesday", @"");
            break;
        case 5:
            week = NSLocalizedString(@"local.Thursday", @"");
            break;
        case 6:
            week = NSLocalizedString(@"local.Friday", @"");
            break;
        case 7:
            week = NSLocalizedString(@"local.Saturday", @"");
            break;
    }
    if([self isThisYear]){
        return [NSString stringWithFormat:@"%ld %@ %ld %@ %@",(long)[self month],NSLocalizedString(@"local.Date.Month", @""),(long)[self day],NSLocalizedString(@"local.Date.Day", @""),week];
    }else{
       return [NSString stringWithFormat:@"%ld%@ %ld %@ %ld %@ %@",(long)[self year],NSLocalizedString(@"local.Date.Year", @""),(long)[self month],NSLocalizedString(@"local.Date.Month", @""),(long)[self day],NSLocalizedString(@"local.Date.Day", @""),week];
    }
}
- (NSDate *)beginningOfMonth{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *componentsCurrentDate =[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:self];
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.weekday = calendar.firstWeekday;
    
    return [calendar dateFromComponents:componentsNewDate];
    
}
- (NSArray *)getMonthBeginAndEnd{

      NSDate *newDate=self;
      double interval = 0;
      NSDate *beginDate = nil;
      NSDate *endDate = nil;
      NSCalendar *calendar = [NSCalendar currentCalendar];
      [calendar setFirstWeekday:1];//设定周一为周首日
      BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
     //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
     if (ok) {
         endDate = [beginDate dateByAddingTimeInterval:interval-1];
       }else {
           return @[];
       }
       return @[beginDate,endDate];
}
@end
