//
//  CurrentUserModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/26.
//  Copyright © 2018 hll. All rights reserved.
//

#import "JSONModel.h"
@class AccountInfoModel;
/*
 "createTime": "2019-01-25T10:54:23.000Z",
 "email": null,
 "id": "acnt-bbfzQfqE6igbndcvgcMgwf",
 "isDisabled": false,
 "mobile": "18236889895",
 "name": "18236889895",
 "namespace": "default",
 "seq": 23253,
 "tags": null,
 "updateTime": "2019-01-25T10:55:09.000Z",
 "username": null
 */
@interface CurrentUserModel : JSONModel
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSArray<AccountInfoModel *>*account_info;
@property (nonatomic, assign) BOOL isDisabled;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *seq;
@property (nonatomic, strong) NSString *pwid;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *userID;
@end
/*
 
 "cloud_index": 6,
 "create_time": 1536312649,
 "deleted": false,
 "extract_data": "None",
 "id": 5053,
 "is_agree": true,
 "is_incomplete": false,
 "join_time": 1536313194,
 "message_type": [],
 "new_app_keys": [],
 "permission": [],
 "permissions": [],
 "points": 0,
 "primary_company":{}
 "primary_user": false,
 "primary_user_id": 3368,
 */
