//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "PWHttpEngine.h"
#import "BaseReturnModel.h"
#import "CarrierItemModel.h"
#import "NSString+ErrorCode.h"


@implementation PWHttpEngine {

}


+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}


- (id)pw_createSuccessBlock:(BaseReturnModel *)model
               withCallBack:(void (^)(id))callBack {
    return ^(id response) {
        [model setValueWithDict:response];
        callBack(model);

    };
}

- (id)pw_createFailBlock:(BaseReturnModel *)model withCallBack:(void (^)(id))callBack {
    return ^(NSError *error) {

        if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
            id response = [NSJSONSerialization
                    JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                               options:0 error:nil];
            [model setValueWithDict:response];

        } else if([error.domain isEqualToString:@"com.hyq.YQNetworking.ErrorDomain"]){
            model.errorCode = ERROR_CODE_LOCAL_ERROR_NETWORK_NOT_AVAILABLE;
            model.errorMsg = [model.errorCode toErrString];
        } else {
            model.errorCode = ERROR_CODE_LOCAL_ERROR_NETWORK_ERROR;
            model.errorMsg = [model.errorCode toErrString];
        }

        callBack(model);
    };
}

/**
 * 获取 主机诊断、集群诊断属性
 * @param uploadId
 * @param callback 
 * @return
 */
- (PWURLSessionTask *)getProbe:(NSString *)uploadId callBack:(void (^)(id))callback {

    NSDictionary *param = @{@"uploader_uid": uploadId};

    CarrierItemModel *model = [CarrierItemModel new];

    return [PWNetworking requsetHasTokenWithUrl:PW_URL_CARRIER_PROBE
                                withRequestType:NetworkGetType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}

- (PWURLSessionTask *)patchProbe:(NSString *)uploadId name:(NSString *)desc callBack:(void (^)(id))callback {
    NSDictionary *param = @{@"uploader_uid": uploadId, @"desc": desc};
    BaseReturnModel *model = [BaseReturnModel new];

    return [PWNetworking requsetHasTokenWithUrl:PW_URL_CARRIER_PROBE
                                withRequestType:NetworkPatchType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}


- (PWURLSessionTask *)deleteProbe:(NSString *)uploadId callBack:(void (^)(id))callback {
    NSDictionary *param = @{@"uploader_uid": uploadId};

    BaseReturnModel *model = [BaseReturnModel new];


    return [PWNetworking requsetHasTokenWithUrl:PW_URL_CARRIER_PROBE
                                withRequestType:NetworkDeleteType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}


@end