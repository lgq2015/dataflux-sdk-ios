//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PWHttpEngine : NSObject
+ (instancetype)sharedInstance;


- (PWURLSessionTask *)getProbe:(NSString *)uploadId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)patchProbe:(NSString *)uploadId name:(NSString *)desc callBack:(void (^)(id))callback;

- (PWURLSessionTask *)deleteProbe:(NSString *)uploadId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getMessageDetail:(NSString *)entityId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getIssueDetail:(NSString *)issueId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getIssueSource:(NSInteger)pageSize page:(NSInteger)page callBack:(void (^)(id))callback;
@end
