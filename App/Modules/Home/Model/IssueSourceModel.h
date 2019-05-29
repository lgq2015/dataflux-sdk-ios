//
// Created by Brandon on 2019-03-31.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseReturnModel.h"


@interface IssueSourceModel : NSObject 


@property (nonatomic, strong)NSString *provider;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *teamId;
@property (nonatomic, strong)NSString *scanCheckStatus;
@property (nonatomic, strong)NSString *updateTime;
@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *credentialJSONStr;
@property (nonatomic, strong)NSString *scanCheckStartTime;
@property (nonatomic, strong)NSString *scanCheckInQueueTime;
@property (nonatomic, strong)NSString *scanCheckEndTime;
@property (nonatomic, strong)NSString *optionsJSONStr;
@property (nonatomic, assign)BOOL isVirtual;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
