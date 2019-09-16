//
//  NSString+verify.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "NSString+verify.h"
#import <sys/utsname.h>
#import "IssueListManger.h"
@implementation NSString (verify)


- (BOOL)validatePassWordForm{
    ///^(?![A-Za-z]+$)(?![\W]+$)(?![0-9]+$)[^\u4e00-\u9fa5]{8,25}$/
    NSString *pPhone = @"^(?![A-Za-z]+$)(?![\\W_]+$)(?![0-9]+$)[\x00-\x7F]{8,25}$";
    NSPredicate *pPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pPhone];
    return [pPhoneTest evaluateWithObject:self];
}
- (BOOL)validatePhoneNumber{
    NSString *pPhone = @"^1\\d{10}$";
    NSPredicate *pPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pPhone];
    return [pPhoneTest evaluateWithObject:self];
}
+ (NSString *)getCurrentDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

- (BOOL)validateEmail{
    NSString *pEmailCheck = @"^[A-Za-z0-9\u4e00-\u9fa5]+([._\\-]*[A-Za-z0-9\u4e00-\u9fa5])*@[A-Za-z0-9_-\u4e00-\u9fa5]+(\\.[A-Za-z0-9_-\u4e00-\u9fa5]+)+$";
    NSPredicate *pEmailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pEmailCheck];
    return [pEmailTest evaluateWithObject:self];
}
-(BOOL)validateSpecialCharacter{
  //  /^[a-zA-Z0-9-_\s\u4e00-\u9fa5]+$/
    NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值

   
    if([other rangeOfString:self].location != NSNotFound){
        return YES;
    }
    
    
    NSString *specialCharacter = @"^[a-zA-Z0-9-_\\s\u4e00-\u9fa5]+$";
    NSPredicate *pTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",specialCharacter];
    return [pTest evaluateWithObject:self];
}

+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate formatter:(NSString *)formatter{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //输入格式
//    [dateFormatter setDateFormat:formatter];
//    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
//    [dateFormatter setTimeZone:localTimeZone];
//    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
//    //输出格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return [NSString getLocalDateFormateUTCDate:utcDate formatter:formatter outdateFormatted:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate formatter:(NSString *)formatter outdateFormatted:(NSString *)dateFormatted{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:formatter];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatteds = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:dateFormatted];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatteds];
    return dateString;
}
+ (NSString *)yearMonthDayDateUTC:(NSString *)utcDate formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:formatter];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
+ (NSString *)compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = NSLocalizedString(@"local.Date.JustRecently", @"");
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:NSLocalizedString(@"local.Date.MinutesAgo", @""),temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:NSLocalizedString(@"local.Date.HoursAgo", @""),temp];
    }
    else if((temp = temp/24) <7){
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *fromDate;
        NSDate *toDate;
        [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:timeDate];
        [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:currentDate];
        NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
        result = [NSString stringWithFormat:NSLocalizedString(@"local.Date.DaysAgo", @""),dayComponents.day];
        if (dayComponents.day == 7) {
            result = [timeDate yearMonthDayTimeStr];
        }
    }
    else {
        if([timeDate isThisYear]){
        result = [timeDate currentYearTimeStr];
        }else{
        result = [timeDate yearMonthDayTimeStr];
        }
    }
    return  result;
}
+ (NSString *)compareCurrentTimeSustainTime:(NSString *)str{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp,tempHour,tempDay = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = NSLocalizedString(@"local.Date.JustRecently", @"");
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:NSLocalizedString(@"local.Date.LastMinute", @""),temp];
    }
    else if((tempHour = temp/60) <24){
        long min =temp%60;
        result = [NSString stringWithFormat:NSLocalizedString(@"local.Date.LastHourMinute", @""),tempHour,min];
    }
    else if((tempDay = tempHour/24) <7){
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *fromDate;
        NSDate *toDate;
        [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:timeDate];
        [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:currentDate];
        NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
        result = [NSString stringWithFormat:NSLocalizedString(@"local.Date.LastDay", @""),dayComponents.day];
        if (dayComponents.day == 7) {
            result = NSLocalizedString(@"local.Date.LastingMoreThan1Week", @"");
        }
    }
    else {
        result = NSLocalizedString(@"local.Date.LastingMoreThan1Week", @"");
    }
    return  result;
}
- (NSString *)listAccurateTimeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:self];
    NSString *timeStr;
    if ([timeDate isToday]) {
        timeStr = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"local.TodayDate", @""),[timeDate hourMinutesTimeStr]];
    }else if([timeDate isYesterday]){
        timeStr = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"local.Date.Yesterday", @""),[timeDate hourMinutesTimeStr]];
    }else if([timeDate isThisYear]){
        timeStr = [timeDate listThisYearHourMinutesFormatTimeStr];
    }else{
        timeStr = [timeDate listYearMonthDayHourMinutesFormatTimeStr];
    }
    return timeStr;
}
- (NSString *)accurateTimeStr{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:self];
    NSString *timeStr;
    if ([timeDate isToday]) {
        timeStr = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"local.TodayDate", @""),[timeDate hourMinutesTimeStr]];
    }else if([timeDate isYesterday]){
        timeStr = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"local.Date.Yesterday", @""),[timeDate hourMinutesTimeStr]];
    }else if([timeDate isThisYear]){
        timeStr = [timeDate currentYearHourMinutesTimeStr];
    }else{
        timeStr = [timeDate yearMonthDayHourMinutesTimeStr];
    }
    return timeStr;
}
- (BOOL)validateTopLevelDomain{
    NSString *lowStr=[self lowercaseString];

    if ([lowStr rangeOfString:@"www."].location != NSNotFound) {
        return NO;
    }
    NSString *pDomainCheck = @"^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$";
    NSPredicate *pDomainTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pDomainCheck];
    return [pDomainTest evaluateWithObject:lowStr];
}
- (BOOL)timeIntervalAboveThirtySecond{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double beTime = [self doubleValue];
    double distanceTime = now - beTime;
    
    if (distanceTime < 30){
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)validateNumber {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (BOOL)isUrlAddress{
    NSString *reg =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [urlPredicate evaluateWithObject:self];
}

- (NSString *)getIssueStateLevel{
    NSString *level;
    if ([self isEqualToString:@"danger"]) {
        level = NSLocalizedString(@"local.danger", @"");
    }else if([self isEqualToString:@"info"]){
        level = NSLocalizedString(@"local.info", @"");
    }else{
        level = NSLocalizedString(@"local.warning", @"");
    }
    return level;
}
- (NSString *)getTimeFromTimestamp{
    NSTimeInterval interval  =[self doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm\nMM-dd"];
    NSString *dateString  = [formatter stringFromDate: date];
    return dateString;
}
+ (NSString *)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"M",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%.f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}
//获取字符串的字节数
- (NSUInteger )charactorNumber
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}
//切割字符串
-(NSString *)subStringWithLength:(NSInteger )count
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [self dataUsingEncoding:enc];
    NSData * subData;
        subData = [data subdataWithRange:NSMakeRange(0, count)];
    if (![[NSString alloc] initWithData:subData encoding:enc]) {
         subData = [data subdataWithRange:NSMakeRange(0, count-1)];
    }
    
    return [[NSString alloc] initWithData:subData encoding:enc];
}
- (NSString *)removeFrontBackBlank{
    NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *str = [self stringByTrimmingCharactersInSet:set];
    return str;
}
-(BOOL)stringContainsEmoji
{
    NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值
    
    
    if([other rangeOfString:self].location != NSNotFound){
        return NO;
    }
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}
- (NSString *)imageTransStr{
 return    (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,kCFStringEncodingUTF8));
}
-(CGSize)strSizeWithMaxWidth:(CGFloat)width withFont:(UIFont*)font{
    if (@available(iOS 7.0, *)) {
        return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    } else {
        return CGSizeZero;
        
    }
}
- (BOOL) deptNumInputShouldNumber
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
- (NSString *)dealWithTimeFormatted{
    
    NSArray *sepAry = [self componentsSeparatedByString:@":"];
    BOOL containT = [self containsString:@"T"];
    if (sepAry.count == 3 && containT) {
        NSString *last =  [sepAry lastObject];
        if ([last componentsSeparatedByString:@"."].count == 1) {
            NSString *time = [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@":%@",sepAry[2]] withString:@""];
        return  [NSString getLocalDateFormateUTCDate:time formatter:@"yyyy-MM-dd'T'HH:mm" outdateFormatted:@"HH:mm\nMM-dd"];
        }else if([last componentsSeparatedByString:@"."].count == 2){
         NSString *newTime = [self stringByReplacingOccurrencesOfString:[[last componentsSeparatedByString:@"."] lastObject] withString:@""];
        return  [NSString getLocalDateFormateUTCDate:newTime formatter:@"yyyy-MM-dd'T'HH:mm:ss" outdateFormatted:@"HH:mm\nMM-dd"];
        }
        }
        return self;
    
}
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}
- (NSString *)getOriginStr{
    if ([self isEqualToString:@"user"]) {
        return NSLocalizedString(@"local.selfBuild", @"");
    }else if([self isEqualToString:@"bizSystem"]){
        return NSLocalizedString(@"local.system", @"");
    }else if([self isEqualToString:@"crontab"] || [self isEqualToString:@"issueEngine"]){
        return NSLocalizedString(@"local.diagnose", @"");
    }else if([self isEqualToString:@"alertHub"]){
        return NSLocalizedString(@"local.CustomSource", @"");
    }else if([self isEqualToString:ILMStringAll]){
        return NSLocalizedString(@"local.AllOrigin", @"");
    }else if([self isEqualToString:@""] || [self isEqualToString:NSLocalizedString(@"local.TheUnknownSources", @"")]){
        return [NSString stringWithFormat:@"<%@>",NSLocalizedString(@"local.TheUnknownSources", @"")];
    }else{
        return self;
    }
  
}
- (NSString *)getIssueTypeStr{
    if ([self isEqualToString:@"alarm"]) {
        return NSLocalizedString(@"local.alarm", @"");
    }else if([self isEqualToString:@"security"]){
        return NSLocalizedString(@"local.security", @"");
    }else if([self isEqualToString:@"expense"]){
        return NSLocalizedString(@"local.expense", @"");
    }else if([self isEqualToString:@"optimization"]){
        return NSLocalizedString(@"local.optimization", @"");
    }else if([self isEqualToString:@"misc"]){
        return NSLocalizedString(@"local.misc", @"");
    }else if([self isEqualToString:@"report"]){
        return NSLocalizedString(@"local.report", @"");
    }else if([self isEqualToString:@"task"]){
         return NSLocalizedString(@"local.task", @"");
    }else{
        return self;
    }
}
- (NSString *)getIssueSourceIcon{
    NSString *icon;
    if ([self isEqualToString:@"carrier.corsairmaster"]){
        icon = @"icon_foresight_small";
    }else if([self isEqualToString:@"aliyun"]) {
        icon = @"icon_alis";
    }else if([self isEqualToString:@"qcloud"]){
        icon = @"icon_tencent_small";
    }else if([self isEqualToString:@"aws"]){
        icon = @"icon_aws_small";
    }else if([self isEqualToString:@"ucloud"]){
        icon = @"icon_tencent_small";
    }else if ([self isEqualToString:@"domain"]){
        icon = @"icon_domainname_small";
    }else if([self isEqualToString:@"carrier.corsair"]){
        icon =@"icon_mainframe_small";
    }else if([self isEqualToString:@"carrier.alert"]){
        icon = @"message_docks";
    }else if ([self isEqualToString:@"aliyun.finance"]){
        icon = @"icon_alis";
    }else if ([self isEqualToString:@"aliyun.cainiao"]){
        icon = @"cainiao_s";
    }else if([self isEqualToString:@"CUSTOM"]){
        icon = @"source_customs";
    }
    return icon;
}
- (NSString *)getFileIcon{
    NSString *fileIcon;
    if ([self isEqualToString:@"pdf"]) {
        fileIcon = @"file_PDF";
    }else if([self isEqualToString:@"docx"]||[self isEqualToString:@"doc"]){
        fileIcon = @"file_word";
    }else if([self isEqualToString:@"jpg"]||[self isEqualToString:@"png"]||[self isEqualToString:@"jpeg"]){
        fileIcon = @"file_img";
    }else if([self isEqualToString:@"ppt"] ||[self isEqualToString:@"pptx"]){
        fileIcon = @"file_PPT";
    }else if([self isEqualToString:@"xlsx"]||[self isEqualToString:@"xls"]||[self isEqualToString:@"csv"]){
        fileIcon = @"file_excel";
    }else if([self isEqualToString:@"key"]){
        fileIcon = @"file_keynote";
    }else if([self isEqualToString:@"numbers"]){
        fileIcon = @"file_numbers";
    }else if([self isEqualToString:@"pages"]){
        fileIcon = @"file_pages";
    }else if([self isEqualToString:@"zip"]){
        fileIcon = @"file_zip";
    }else if([self isEqualToString:@"rar"]){
        fileIcon = @"file_rar";
    }else if([self isEqualToString:@"txt"]){
        fileIcon = @"file_txt";
    }else{
        fileIcon = @"file";
    }
    return fileIcon;
}
@end
