//
// Created by Brandon on 2019-05-17.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Sprocket : NSObject
+ (DDLogLevel)ddLogLevel;

+ (void)ddSetLogLevel:(DDLogLevel)logLevel;
@end