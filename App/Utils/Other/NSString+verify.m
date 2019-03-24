//
//  NSString+verify.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "NSString+verify.h"
#import <sys/utsname.h>

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


+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:formatter];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
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
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <7){
        result = [NSString stringWithFormat:@"%ld天前",temp];
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
- (NSString *)accurateTimeStr{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:self];
    NSString *timeStr;
    if ([timeDate isToday]) {
        timeStr = [NSString stringWithFormat:@"今天 %@",[timeDate hourMinutesTimeStr]];
    }else if([timeDate isYesterday]){
        timeStr = [NSString stringWithFormat:@"昨天 %@",[timeDate hourMinutesTimeStr]];
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
    NSString *pDomainCheck = @"^[a-zA-Z0-9](-?[a-zA-Z0-9]+)*(\\.[a-zA-Z0-9](-?[a-zA-Z0-9]+)*)+$";
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
+ (NSString *)progressLabText:(NSDictionary *)dict{
    NSString *time = dict[@"updateTime"];
    NSString *local = [NSString getLocalDateFormateUTCDate:time formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *needTime = [NSString compareCurrentTime:local];
    NSString *subType = dict[@"subType"];
    __block  NSString *type;
    
    if ([subType isEqualToString:@"issueCreated"]) {
        type = @"情报创建";
    }else if([subType isEqualToString:@"issueRecovered"]){
        type = @"情报恢复";
    }else if([subType isEqualToString:@"issueExpired"]){
        type = @"情报失效";
    }else if([subType isEqualToString:@"ticketClosed"]){
        type = @"专家退出讨论";
    }else if([subType isEqualToString:@"issueDiscarded"]){
        type = @"情报失效";
    }
    else if([subType isEqualToString:@"updateExpertGroups"]){
        NSDictionary *metaJSON = dict[@"metaJSON"];
        NSArray *expertGroups = metaJSON[@"expertGroups"];
        [userManager getExpertNameByKey:expertGroups[0] name:^(NSString *name) {
            type =[NSString stringWithFormat:@"%@加入讨论",name];
        }];
    }
    return [NSString stringWithFormat:@"%@  %@",needTime,type];
}
- (NSString *)getTimeFromTimestamp{
    NSTimeInterval interval  =[self doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd\nHH:mm"];
    NSString *dateString  = [formatter stringFromDate: date];
    return dateString;
}
- (NSString *)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"M",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%0.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

@end
