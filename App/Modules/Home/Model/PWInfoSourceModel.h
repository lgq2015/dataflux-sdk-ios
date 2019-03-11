//
//  PWInfoSourceModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, SourceType) {
    SourceTypeAli = 1,             //阿里云
    SourceTypeAWS,                 //AWS
    SourceTypeTencent,             //腾讯云
    SourceTypeUcloud,              //优刻得
    SourceTypeSingleDiagnose,      //主机诊断
    SourceTypeClusterDiagnose,     //集群诊断
    SourceTypeDomainNameDiagnose,  //域名诊断
};
typedef NS_ENUM(NSInteger, SourceState) {
    SourceStateNotDetected = 1,        //未开始检测
    SourceStateDetected,           //已纳入检测
    SourceStateAbnormal,           //情报源异常
};
NS_ASSUME_NONNULL_BEGIN

@interface PWInfoSourceModel : NSObject
@property (nonatomic, assign) SourceType type;
@property (nonatomic, assign) SourceState state;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconImg;
@property (nonatomic, strong) NSString *scanCheckStatus;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, strong) NSString *akId;
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
