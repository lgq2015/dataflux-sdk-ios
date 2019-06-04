//
//  CalendarIssueModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarIssueModel.h"

@implementation CalendarIssueModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self setValueWithDict:dict];
//        });
    }
    return self;
}
- (void)setValueWithDict:(NSDictionary *)dict{
    
    NSDictionary *account_info = PWSafeDictionaryVal(dict, @"account_info");
    NSDictionary *issueSnapshotJSON_cache = PWSafeDictionaryVal(dict, @"issueSnapshotJSON_cache");
    if (issueSnapshotJSON_cache) {
        self.contentText = [issueSnapshotJSON_cache stringValueForKey:@"title" default:@""];
    }
    if ([issueSnapshotJSON_cache containsObjectForKey:@"renderedText"]) {
        NSDictionary *renderedText = PWSafeDictionaryVal(issueSnapshotJSON_cache, @"renderedText");
        self.contentText = [renderedText stringValueForKey:@"title" default:@""];
    }
    NSString *updateTime = [dict stringValueForKey:@"updateTime" default:@""];
    NSString *subType = [dict stringValueForKey:@"subType" default:@""];
    NSString *type = [dict stringValueForKey:@"type" default:@""];
    if ([type isEqualToString:@"bizPoint"]&& [subType isEqualToString:@"updateExpertGroups"]) {
        
    }else if([subType isEqualToString:@"markTookOver"] || [subType isEqualToString:@"markRecovered"]){
        NSString *name = [account_info stringValueForKey:@"name" default:@""];
        NSString *text = NSLocalizedString(subType, @"");
        self.typeText = [text stringByReplacingOccurrencesOfString:@"#" withString:name];
    }else{
          NSString *key = [NSString stringWithFormat:@"issue.%@",subType];
          self.typeText = NSLocalizedString(key, @"");
    }
    self.timeText = [NSString getLocalDateFormateUTCDate:updateTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outdateFormatted:@"hh:mm"];
    NSString *level = [issueSnapshotJSON_cache stringValueForKey:@"level" default:@""];
    if ([level isEqualToString:@"danger"]) {
        self.state = MonitorListStateSeriousness;
    }else if([level isEqualToString:@"warning"]){
        self.state = MonitorListStateWarning;
    }else{
        self.state =MonitorListStateCommon;
    }
    NSString *status = [issueSnapshotJSON_cache stringValueForKey:@"status" default:@""];
    if ([status isEqualToString:@"recovered"]) {
        self.state =MonitorListStateRecommend;
    }else if ([status isEqualToString:@"discarded"]){
        self.state = MonitorListStateLoseeEfficacy;
    }
    self.issueId = [issueSnapshotJSON_cache stringValueForKey:@"id" default:@""];
    self.calendarContentH = [self.contentText strSizeWithMaxWidth:ZOOM_SCALE(240) withFont:RegularFONT(16)].height+10;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatteds = [dateFormatter dateFromString:updateTime];
    self.dayDate = dateFormatteds;
    self.groupTitle = [dateFormatteds getCalenarTimeStr];
    self.seq = [dict longValueForKey:@"seq" default:0];
}

@end
