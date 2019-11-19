//
//  AlarmItemModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AlarmItemModel.h"

@implementation AlarmItemModel
- (void)setValueWithDict:(NSDictionary *)dict{
    [super setValueWithDict:dict];
    NSString *dateStr = [dict stringValueForKey:@"DATE" default:@""];
//    [dateStr ]
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *timeDate = [dateFormatter dateFromString:dateStr];
    self.title = [timeDate getMonthDayTimeStr];
    self.count =[NSString stringWithFormat:@"%ld",[dict longValueForKey:@"count" default:0]];
}
@end
