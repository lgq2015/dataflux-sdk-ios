//
//  OrderStatusModel.m
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "OrderStatusModel.h"

@implementation OrderStatusModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"orderId": @"id",
                                                                  }];
    
}
@end
