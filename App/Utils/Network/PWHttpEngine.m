//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "PWHttpEngine.h"
#import "BaseReturnModel.h"
#import "CarrierItemModel.h"
#import "NSString+ErrorCode.h"
#import "NSDictionary+URL.h"
#import "MineMessageModel.h"
#import "IssueModel.h"
#import "IssueSourceModel.h"
#import "IssueSourceListModel.h"
#import "IssueListModel.h"
#import "IssueLogModel.h"


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

        if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]
                ||[error.domain isEqualToString:AFNetworkingOperationFailingURLResponseErrorKey]
                ||[error.domain isEqualToString:AFNetworkingOperationFailingURLResponseDataErrorKey]) {
            id response = [NSJSONSerialization
                    JSONObjectWithData:error.userInfo[error.domain]
                               options:0 error:nil];
            [model setValueWithDict:response];

        } else if ([error.domain isEqualToString:@"com.hyq.YQNetworking.ErrorDomain"]) {
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

/**
 * 修改主机诊断、集群诊断属性
 * @param uploadId
 * @param desc
 * @param callback
 * @return
 */
- (PWURLSessionTask *)patchProbe:(NSString *)uploadId name:(NSString *)desc callBack:(void (^)(id))callback {
    NSDictionary *param = @{@"uploader_uid": uploadId, @"desc": desc};
    BaseReturnModel *model = [BaseReturnModel new];

    return [PWNetworking requsetHasTokenWithUrl:NSStringFormat(@"%@%@",PW_URL_CARRIER_PROBE, [param queryString])
                                withRequestType:NetworkPatchType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}


/**
 * 删除集群诊断
 * @param uploadId
 * @param callback
 * @return
 */
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



/**
 * 加载消息详情
 * @param messageId
 * @param callback
 * @return
 */

- (PWURLSessionTask *)getMessageDetail:(NSString *)messageId callBack:(void (^)(id))callback {

    MineMessageModel* model = [MineMessageModel new];

    return [PWNetworking requsetHasTokenWithUrl:PW_systemMessageDetail(messageId) withRequestType:NetworkGetType
                                 refreshRequest:NO cache:NO params:nil progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}


/**
 * 获取情报详情
 * @param issueId 情报id
 * @param callback 
 * @return
 */
-(PWURLSessionTask *)getIssueDetail:(NSString *)issueId callBack:(void (^)(id))callback {

    IssueModel* model = [IssueModel new];

    return  [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(issueId)
                                 withRequestType:NetworkGetType
                                  refreshRequest:NO cache:NO params:nil
                                   progressBlock:nil
                                    successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                       failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}


- (PWURLSessionTask *)getIssueSource:(NSInteger)pageSize page:(NSInteger)page callBack:(void (^)(id))callback {
    NSDictionary *param = @{
            @"pageSize": @(pageSize), @"pageNumber": @(page)};
    IssueSourceListModel* model = [IssueSourceListModel new];

    return  [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType
                                  refreshRequest:YES cache:NO params:param progressBlock:nil
                                    successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                       failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}



-(PWURLSessionTask *)getIssueList:(NSInteger)pageSize pageMarker:(long long)pageMarker callBack:(void (^)(id))callback{

    NSMutableDictionary *params =
            [@{@"_withLatestIssueLog": @YES,
                    @"orderBy": @"actSeq",
                    @"_latestIssueLogLimit": @1,
                    @"_latestIssueLogSubType": @"comment",
                    @"orderMethod": @"asc",
                    @"fieldKicking": [@[@"extraJSON", @"metaJSON"] componentsJoinedByString:@","],
                    @"pageSize": @(pageSize)
            } mutableCopy];


    if(pageMarker>0){
        [params addEntriesFromDictionary:@{@"pageMarker":@(pageMarker)}];
    }

    IssueListModel * model = [IssueListModel new];
    return  [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType
                                  refreshRequest:YES cache:NO params:params progressBlock:nil
                                    successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                       failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}


- (PWURLSessionTask *)getChatIssueLog:(NSInteger)pageSize issueId:(NSString *)issueId
        pageMarker:(long long)pageMarker orderMethod:(NSString *)orderMethod callBack:(void (^)(id))callback {

    NSMutableDictionary *param = [@{
                @"pageSize": @(pageSize),
                @"type": @"attachment,bizPoint,text",
                @"subType": @"exitExpertGroups,updateExpertGroups,call,comment",
                @"_withAttachmentExternalDownloadURL": @YES,
                @"orderBy": @"seq",
                @"orderMethod": orderMethod,
                @"_attachmentExternalDownloadURLOSSExpires": @3600} mutableCopy];

    if(pageMarker>0){
        [param addEntriesFromDictionary:@{@"pageMarker":@(pageMarker)}];
    }

    IssueLogModel *model = [IssueLogModel new];

    return [PWNetworking requsetHasTokenWithUrl:PW_issueLog(issueId) withRequestType:NetworkGetType
                          refreshRequest:NO
                                   cache:NO
                                  params:param
                           progressBlock:nil
                            successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                               failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}



- (PWURLSessionTask *)addIssueLogWithIssueid:(NSString *)issueid text:(NSString *)text callBack:(void (^)(id))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *param = @{@"data":@{@"type":@"text",@"subType":@"comment",@"content":text}};
    return [PWNetworking requsetHasTokenWithUrl:PW_issueLogAdd(issueid)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)issueTicketOpenWithIssueid:(NSString *)issueid expertGroup:(NSString *)expertGroup content:(NSString *)content callBack:(void (^)(id))callback{
     BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *param ;
    if(content){
        param = @{@"data":@{@"expertGroup":expertGroup,@"issueLogPayLoad":@{@"content":content}}};

    }else{
        param = @{@"data":@{@"expertGroup":expertGroup}};
    }
    return [PWNetworking requsetHasTokenWithUrl:PW_issueTicketOpen(issueid)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}

@end
