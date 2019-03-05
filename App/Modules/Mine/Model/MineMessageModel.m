//
//  MineMessageModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MineMessageModel.h"

@implementation MineMessageModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"messageID": @"id"
                                                                 }];
    
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
