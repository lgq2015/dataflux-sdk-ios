//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ERROR_CODE_AUTH_UNAUTHORIZED  @"home.auth.unauthorized"
#define ERROR_CODE_LOCAL_ERROR  @"local.err"
#define ERROR_CODE_LOCAL_ERROR_NETWORK_NOT_AVAILABLE  @"local.err.networkNotAvailable"
#define ERROR_CODE_LOCAL_ERROR_NETWORK_ERROR  @"local.err.netWorkError"
#define ERROR_CODE_LOCAL_IS_FETCHING  @"local.err.isFetching"
#define ERROR_CODE_AUTH_UNAUTHORIZED_SHRINE  @"Shrine.Token.WithoutInfoToken"
#define ERROR_CODE_LOCAL_ERROR_NETWORK_Time_Out  @"local.err.networkTimeOut"

@interface BaseReturnModel : NSObject
@property(nonatomic, strong) NSDictionary *content;
@property(nonatomic, strong) NSString *errorCode;
@property(nonatomic, strong) NSString *errorMsg;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)setValueWithDict:(NSDictionary *)dict;

- (BOOL)isSuccess;
@end
