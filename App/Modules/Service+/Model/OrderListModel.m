//
//  OrderListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"orderId": @"id",
                                                                  }];
    
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
