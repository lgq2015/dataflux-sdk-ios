//
//  UserInfo.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfo : JSONModel
/*
 "expire_time" = 1544712652;
 period = 10800;
 "refresh_token" = eecedca493ac46a2a6b310e8f6fa8ccf;
 "subuser_unique_id" = uCqGeuhhe6bTiCDrLgQJFn;
 ticket = ec48f2d3faa940989d4b494863eabfb5;
 "user_id" = 5053;*/
@property (nonatomic, strong) NSNumber *expire_time;
@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, strong) NSString *refresh_token;
@property (nonatomic, strong) NSString *subuser_unique_id;
@property (nonatomic, strong) NSString *ticket;
@property (nonatomic, strong) NSNumber *user_id;
@end
