//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseReturnModel.h"


@interface CarrierItemModel : BaseReturnModel

@property (nonatomic, strong) NSString *uploadUid;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) NSString *desc;

- (void)setValueWithDict:(NSDictionary *)dict;
@end