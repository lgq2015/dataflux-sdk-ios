//
//  PWDraggableModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/6.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "JSONModel.h"
/*
 "bucketPath": "linux-cmd",
 "category": "handbook",
 "coverImageMobile": "",
 "coverImageWeb": "",
 "createAccountId": "",
 "createTime": "Fri, 25 Jan 2019 17:28:52 GMT",
 "id": "hdbk-tz6RomJC728WDUy7JbvP59",
 "isShow": true,
 "lastSync": "Tue, 29 Jan 2019 17:03:36 GMT",
 "name": "林纳克斯命令集",
 "orderNum": 1,
 "seq": 1,
 "updateAccountId": "",
 "updateTime": "Fri, 25 Jan 2019 17:28:52 GMT"
 */
@interface PWDraggableModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *coverImageMobile;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, strong) NSString *handbook_id;
@property (nonatomic, strong) NSString *bucketPath;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *updateAccountId;
@end
