//
//  CurrentUserModel.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/26.
//  Copyright © 2018 hll. All rights reserved.
//

#import "CurrentUserModel.h"

@implementation CurrentUserModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"userID": @"id"
                                                                  }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
