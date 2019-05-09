//
//  IssueLastReadInfoModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
#import "IssueReadInfo.h"

NS_ASSUME_NONNULL_BEGIN
/*
 
 {\"issueLogInfo\":{\"seq\":12592,\"id\":\"issl-3nRK8ZREWFSGMK8RmLgRmA\",\"issueId\":\"issu-wSRsjSxA3GaVzn6d4fTX9V\",\"teamId\":\"team-onH3efQEgh5Gafwj4tNgYj\"},\"data\":{\"accountId\":\"acnt-csjGswQmCeGerJPkMYpW4D\"},\"extra_data\":{\"extra\":{\"authTokenId\":\"csat-wtpZWmoEsdazNgqiUjpCR1\",\"authTokenMarker\":\"web\"}}}
 */


@interface IssueLastReadInfoModel : JSONModel

@property (nonatomic, strong) IssueReadInfo *issueLogInfo;
@property (nonatomic, strong) IssueLastReadInfoData *data;
@end


NS_ASSUME_NONNULL_END
