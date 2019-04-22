//
// Created by Brandon on 2019-04-18.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseListReturnModel : BaseReturnModel

@property (nonatomic, strong) NSMutableArray * list;

- (id)getItemData:(NSDictionary *)dic;
@end