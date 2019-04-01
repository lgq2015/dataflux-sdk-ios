//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "CarrierItemModel.h"


@implementation CarrierItemModel {

}


- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];

    NSDictionary *content = dict[@"content"];
    self.uploadUid = [content stringValueForKey:@"uploader_uid" default:@""];
    self.desc = [content stringValueForKey:@"desc" default:@""];
    self.host = [content stringValueForKey:@"host" default:@""];
    self.hostName = [content stringValueForKey:@"host_name" default:@""];

}


@end