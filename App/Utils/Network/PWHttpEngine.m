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
#import "IssueLogListModel.h"
#import "AddIssueLogReturnModel.h"
#import "OpenUDID.h"
#import "IssueLogAttachmentUrl.h"
#import "IssueLogAtReadInfo.h"
#import "CountListModel.h"
#import "CalendarListModel.h"
#import "NotiRuleListModel.h"
#import "NotiRuleModel.h"
#import "TeamAccountListModel.h"
#import "AuthTeamListModel.h"
#import "FavoritesListModel.h"
#import "ChangeManagerResultModel.h"
#import "AlarmChartListModel.h"
#import "ReportListModel.h"

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
        } else if(error.code == -1001){
            model.errorCode = ERROR_CODE_LOCAL_ERROR_NETWORK_Time_Out;
            model.errorMsg = [model.errorCode toErrString];
        }else{
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
       @"_readerAccountId":userManager.curUserInfo.userID,
       @"_needReadInfo":@"true",
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
                                    @"type": @"attachment,bizPoint,text,keyPoint",
                                    @"subType": @"comment,markTookOver,markRecovered,issueCreated,issueRecovered,issueExpired,issueLevelChanged,issueDiscarded,issueFixed,issueAssigned,issueCancelAssigning,updateExpertGroups,call,issueChildAdded",
                                    @"_withAttachmentExternalDownloadURL": @YES,
                                    @"orderBy": @"seq",
                                    @"orderMethod": orderMethod,
                                    @"_withChildIssueDetail":@YES,
                                    @"_attachmentExternalDownloadURLOSSExpires": @3600} mutableCopy];

    if (pageMarker > 0) {
        [param addEntriesFromDictionary:@{@"pageMarker": @(pageMarker)}];
    }

    if (issueId.length > 0) {
        [param addEntriesFromDictionary:@{@"issueId": issueId}];
    }

    IssueLogListModel *model = [IssueLogListModel new];

    return [PWNetworking requsetHasTokenWithUrl:PW_issueLog withRequestType:NetworkGetType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}



- (PWURLSessionTask *)addIssueLogWithIssueid:(NSString *)issueid text:(NSString *)text atInfoJSON:(NSDictionary *)atInfoJSON callBack:(void (^)(id))callback{
    AddIssueLogReturnModel *model = [AddIssueLogReturnModel new];
    NSDictionary *param;
    if (atInfoJSON.allKeys.count>0) {
        param = @{@"data":@{@"type":@"text",@"subType":@"comment",@"content":text,@"atInfoJSON":atInfoJSON}};
    }else{
        param = @{@"data":@{@"type":@"text",@"subType":@"comment",@"content":text}};
    }
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

/**
 * 心跳
 * @param callback
 * @return
 */
- (PWURLSessionTask *)heartBeatWithCallBack:(void (^)(id))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *param = @{@"data":@{@"deviceId":[OpenUDID value]}};

    return [PWNetworking requsetHasTokenWithUrl:PW_heartBeat
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)issueLogAttachmentUrlWithIssueLogid:(NSString *)logid callBack:(void (^)(id))callback{
    IssueLogAttachmentUrl *model = [IssueLogAttachmentUrl new];

    return [PWNetworking requsetHasTokenWithUrl:PW_issueDownloadurl(logid)
                                withRequestType:NetworkGetType
                                 refreshRequest:NO
                                          cache:NO
                                         params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
//- (PWURLSessionTask *)getCurrentTeamMemberListcallBack:(void (^)(id))callback{
//
//}
- (PWURLSessionTask *)getIssueLogReadsInfoWithIssueID:(NSString *)issueID callBack:(void (^)(id))callback{
    NSDictionary *param = @{@"_readerAccountId":userManager.curUserInfo.userID,
                            @"_needReadInfo": @YES,
                            @"_withLastReadSeq":@YES
                            };
    IssueLogAtReadInfo *model = [IssueLogAtReadInfo new];

    return [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(issueID)
                                withRequestType:NetworkGetType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}

- (PWURLSessionTask *)postIssueLogReadsLastReadSeqRecord:(NSString *)issuelogID callBack:(void (^)(id))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_issueReadSeq(issuelogID)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)modifyIssueWithIssueid:(NSString *)issueid markStatus:(NSString *)markStatus text:(NSString *)text atInfoJSON:(NSDictionary *)atInfoJSON callBack:(void (^)(id))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *param;
    if (atInfoJSON.allKeys.count>0) {
        param = @{@"data":@{@"markStatus":markStatus},@"issueLogPayLoad":@{@"type":@"text",@"subType":@"comment",@"content":text,@"atInfoJSON":atInfoJSON}};
    }else{
        param = @{@"data":@{@"markStatus":markStatus},@"issueLogPayLoad":@{@"type":@"text",@"subType":@"comment",@"content":text}};
    }
    return [PWNetworking requsetHasTokenWithUrl:PW_issueModify(issueid)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}

- (PWURLSessionTask *)getCalendarDotWithStartTime:(NSString *)start EndTime:(NSString *)end callBack:(void (^)(id))callback{
    CountListModel *model = [CountListModel new];
    NSString *url ;
    NSDictionary *param ;
    CalendarViewType type = [userManager getCurrentCalendarViewType];
    if (type == CalendarViewTypeGeneral) {
        url = PW_General_count;
        param = @{@"createDate_start":start,
                  @"createDate_end":end,
                  @"_groupBy":@"DATE",
                  };
    }else{
        url = PW_IssueLog_count;
        param = @{@"createDate_start":start,
                  @"createDate_end":end,
                  @"_groupBy":@"DATE",
                  @"type":
                      @"keyPoint,bizPoint"
                  };
    }
   
    return [PWNetworking requsetHasTokenWithUrl:url
                                withRequestType:NetworkGetType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}

- (PWURLSessionTask *)getCalendarListWithStartTime:(NSString *)start EndTime:(NSString *)end pageMarker:(long)pageMarker orderMethod:(NSString *)orderMethod  callBack:(void (^)(id response))callback{
    CalendarListModel *model = [CalendarListModel new];
   
    NSMutableDictionary *param ;
    NSString *url;
     CalendarViewType type = [userManager getCurrentCalendarViewType];
    if (type == CalendarViewTypeGeneral) {
        url = PW_General_list;
        param =[@{
                  
                  @"orderMethod":orderMethod,
                  @"fieldKicking":@"extraJSON,metaJSON,reference,tags",
                  @"_needReadInfo":@YES,
                  @"orderBy":@"seq",
                  } mutableCopy];
    }else{
        url = PW_IssueLog_list;
        param =[@{
                  @"orderMethod":orderMethod,
                  @"type":
                      @"keyPoint,bizPoint",
                  @"subType":@"comment,call,updateExpertGroups,issueChildAdded,issueCreated,issueFixed,issueRecovered,issueDiscarded,issueLevelChanged,markTookOver,markRecovered,issueAssigned,issueCancelAssigning",
                  @"orderBy":@"seq",
                  @"_withChildIssueDetail":@YES,
                  } mutableCopy];
    }
    
    if (pageMarker>0) {
        [param addEntriesFromDictionary:@{@"pageMarker":[NSNumber numberWithLong:pageMarker],@"pageSize":@40}];
    }else{
        [param addEntriesFromDictionary:@{@"pageSize":@40}];
    }
    if (![start isEqualToString:@""]) {
        [param addEntriesFromDictionary:@{@"createDate_start":start,@"createDate_end":end}];
    }
    return [PWNetworking requsetHasTokenWithUrl:url
                                withRequestType:NetworkGetType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)modifyIssueWithIssueid:(NSString *)issueid assignedToAccountId:(NSString *)accountId callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *param;
    if (accountId.length>0) {
        param = @{@"data":@{@"assignedToAccountId":accountId}};
    }else{
        param = @{@"data":@{@"assignedToAccountId":[NSNull null]}};
    }
    return [PWNetworking requsetHasTokenWithUrl:PW_issueModify(issueid)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)recoveIssueWithIssueid:(NSString *)issueid callBack:(void (^)(id response))callback{
    
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_issueRecover(issueid)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:@{}
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}
- (PWURLSessionTask *)checkRegisterWithPhone:(NSString *)phone callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *param = @{@"data":@{@"username":phone}};
    return [PWNetworking requsetHasTokenWithUrl:PW_checkRegister
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)issueWatchWithIssueId:(NSString *)issueId isWatch:(BOOL)isWatch callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *param = @{@"data":@{@"isWatch":[NSNumber numberWithBool:isWatch]}};
    return [PWNetworking requsetHasTokenWithUrl:PW_issueWatch(issueId)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)getNotificationRuleListWithRuleStyle:(NotiRuleStyle)ruleStyle page:(NSInteger)page callBack:(void (^)(id))callback{
    NotiRuleListModel *model = [NotiRuleListModel new];
    NSMutableDictionary *param  = [NSMutableDictionary new];
    param = [@{@"pageSize":@10,
                            @"pageIndex":[NSNumber numberWithInteger:page]
                            } mutableCopy];
    switch (ruleStyle) {
        case NotiRuleBasic:
            [param addEntriesFromDictionary:@{@"filter":@"app,sms,voice,email"}];
            break;
        case NotiRuleDing:{
            [param addEntriesFromDictionary:@{@"filter":@"dingtalk"}];
        }
            break;
        case NotiRuleCustom:
            [param addEntriesFromDictionary:@{@"filter":@"custom"}];
            break;
    }
    return [PWNetworking requsetHasTokenWithUrl:PW_nofiticationRuleList
                                withRequestType:NetworkGetType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)subscribeNotificationRuleWithID:(NSString *)ruleID callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_subscribeNotiRule(ruleID)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)unsubscribeNotificationRuleWithID:(NSString *)ruleID callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_unsubscribeNotiRule(ruleID)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
- (PWURLSessionTask *)deleteNotificationRuleWithRuleId:(NSString *)ruleID
                                              callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_notificationRuleDelete(ruleID)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}
-(PWURLSessionTask *)addNotificationRuleWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_notificationRuleAdd
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)editNotificationRuleWithParam:(NSDictionary *)param ruleId:(NSString *)ruleId callBack:(void (^)(id))callback {
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_updateNotiRule(ruleId)
                                withRequestType:NetworkPostType
                                 refreshRequest:NO
                                          cache:NO
                                         params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}


- (PWURLSessionTask *)deviceRegistration:(NSString *)deviceId registrationId:(NSString *)registrationId callBack:(void (^)(id response))callback {
    BaseReturnModel *model = [BaseReturnModel new];
    NSDictionary *params = @{
                             @"data":
                                 @{
                                     @"deviceId": deviceId,
                                     @"registrationId": registrationId
                                     }
                             };
    return [PWNetworking requsetHasTokenWithUrl:PW_jpushDidLogin withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:params
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}
-(PWURLSessionTask *)getCurrentTeamMemberListWithCallBack:(void (^)(id response))callback{
    TeamAccountListModel *model = [TeamAccountListModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_TeamAccount withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)getCurrentAccountInfoWithCallBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_currentUser withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)getCurrentTeamInfoWithCallBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_CurrentTeam withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)getUtilsConstWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)getAuthTeamListCallBack:(void (^)(id response))callback{
    AuthTeamListModel *model = [AuthTeamListModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_AuthTeamList withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)getTeamIssueCountCallBack:(void (^)(id response))callback{
    NSDictionary *param = @{@"_onlyIsWatch":@"true"};
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_TeamIssueCount withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)getTeamProductCallBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_TeamProduct withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)getSystemMessageUnreadCountWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_systemMessageCount withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];

}
-(PWURLSessionTask *)getFavoritesListWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    FavoritesListModel *model = [FavoritesListModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_favoritesList withRequestType:NetworkGetType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)deleteFavoritesWithFavoID:(NSString *)favoID callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_favoritesDelete(favoID) withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)authSmsLoginWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_checkCodeUrl withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)authPasswordLoginWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_loginUrl withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)issueIgnoreWithIssueId:(NSString *)issueId callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_issueIgnore(issueId) withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:nil
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)issueAddWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_issueAdd withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)setTeamRolesIsManger:(BOOL)isManger userId:(NSString *)userId callBack:(void (^)(id response))callback{
    NSString *operation = isManger?@"add":@"remove";
    NSDictionary *param = @{@"accounts":@[@{@"id":userId,@"teamRoles":@[@{@"id":@"tmro-buildIn-admin",@"operation":operation}]}]};
    ChangeManagerResultModel *model = [ChangeManagerResultModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_teamRolesModify withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)teamModifyWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback{
    BaseReturnModel *model = [BaseReturnModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_TeamModify withRequestType:NetworkPostType refreshRequest:YES
                                          cache:NO params:param
                                  progressBlock:nil
                                   successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                      failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)alarmEchartWithStartTime:(NSString *)start endTime:(NSString *)end callBack:(void (^)(id response))callback{
    NSDictionary *param = @{@"_groupBy":@"DATE",
                            @"createDate_start":start,
                            @"createDate_end":end,
                            @"originExecMode":@"alertHub",
                            @"type":@"alarm",
    };
    AlarmChartListModel *model = [AlarmChartListModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_General_count withRequestType:NetworkGetType refreshRequest:YES
                                             cache:NO params:param
                                     progressBlock:nil
                                      successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                         failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
-(PWURLSessionTask *)reportListWithSubType:(NSString *)subType pageMarker:(long )pageMarker callBack:(void (^)(id response))callback{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param addEntriesFromDictionary:@{@"subType":subType,
                            @"type":@"report",
                            @"pageSize":@20,
                            @"orderBy":@"seq",
                            @"orderMethod":@"desc",
    }];
    if (pageMarker>0) {
        [param addEntriesFromDictionary:@{@"pageMarker":[NSNumber numberWithLong:pageMarker]}];
    }
    ReportListModel *model = [ReportListModel new];
    return [PWNetworking requsetHasTokenWithUrl:PW_General_list withRequestType:NetworkGetType refreshRequest:YES
                                             cache:NO params:param
                                     progressBlock:nil
                                      successBlock:[self pw_createSuccessBlock:model withCallBack:callback]
                                         failBlock:[self pw_createFailBlock:model withCallBack:callback]];
}
@end


