//
//  CalendarListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarListModel.h"
#import "CalendarIssueModel.h"

@implementation CalendarListModel
- (id)getItemData:(NSDictionary *)dic {
   
    return [[CalendarIssueModel alloc] initWithDictionary:dic];
}
@end