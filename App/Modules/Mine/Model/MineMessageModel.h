//
//  MineMessageModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 "accountId": "acnt-bbfzQfqE6igbndcvgcMgwf",
 "content": "恭喜您成功加入了team-ao3NpYVgApj3UTPAFTDm3b团队，您可以在团队中与团队成员进行协作，共享团队数据和信息。",
 "createAccountId": "acnt-bbfzQfqE6igbndcvgcMgwf",
 "createTime": "2019-03-02T10:32:18Z",
 "id": "msg-HAo7vA7L9TSEfcm6iAbDuY",
 "isDeleted": false,
 "isReaded": false,
 "messageType": "team",
 "seq": 920350,
 "teamId": "",
 "title": "加入团队成功",
 "updateAccountId": "acnt-bbfzQfqE6igbndcvgcMgwf",
 "updateTime": "2019-03-02T10:32:18Z"
 }
 */
@interface MineMessageModel : JSONModel
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createAccountId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, assign) BOOL isReaded;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *updateAccountId;
@property (nonatomic, strong) NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
