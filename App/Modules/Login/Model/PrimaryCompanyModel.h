//
//  PrimaryCompanyModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/27.
//  Copyright © 2018 hll. All rights reserved.
//

#import "JSONModel.h"

@interface PrimaryCompanyModel : JSONModel
@property(nonatomic, assign) BOOL actived;
@property(nonatomic, strong) NSString *client_id;
@end
/*
 primary_company:
 {
 "actived": true,
 "address": null,
 "address_count": 1,
 "address_id": 460,
 "applier_position": null,
 "architect_id": null,
 "client_id": "0e723bb26fb21dfa2a9b1cc49783f65c0d2fc24a",
 "cloud_index": 252,
 "company_name": "测试",
 "contact_name": "BrandonZhang",
 "create_time": 1513932229,
 "device_count": 5,
 "device_id": null,
 "device_info": "Simulator",
 "distributor_id": null,
 "email": "zhangbo@jiagouyun.com",
 "email_verified": false,
 "email_verify_code": null,
 "icon_url": null,
 "id": 3368,
 "industry": "大交通",
 "is_virtual": false,
 "location": null,
 "max_devices": 999,
 "min_version": "",
 "mobile": "17317547313",
 "mobile_verified": false,
 "mobile_verify_code": null,
 "plan": "PLATINUM_5_1",
 "points": 0,
 "post_address": {
 "address": "上海",
 "apply_person": "Branfon",
 "city": "浦东新区",
 "country": "china",
 "create_time": 1513932229,
 "default": 1,
 "district": "",
 "id": 460,
 "postal_code": null,
 "province": "上海",
 "tel": "17317547313",
 "unique_id": "ZSpxjG8giWstpViVaQexuM",
 "update_time": 1513932229,
 "user_id": 3368
 },
 "previous_plan": "BASIC",
 "service_end_time": 1546271999,
 "settings": null,
 "unique_id": "dHbHCBSyZfAPwRah7WfhBU",
 "update_time": 1513935461,
 "user_rank": 1
 }
 */
