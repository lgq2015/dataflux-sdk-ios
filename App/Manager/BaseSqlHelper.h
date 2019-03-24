//
// Created by Brandon on 2019-03-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseSqlHelper : NSObject

- (instancetype)initWithDBName:(NSString *)dbName;

- (PWFMDB *)getHelper;

- (void)shutDown;
@end