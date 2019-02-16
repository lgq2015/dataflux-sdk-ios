//
//  IssueModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueModel.h"

@implementation IssueModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"issueId": @"id"
                                                                  }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
