//
//  IssueModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
#import "RenderedTextModel.h"
/*
 {
 "accountId": "acnt-bbfzQfqE6igbndcvgcMgwf",
 "actSeq": 448618359005730,
 "checkKey": null,
 "checkScriptId": null,
 "content": "CPU及内存持续高于90%",
 "createTime": "2019-01-30T10:24:15.000Z",
 "endTime": null,
 "expireTime": "2019-12-01T00:00:00.000Z",
 "extraJSON": null,
 "fingerprint": null,
 "groupKey": null,
 "id": "issu-pwLtS57sEmzDcakKhjxUj2",
 "isEnded": false,
 "isTicket": true,
 "isTicketEnded": false,
 "issueSourceId": null,
 "itAssetId": null,
 "itAssetName_cache": null,
 "itAssetOuterId_cache": null,
 "itAssetProduct_cache": null,
 "itAssetProvider_cache": null,
 "level": "warning",
 "metaJSON": null,
 "origin": "user",
 "priority": null,
 "seq": 70,
 "status": "created",
 "subType": null,
 "tags": null,
 "teamId": "team-ao3NpYVgApj3UTPAFTDm3b",
 "ticketEndedTime": null,
 "ticketStatus": "submitted",
 "ticketSubmitTime": "2019-01-30T10:24:16.000Z",
 "ticketType": "serviceEvent",
 "title": "某服务器发生故障",
 "type": "misc",
 "updateTime": "2019-01-30T10:24:15.000Z"
 },
 */
NS_ASSUME_NONNULL_BEGIN

@interface IssueModel : JSONModel
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray  *latestIssueLogs; //[@"title"] subtitle
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) long actSeq;
@property (nonatomic, strong) NSDictionary *renderedText;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *itAssetProvider_cache;
@property (nonatomic, strong) NSString *latestIssueLogsStr;
@property (nonatomic, strong) NSString *renderedTextStr;

@end

NS_ASSUME_NONNULL_END
