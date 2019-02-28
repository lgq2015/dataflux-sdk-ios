//
//  TeamInfoModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamInfoModel.h"

@implementation TeamInfoModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"teamID": @"id"
                                                                  }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
