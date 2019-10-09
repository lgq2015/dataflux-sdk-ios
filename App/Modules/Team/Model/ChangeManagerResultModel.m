//
//  ChangeManagerResultModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/10/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChangeManagerResultModel.h"
#import "MemberInfoModel.h"

@implementation ChangeManagerResultModel
- (id)getItemData:(NSDictionary *)dic {
    NSError *error;
    return [[MemberInfoModel alloc] initWithDictionary:dic error:&error];
}
@end
