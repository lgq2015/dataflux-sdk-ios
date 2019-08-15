//
//  UtilsConstManager.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UtilsConstManager.h"
@interface UtilsConstManager ()
@property(nonatomic, strong) YYCache *cache;
@property(nonatomic, copy) NSString *localeIdentifier;
@end
@implementation UtilsConstManager
+ (instancetype)sharedUtilsConstManager {
    static UtilsConstManager *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedManger = [[self alloc] init];
        [_sharedManger initData];
    });
    return _sharedManger;
}
-(void)initData{
    self.cache = [[YYCache alloc]initWithName:KUtilsConstCacheName];
    self.localeIdentifier =@"zh_CN";
}
-(void)getAllUtilsConst{
    NSDictionary *param = @{@"keys":@"ISPs,issueLevel,issueSourceProvider,expertGroups,serviceCode,systemMessageTypes"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
         BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSDictionary *content = model.content;
            NSArray *constISPs =PWSafeArrayVal(content, @"ISPs");
            NSArray *issueLevel = PWSafeArrayVal(content, @"issueLevel");
            NSArray *IssueSourceName =PWSafeArrayVal(content, @"issueSourceProvider");
            NSArray *expertGroups =PWSafeArrayVal(content, @"expertGroups");
            NSArray *systemMessageTypes = PWSafeArrayVal(content, @"systemMessageTypes");
            NSDictionary *serviceCode =PWSafeDictionaryVal(content, @"serviceCode");
            if (IssueSourceName.count>0) {
                [self.cache removeObjectForKey:KIssueSourceNameModelCache];
                [self.cache setObject:IssueSourceName forKey:KIssueSourceNameModelCache];
            }
            if (constISPs.count>0) {
                [self.cache removeObjectForKey:KTeamISPsCacheName];
                [self.cache setObject:constISPs forKey:KTeamISPsCacheName];
            }
            if (issueLevel.count>0) {
                [self.cache removeObjectForKey:KIssueLevel];
                [self.cache setObject:issueLevel forKey:KIssueLevel];
            }
            if (expertGroups.count>0) {
                [self.cache removeObjectForKey:KExpertGroups];
                [self.cache setObject:expertGroups forKey:KExpertGroups];
            }
            if (serviceCode.allKeys.count>0) {
                [self.cache removeObjectForKey:KTeamServiceCode];
                [self.cache setObject:serviceCode forKey:KTeamServiceCode];
            }
            if (systemMessageTypes.count>0) {
                [self.cache removeObjectForKey:KSystemMessageTypes];
                [self.cache setObject:systemMessageTypes forKey:KSystemMessageTypes];
            }
        }
    }];
}
#pragma mark ========== TeamServiceCode ==========
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
    NSDictionary *serviceCode = (NSDictionary *)[self.cache objectForKey:KTeamServiceCode];
    if (serviceCode.allKeys.count == 0) {
        return @"";
    }
    __block NSString *typeName;
    [serviceCode enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([keys isEqualToString:key]) {
            *stop = YES;
            typeName = [obj[@"displayName"] stringValueForKey:self.localeIdentifier default:@""];
        }
    }];
    return typeName;
}
- (void)loadServiceCodeName:(void (^)(NSDictionary *serviceCode))completion{
    NSDictionary *param = @{@"keys":@"serviceCode"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSDictionary *serviceCode =PWSafeDictionaryVal(model.content, @"serviceCode");
            if (serviceCode.allKeys.count>0){
                [self.cache removeObjectForKey:KTeamServiceCode];
                [self.cache setObject:serviceCode forKey:KTeamServiceCode];
                completion? completion(serviceCode):nil;
            }else{
                completion? completion(nil):nil;
            }
        }else{
            completion? completion(nil):nil;
        }
    }];
}
#pragma mark ========== expertGroup ==========
- (void)getExpertNameByKey:(NSString *)key name:(void(^)(NSString *name))name{
    NSArray *expertGroup = (NSArray *)[self.cache objectForKey:KExpertGroups];
    if (expertGroup.count == 0) {
        [self loadExperGroups:^(NSArray *experGroups) {
            if (name) {
                name([self privateGetExpertNameByKey:key]);
            }
        }];
    }else{
        if (name) {
            name([self privateGetExpertNameByKey:key]);
        }
    }
}
- (NSString *)privateGetExpertNameByKey:(NSString *)key{
    __block NSString *typeName;
    NSArray *expertGroup = (NSArray *)[self.cache objectForKey:KExpertGroups];
    [expertGroup enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([key isEqualToString:obj[@"expertGroup"]]) {
            *stop = YES;
            typeName = [obj[@"displayName"] stringValueForKey:self.localeIdentifier default:@""];
        }
    }];
    return typeName;
}
- (void)loadExperGroups:(void (^)(NSArray *experGroups))completion{
    NSDictionary *param = @{@"keys":@"expertGroups"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSArray *expertGroups =PWSafeArrayVal(model.content, @"expertGroups");
            [self.cache setObject:expertGroups forKey:KExpertGroups];
             completion ? completion(expertGroups):nil;
        }else{
          completion ? completion(nil):nil;
        }
    }];
}
#pragma mark ========== ISPs ==========
- (void)getTeamISPs:(void(^)(NSArray *isps))ISPs{
    NSArray *isps = (NSArray *)[self.cache objectForKey:KTeamISPsCacheName];
    if (isps.count == 0) {
        [self loadTeamISPs:^(NSArray *TeamISPs) {
            ISPs? ISPs(isps):nil;
        }];
    }else{
        ISPs? ISPs(isps):nil;
    }
}
- (void)loadTeamISPs:(void (^)(NSArray *TeamISPs))completion{
    NSDictionary *param = @{@"keys":@"ISPs"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSArray *ISPs =PWSafeArrayVal(model.content, @"ISPs");
            [self.cache removeObjectForKey:KTeamISPsCacheName];
            [self.cache setObject:ISPs forKey:KTeamISPsCacheName];
            completion ? completion(ISPs):nil;
        }else{
            completion ? completion(nil):nil;
        }
    }];
}

#pragma mark ========== issueLevel ==========
- (void)getIssueLevelNameByKey:(NSString *)key name:(void(^)(NSString *name))name{
    NSString *nameStr = [self privateGetIssueLevelNameByKey:key];
    if (nameStr.length>0) {
        name? name(nameStr):nil;
    }else{
        [self loadIssueLevelName:^(NSArray *IssueSourceNames) {
            name? name([self privateGetIssueLevelNameByKey:key]):nil;
        }];
    }
}
- (NSString *)privateGetIssueLevelNameByKey:(NSString *)key{
    NSArray *issueLevelName = (NSArray *)[self.cache objectForKey:KIssueLevel];
    __block NSString *levelName = @"";
    if(issueLevelName.count>0){
        [issueLevelName enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull objKey, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([key isEqualToString:objKey]) {
                    *stop = YES;
                    NSDictionary *displayName =PWSafeDictionaryVal(obj[objKey], @"displayName");
                    levelName =  [displayName stringValueForKey:self.localeIdentifier default:@""];
                }
            }];
        }];
    }
    return levelName;
}
- (void)loadIssueLevelName:(void (^)(NSArray *IssueSourceNames))completion{
    NSDictionary *param = @{@"keys":@"issueLevel"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSArray *issueLevel =PWSafeArrayVal(model.content, @"issueLevel");
            [self.cache setObject:issueLevel forKey:KIssueLevel];
            completion ? completion(issueLevel):nil;
        }else{
            completion ? completion(nil):nil;
        }
    }];
}
#pragma mark ========== issueSourceProvider ==========
- (void)getIssueSourceNameByKey:(NSString *)key name:(void(^)(NSString *name))name{
    NSString *nameStr = [self privateGetissueSourceNameByKey:key];
    if ([nameStr isEqualToString:@""]) {
        [self loadIssueSourceName:^(NSArray *experGroups) {
            name? name([self privateGetissueSourceNameByKey:key]):nil;
        }];
    }else{
        name? name([self privateGetissueSourceNameByKey:key]):nil;
    }
}
- (NSString *)privateGetissueSourceNameByKey:(NSString *)key{
    NSArray *issueSourceName = (NSArray *)[self.cache objectForKey:KIssueSourceNameModelCache];
    __block NSString *typeName = @"";
    if(issueSourceName.count>0){
        [issueSourceName enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([key isEqualToString:[obj stringValueForKey:@"provider" default:@""]]) {
                NSDictionary *displayName = PWSafeDictionaryVal(obj, @"displayName");
                typeName = [displayName stringValueForKey:self.localeIdentifier default:@""];
                *stop = YES;
            }
        }];
    }
    return typeName;
}
- (void)loadIssueSourceName:(void (^)(NSArray *IssueSourceNames))completion{
    NSDictionary *param = @{@"keys":@"issueSourceProvider"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSArray *IssueSourceName =PWSafeArrayVal(model.content, @"issueSourceProvider");
            [self.cache setObject:IssueSourceName forKey:KIssueSourceNameModelCache];
            completion ? completion(IssueSourceName):nil;
        }else{
            completion ? completion(nil):nil;
        }
    }];
}
#pragma mark ========== 行业 ==========
- (void)getTradesData:(void(^)(NSArray *data))trades{
    NSArray *tradesData = (NSArray *)[self.cache objectForKey:KTeamIndustry];;
    if (tradesData.count == 0) {
        [self loadTradesData:^(NSArray *data) {
            trades? trades(data):nil;
        }];
    }else{
        trades? trades(tradesData):nil;
    }
}
- (void)loadTradesData:(void (^)(NSArray *data))completion{
    NSDictionary *param = @{@"keys":@"industry"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSArray *industry =PWSafeArrayVal(model.content, @"industry");
            [self.cache setObject:industry forKey:KTeamIndustry];
            completion ? completion(industry):nil;
        }else{
            completion ? completion(nil):nil;
        }
    }];
}
#pragma mark ========== 地域 ==========
- (void)getDistrictData:(void(^)(NSArray *data))district{
    NSArray *districtData = (NSArray *)[self.cache objectForKey:KTeamDistrict];;
    if (districtData.count == 0) {
        [self loadDistrictsData:^(NSArray *data) {
            district? district(data):nil;
        }];
    }else{
        district? district(districtData):nil;
    }
}
- (void)loadDistrictsData:(void (^)(NSArray *data))completion{
    NSDictionary *param = @{@"keys":@"district"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSArray *district =PWSafeArrayVal(model.content, @"district");
            [self.cache setObject:district forKey:KTeamDistrict];
            completion ? completion(district):nil;
        }else{
            completion ? completion(nil):nil;
        }
    }];
}
#pragma mark ========== SystemMessageTypes ==========
- (void)getSystemMessageTypeNameByKey:(NSString *)key name:(void(^)(NSString *name))name{
    NSString *nameStr = [self privateSystemMessageTypeNameByKey:key];
    if ([nameStr isEqualToString:@""]) {
        [self loadSystemMessageTypes:^(NSArray *experGroups) {
            name? name([self privateSystemMessageTypeNameByKey:key]):nil;
        }];
    }else{
        name? name([self privateSystemMessageTypeNameByKey:key]):nil;
    }
}
- (NSString *)privateSystemMessageTypeNameByKey:(NSString *)key{
    NSArray *systemMessageTypes= (NSArray *)[self.cache objectForKey:KSystemMessageTypes];
    __block NSString *messageName = @"";
    if(systemMessageTypes.count>0){
        [systemMessageTypes enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([key isEqualToString:[obj stringValueForKey:@"systemMessageType" default:@""]]) {
                NSDictionary *displayName = PWSafeDictionaryVal(obj, @"displayName");
                messageName = [displayName stringValueForKey:self.localeIdentifier default:@""];
                *stop = YES;
            }
        }];
    }
    return messageName;
}
- (void)loadSystemMessageTypes:(void (^)(NSArray *data))completion{
    NSDictionary *param = @{@"keys":@"systemMessageTypes"};
    [[PWHttpEngine sharedInstance] getUtilsConstWithParam:param callBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSArray *systemMessageTypes =PWSafeArrayVal(model.content, @"systemMessageTypes");
            [self.cache setObject:systemMessageTypes forKey:KSystemMessageTypes];
            completion ? completion(systemMessageTypes):nil;
        }else{
            completion ? completion(nil):nil;
        }
    }];
}
@end
