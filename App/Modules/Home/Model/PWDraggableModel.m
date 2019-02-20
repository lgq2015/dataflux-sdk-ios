//
//  PWDraggableModel.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/6.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWDraggableModel.h"

@implementation PWDraggableModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"handbook_id": @"id",
                                                       }];
    
}
@end
