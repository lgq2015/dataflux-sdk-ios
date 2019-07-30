//
//  CalendarListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarListModel.h"
#import "CalendarIssueModel.h"
#import "IssueModel.h"
@implementation CalendarListModel
- (id)getItemData:(NSDictionary *)dic {
    CalendarViewType type = [userManager getCurrentCalendarViewType];
    if (type == CalendarViewTypeGeneral) {
        IssueModel *issue = [[IssueModel alloc]initWithDictionary:dic];
    return [[CalendarIssueModel alloc] initWithIssueModel:issue];
    }else{
    return [[CalendarIssueModel alloc] initWithDictionary:dic];
    }
}
@end
