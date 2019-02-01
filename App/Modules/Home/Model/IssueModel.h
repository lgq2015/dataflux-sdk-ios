//
//  IssueModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
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

@end

NS_ASSUME_NONNULL_END
