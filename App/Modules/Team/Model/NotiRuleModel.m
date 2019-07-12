//
//  NotiRuleModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NotiRuleModel.h"

@implementation NotiRuleModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"ruleId": @"id"
                                                                  }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
