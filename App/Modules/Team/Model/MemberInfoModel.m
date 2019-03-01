//
//  MemberInfoModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MemberInfoModel.h"


@implementation MemberInfoModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"memberID": @"id"
                                                                  }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
