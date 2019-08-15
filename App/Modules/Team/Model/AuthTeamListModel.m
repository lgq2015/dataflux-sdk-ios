//
//  AuthTeamListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/8/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AuthTeamListModel.h"
#import "TeamInfoModel.h"
@implementation AuthTeamListModel
- (id)getItemData:(NSDictionary *)dic {
    NSError *error;
    return [[TeamInfoModel alloc] initWithDictionary:dic error:&error];
}
@end
