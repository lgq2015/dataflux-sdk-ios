//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PWHttpEngine : NSObject
+ (instancetype)sharedInstance;


- (PWURLSessionTask *)getProbe:(NSString *)uploadId callBack:(void (^)(id))callback;
@end