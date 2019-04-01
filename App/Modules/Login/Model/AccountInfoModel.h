//
//  AccountInfoModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/26.
//  Copyright © 2018 hll. All rights reserved.
//

#import "JSONModel.h"

@interface AccountInfoModel : JSONModel
@property (nonatomic, strong) NSString *account;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) int client_id;
@property (nonatomic, assign) int cloud_index;
@property (nonatomic, strong) NSString *company_unique_id;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) BOOL is_agree;
@property (nonatomic, strong) NSString *join_time;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;

@end
/*
 {
 "account": "youxiang092008@qq.com",
 "active": true,
 "avatar": null,
 "client_id": 260,
 "cloud_index": 6,
 "company_unique_id": "LtsBors2TAQXkBBu8EVNgH",
 "create_time": 1537430538,
 "deleted": false,
 "full_name": "李宗伟",
 "id": 5125,
 "is_agree": true,
 "join_time": 1541236155,
 "mobile": "18352092008",
 "password": "47c1a69fca3d09ad23f72bfc7c70e537cc4d136d6bb2083b37df7704aa0430bc",
 "points": 0,
 "primary_user": false,
 "primary_user_id": 5053,
 "unique_id": "pYFKYVD5hPKz4FvrYayFDS",
 "update_time": 1541236155,
 "user_name": null,
 "user_position": null,
 "user_rank": 1
 }
 */
