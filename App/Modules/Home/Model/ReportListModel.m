//
//  ReportListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ReportListModel.h"
#import "IssueModel.h"
@implementation ReportListModel
- (id)getItemData:(NSDictionary *)dic {

    return [[IssueModel alloc] initWithDictionary:dic];
}
@end
