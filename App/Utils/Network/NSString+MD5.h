//
//  NSString+MD5.h
//  demo2
//
//  Created by 胡蕾蕾 on 16/7/19.
//  Copyright © 2016年 胡丽蕾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSData *)stringToMD5:(NSString *)str;
- (NSDictionary *)stringForParam:(NSString *)operation requestEntity:(NSDictionary *)requestEntity start:(NSString *)start limit:(NSString *)limit  serviceId:(NSString *)serviceId;
- (BOOL)ContentIsEmpty:(NSString *)argText;
- (NSString *)getIPAddress;
- (BOOL)ContentIsAllEmpty:(NSString *)argText;
- (NSString *)getDeviceIPIpAddresses;
- (CGSize)DDsizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
@end
