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
 createTime = "2019-01-26T03:01:07.000Z";
 email = "<null>";
 id = "acnt-xtKprtNV4FkSJWQGRDLZsN";
 isDisabled = 0;
 mobile = 17317547313;
 name = 17317547313;
 namespace = default;
 seq = 23626;
 tags =         {
 pwAvatar = "http://diaobao-test.oss-cn-hangzhou.aliyuncs.com/account_file/acnt-xtKprtNV4FkSJWQGRDLZsN/pwAvatar/566375c5-b3a4-4698-88d1-b03d2d05eb2c.png";
 };
 updateTime = "2019-01-26T03:01:07.000Z";
 username = "<null>";*/
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
@property (nonatomic, strong) NSDictionary *tags;
@property (nonatomic, strong) NSArray<AccountInfoModel *>*accountInfo;
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
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *permissions;
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
