//
//  NSString+MD5.m
//  demo2
//
//  Created by 胡蕾蕾 on 16/7/19.
//  Copyright © 2016年 胡丽蕾. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/socket.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>

@implementation NSString (MD5)
- (NSData *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    // NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    //    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    //        [saveResult appendFormat:@"%02x", result[i]];
    //    }
    //    /*
    //     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
    //     NSLog("%02X", 0x888);  888
    //     NSLog("%02X", 0x4); 04
    //     */
    //    return saveResult;
    
    NSData *data = [NSData dataWithBytes:result length:16];
      return data;
}
- (NSDictionary *)stringForParam:(NSString *)operation requestEntity:(NSDictionary *)requestEntity start:(NSString *)start limit:(NSString *)limit serviceId:(NSString *)serviceId{
    NSDictionary *dict = [NSDictionary new];
    NSString *verson = [[NSUserDefaults standardUserDefaults]objectForKey:@"version"];
    if (operation == nil) {
        dict =@{@"requestEntity":requestEntity,@"start":start,@"limit":limit,@"source":@"ios"};
    }else{
        dict =@{@"operation":operation,@"requestEntity":requestEntity,@"start":start,@"limit":limit,@"source":@"ios"};
    }
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&parseError];
    
    NSString *string3 =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *string4 = [string3 stringByAppendingString:@"369f977f8e0ee4201606ca4a11aebb77689de596568ffa"];
    
    NSLog(@"aqaqaqaqaqa%@",string3);
    NSData *infoData = [string4 stringToMD5:string4];
    
    
    NSString *base64Encoded = [infoData base64EncodedStringWithOptions:0];
    NSLog(@"🌹🌹%@",base64Encoded);
    NSDictionary *paramer = @{@"parameter":string3,@"sign":base64Encoded,@"serviceId":serviceId,@"appversion":verson};
    return paramer;
}
- (BOOL)ContentIsEmpty:(NSString *)argText
{
    BOOL pIsEmpty=YES;
    
    ///是否是空格
    NSRange _range = [argText rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        
    }else {
        pIsEmpty = NO;
    }
    return pIsEmpty;
}
- (BOOL)ContentIsAllEmpty:(NSString *)argText{
    BOOL pIsEmpty=YES;
    
    ///是否是空格
    NSRange _range = [argText rangeOfString:@" "];
    if (_range.length == argText.length) {
        //有空格
        
    }else {
        pIsEmpty = NO;
    }
    return pIsEmpty;

}
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
- (NSString *)getDeviceIPIpAddresses

{
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
   // if (sockfd <</span> 0) returnnil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    
    
    
    
    
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++)
        
    {
        
        if (ips.count > 0)
            
        {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
                   }
    }
    
    return deviceIP;
    
}
- (CGSize)DDsizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return CGSizeMake(WIDTH, HEIGHT);
}

@end
