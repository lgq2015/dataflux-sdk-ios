//
//  TeamAccountListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/8/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamAccountListModel.h"
#import "MemberInfoModel.h"

@implementation TeamAccountListModel
- (id)getItemData:(NSDictionary *)dic {
    NSError *error;
    return [[MemberInfoModel alloc] initWithDictionary:dic error:&error];
}
@end
