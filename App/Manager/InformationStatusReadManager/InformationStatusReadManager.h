//
// Created by Brandon on 2019-03-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"


@interface InformationStatusReadManager : BaseSqlHelper

+ (instancetype)sharedInstance;

- (void)setReadStatus:(NSArray *)datas;

- (void)readInformation:(NSString *)id;


@end