//
//  TeamInfoModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
/*
 {
 "content": {
 "accountId": null,
 "address": "张江创新园",
 "city": "上海市",
 "country": "中国",
 "district": "云计算浦东新区",
 "email": "postmaster@jiagouyun.com",
 "id": "team-e8b0812a-13cf-4d2e-a2e8-b1d6b2e578b1",
 "industry": "云计算",
 "isAdmin": true,
 "isCanceled": false,
 "isDefault": true,
 "isDisabled": false,
 "mobile": "18000000000",
 "name": "上海驻云（jiagouyun）✌️",
 "note": null,
 "optionsJSON": {
 "ldap": {
 "searchUserDN": "uid=syncadmin,ou=Mgr,ou=SYSTEM,dc=jiagouyun,dc=com",
 "searchUserPassword": "mF8DkC5meTLMpjv0b6Av",
 "signInUserBaseDN": "ou=ZHUYUN,dc=jiagouyun,dc=com",
 "url": "ldap://zyram.jiagouyun.com:389/"
 }
 },
 "province": "上海",
 "seq": 1,
 "status": "normal",
 "tags": {
 "product": {
 "managed": "all",
 "support": "cloud"
 }
 },
 "telephone": "02100000000",
 "type": "multiAccount",
 "uniqueMarker": "jiagouyun",
 "zip": "200000"
 },
 "errCode": "",
 "message": ""
 }
 */
NS_ASSUME_NONNULL_BEGIN

@interface TeamInfoModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSDictionary *tags;
@end

NS_ASSUME_NONNULL_END
