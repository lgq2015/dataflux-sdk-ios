//
//  LibraryModel.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/6.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "LibraryModel.h"

@implementation LibraryModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"handbookId": @"id",
                                                       }];
    
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
