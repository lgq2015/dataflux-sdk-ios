//
// Created by Brandon on 2019-03-31.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueSourceListModel.h"
#import "IssueSourceModel.h"


@implementation IssueSourceListModel {

}

- (id)getItemData:(NSDictionary *)dic {
    return [[IssueSourceModel alloc] initWithDictionary:dic];
}

@end