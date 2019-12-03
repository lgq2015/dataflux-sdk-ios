//
//  ZYDeviceInfoHander.m
//  ft-sdk-ios
//
//  Created by 胡蕾蕾 on 2019/12/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZYDeviceInfoHander.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
@implementation ZYDeviceInfoHander
+ (NSString *)getDeviceType{
    struct utsname systemInfo;
     uname(&systemInfo);
     NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
     
     //------------------------------iPhone---------------------------
     if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
     if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
     if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
     if ([platform isEqualToString:@"iPhone3,1"] ||
         [platform isEqualToString:@"iPhone3,2"] ||
         [platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
     if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
     if ([platform isEqualToString:@"iPhone5,1"] ||
         [platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
     if ([platform isEqualToString:@"iPhone5,3"] ||
         [platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
     if ([platform isEqualToString:@"iPhone6,1"] ||
         [platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
     if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
     if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
     if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
     if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
     if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
     if ([platform isEqualToString:@"iPhone9,1"] ||
         [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
     if ([platform isEqualToString:@"iPhone9,2"] ||
         [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
     if ([platform isEqualToString:@"iPhone10,1"] ||
         [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
     if ([platform isEqualToString:@"iPhone10,2"] ||
         [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
     if ([platform isEqualToString:@"iPhone10,3"] ||
         [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
     if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
     if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
     if ([platform isEqualToString:@"iPhone11,4"] ||
         [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
     if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
     if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
     if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";

     //------------------------------iPad--------------------------
     if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
     if ([platform isEqualToString:@"iPad2,1"] ||
         [platform isEqualToString:@"iPad2,2"] ||
         [platform isEqualToString:@"iPad2,3"] ||
         [platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
     if ([platform isEqualToString:@"iPad3,1"] ||
         [platform isEqualToString:@"iPad3,2"] ||
         [platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
     if ([platform isEqualToString:@"iPad3,4"] ||
         [platform isEqualToString:@"iPad3,5"] ||
         [platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
     if ([platform isEqualToString:@"iPad4,1"] ||
         [platform isEqualToString:@"iPad4,2"] ||
         [platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
     if ([platform isEqualToString:@"iPad5,3"] ||
         [platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
     if ([platform isEqualToString:@"iPad6,3"] ||
         [platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
     if ([platform isEqualToString:@"iPad6,7"] ||
         [platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
     if ([platform isEqualToString:@"iPad6,11"] ||
         [platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
     if ([platform isEqualToString:@"iPad7,11"] ||
         [platform isEqualToString:@"iPad7,12"]) return @"iPad 6";
     if ([platform isEqualToString:@"iPad7,1"] ||
         [platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
     if ([platform isEqualToString:@"iPad7,3"] ||
         [platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
     
     //------------------------------iPad Mini-----------------------
     if ([platform isEqualToString:@"iPad2,5"] ||
         [platform isEqualToString:@"iPad2,6"] ||
         [platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
     if ([platform isEqualToString:@"iPad4,4"] ||
         [platform isEqualToString:@"iPad4,5"] ||
         [platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
     if ([platform isEqualToString:@"iPad4,7"] ||
         [platform isEqualToString:@"iPad4,8"] ||
         [platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
     if ([platform isEqualToString:@"iPad5,1"] ||
         [platform isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
     
     //------------------------------iTouch------------------------
     if ([platform isEqualToString:@"iPod1,1"]) return @"iTouch";
     if ([platform isEqualToString:@"iPod2,1"]) return @"iTouch2";
     if ([platform isEqualToString:@"iPod3,1"]) return @"iTouch3";
     if ([platform isEqualToString:@"iPod4,1"]) return @"iTouch4";
     if ([platform isEqualToString:@"iPod5,1"]) return @"iTouch5";
     if ([platform isEqualToString:@"iPod7,1"]) return @"iTouch6";
     
     //------------------------------Samulitor-------------------------------------
     if ([platform isEqualToString:@"i386"] ||
         [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
     
     return @"Unknown";
}
+(NSString *)getTelephonyInfo     // 获取运营商信息
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier;
    if (@available(iOS 12.0, *)) {
       if (info && [info respondsToSelector:@selector(serviceSubscriberCellularProviders)]) {
                  
                NSDictionary *dic = [info serviceSubscriberCellularProviders];
                if (dic.allKeys.count) {
                    carrier = [dic objectForKey:dic.allKeys[0]];
                }
              }
    }else{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            // 这部分使用到的过期api
        carrier= [info subscriberCellularProvider];
        #pragma clang diagnostic pop
        
    }
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    return mCarrier;
}
+ (NSString *)resolution {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    return [[NSString alloc] initWithFormat:@"%.fx%.f",rect.size.height*scale,rect.size.width*scale];
}
@end
