//
// Created by Brandon on 2019-04-18.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueLogListModel.h"
#import "IssueLogModel.h"


@implementation IssueLogListModel {

}

- (id)getItemData:(NSDictionary *)dic {
    return [[IssueLogModel alloc] initWithDictionary:dic];
}


@end