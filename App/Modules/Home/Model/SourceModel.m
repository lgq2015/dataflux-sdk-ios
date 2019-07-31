//
//  SourceModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SourceModel.h"

@implementation SourceModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"sourceID": @"id"
                                                                  }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
