//
//  CurrentUserModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/26.
//  Copyright © 2018 hll. All rights reserved.
//

#import "JSONModel.h"
@class AccountInfoModel;
@interface CurrentUserModel : JSONModel
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSArray<AccountInfoModel *>*account_info;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *app_key;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *client_id;
@property (nonatomic, strong) NSString *company_unique_id;
@property (nonatomic, strong) NSString *refresh_token;
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
