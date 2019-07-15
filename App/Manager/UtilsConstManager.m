//
//  UtilsConstManager.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UtilsConstManager.h"

@implementation UtilsConstManager
- (void)getserviceCodeNameByKey:(NSString *)key name:(void(^)(NSString *name))name{
    NSString *nameStr = [self privateGetServiceCodNameByKey:key];
    if ([nameStr isEqualToString:@""]) {
        [self loadServiceCodeName:^(NSDictionary *experGroups) {
            name? name([self privateGetServiceCodNameByKey:key]):nil;
        }];
    }else{
        name? name(nameStr):nil;
    }
}
- (NSString *)privateGetServiceCodNameByKey:(NSString *)keys{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    NSDictionary *serviceCode = (NSDictionary *)[cache objectForKey:KTeamServiceCode];
    if (serviceCode.allKeys.count == 0) {
        return @"";
    }
    __block NSString *typeName;
    [serviceCode enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([keys isEqualToString:key]) {
            *stop = YES;
            typeName = obj[@"displayName"][@"zh_CN"];
        }
    }];
    return typeName;
}
- (void)loadServiceCodeName:(void (^)(NSDictionary *serviceCode))completion{
    NSDictionary *param = @{@"keys":@"serviceCode"};
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            NSDictionary *serviceCode =PWSafeDictionaryVal(content, @"serviceCode");
            if (serviceCode == nil || serviceCode.allKeys.count == 0) return ;
            YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
            [cache removeObjectForKey:KTeamServiceCode];
            [cache setObject:serviceCode forKey:KTeamServiceCode];
            completion? completion(serviceCode):nil;
        }
    } failBlock:^(NSError *error) {
    }];
}
@end
