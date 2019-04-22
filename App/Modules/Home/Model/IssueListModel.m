//
// Created by Brandon on 2019-03-31.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueListModel.h"
#import "IssueModel.h"


@implementation IssueListModel {

}

- (id)getItemData:(NSDictionary *)dic {
    return [[IssueModel alloc] initWithDictionary:dic];
}



@end