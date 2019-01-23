//
//  SourceVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSUInteger, SourceType) {
    SourceTypeAli = 1,             //阿里云
    SourceTypeAWS,                 //AWS
    SourceTypeTencent,             //腾讯云
    SourceTypeHUAWEI,              //华为云
    SourceTypeSingleDiagnose,      //主机诊断
    SourceTypeClusterDiagnose,     //集群诊断
    SourceTypeDomainNameDiagnose,  //域名诊断
    SourceTypeWebsiteSecurityScan, //网站安全扫描
    SourceTypeURLDiagnose,         //URL 诊断
};

@interface SourceVC : RootViewController
@property (nonatomic, assign) SourceType type;
@property (nonatomic, assign) BOOL isAdd;
@end


