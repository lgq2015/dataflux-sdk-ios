//
//  CalendarIssueModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarIssueModel.h"
#import "IssueModel.h"
#import "UtilsConstManager.h"
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
-(instancetype)initWithIssueModel:(IssueModel *)dict{
    if (![dict isKindOfClass:[IssueModel class]]) return nil;
    if (self = [super init]) {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setValueWithModel:dict];
        //        });
    }
    return self;
}
- (void)setValueWithDict:(NSDictionary *)dict{
    
    NSDictionary *accountInfo = PWSafeDictionaryVal(dict, @"accountInfo");
    NSDictionary *issueSnapshotJSON_cache = PWSafeDictionaryVal(dict, @"issueSnapshotJSON_cache");
    if (issueSnapshotJSON_cache) {
        self.contentText = [issueSnapshotJSON_cache stringValueForKey:@"title" default:@""];
        self.isEnd = [[issueSnapshotJSON_cache stringValueForKey:@"status" default:@""] isEqualToString:@"recovered"];

    }
    if ([issueSnapshotJSON_cache containsObjectForKey:@"renderedText"]) {
        NSDictionary *renderedText = PWSafeDictionaryVal(issueSnapshotJSON_cache, @"renderedText");
        self.contentText = [renderedText stringValueForKey:@"title" default:@""];
    }
    
    NSString *updateTime = [dict stringValueForKey:@"updateTime" default:@""];
    NSString *subType = [dict stringValueForKey:@"subType" default:@""];
    NSString *type = [dict stringValueForKey:@"type" default:@""];
    NSString *key = [NSString stringWithFormat:@"local.issue.%@",subType];
    if ([type isEqualToString:@"bizPoint"]&& ([subType isEqualToString:@"updateExpertGroups"]||[subType isEqualToString:@"exitExpertGroups"])) {
        NSDictionary *metaJSON = PWSafeDictionaryVal(issueSnapshotJSON_cache, @"metaJSON");
         [[UtilsConstManager sharedUtilsConstManager] getExpertNameByKey:metaJSON[@"expertGroups"][0] name:^(NSString *name) {
             self.typeText = [NSString stringWithFormat:NSLocalizedString(key, @""),name];
         }];
    }else if([subType isEqualToString:@"markTookOver"] || [subType isEqualToString:@"markRecovered"]||[subType isEqualToString:@"issueFixed"]){
        NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
        self.typeText = [NSString stringWithFormat:NSLocalizedString(key, @""),name];
    }else if([subType isEqualToString:@"issueLevelChanged"]){
        self.typeText = [NSString stringWithFormat:@"%@%@",NSLocalizedString(key, @""),[issueSnapshotJSON_cache[@"level"] getIssueStateLevel]];
    }else if([subType isEqualToString:@"issueAssigned"]){
        NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
        NSDictionary *assignedToAccountInfo = PWSafeDictionaryVal(dict, @"assignedToAccountInfo");
        self.typeText  = [NSString stringWithFormat:@"%@ %@ %@",name,NSLocalizedString(key, @""),assignedToAccountInfo[@"name"]];
        
    }else if([subType isEqualToString:@"issueCancelAssigning"]){
        NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
        self.typeText  = [NSString stringWithFormat:@"%@ %@",name,NSLocalizedString(key, @"")];
             
    }else if([subType isEqualToString:@"issueChildAdded"]){
        NSDictionary *childIssue = PWSafeDictionaryVal(dict, @"childIssue");
        NSString *key = [childIssue stringValueForKey:@"title" default:@""];
        self.typeText = key;

    }else{
        self.typeText = NSLocalizedString(key, @"");
        if ([self.typeText isEqualToString:key]) {
            self.typeText = @"";
        }
    }
    self.timeText = [NSString getLocalDateFormateUTCDate:updateTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outdateFormatted:@"HH:mm"];
    NSString *level = [issueSnapshotJSON_cache stringValueForKey:@"level" default:@""];
    if ([level isEqualToString:@"danger"]) {
        self.state = IssueStateSeriousness;
    }else if([level isEqualToString:@"warning"]){
        self.state = IssueStateWarning;
    }else{
        self.state =IssueStateCommon;
    }
    self.issueId = [issueSnapshotJSON_cache stringValueForKey:@"id" default:@""];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatteds = [dateFormatter dateFromString:updateTime];
    self.dayDate = dateFormatteds;
    self.groupTitle = [dateFormatteds getCalenarTimeStr];
   
    if (self.contentText.length == 0) {
        self.contentText = NSLocalizedString(@"local.issue.issueLogAbnormalDisplay", @"");
    }
    self.calendarContentH = [self.contentText strSizeWithMaxWidth:kWidth-Interval(61) withFont:RegularFONT(15)].height+10;
    CGSize titleSize  = [self.typeText strSizeWithMaxWidth:kWidth-ZOOM_SCALE(66)-Interval(69) withFont:RegularFONT(12)];
    if (titleSize.height<=ZOOM_SCALE(17)) {
        titleSize.height = ZOOM_SCALE(17);
    }else{
        titleSize.height = titleSize.height+5;
    }
    self.titleSize = titleSize;
    
    self.seq = [dict longValueForKey:@"seq" default:0];
    
}
- (void)setValueWithModel:(IssueModel *)model{
//    self.contentText = .title;
    if (![model.renderedTextStr isEqualToString:@""]) {
        NSDictionary *dict = [model.renderedTextStr jsonValueDecoded];
        self.contentText = [dict stringValueForKey:@"title" default:@""];
    }else{
        self.self.contentText = model.title;
    }
    self.timeText =[NSString getLocalDateFormateUTCDate:model.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outdateFormatted:@"HH:mm"];
    self.calendarContentH = [self.contentText strSizeWithMaxWidth:kWidth-Interval(61) withFont:RegularFONT(15)].height+10;
    self.typeText = @"";
    CGSize titleSize  = [self.typeText strSizeWithMaxWidth:kWidth-ZOOM_SCALE(66)-Interval(69) withFont:RegularFONT(12)];
    if (titleSize.height<=ZOOM_SCALE(17)) {
        titleSize.height = ZOOM_SCALE(17);
    }else{
        titleSize.height = titleSize.height+5;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatteds = [dateFormatter dateFromString:model.createTime];
    self.dayDate = dateFormatteds;
    self.groupTitle = [dateFormatteds getCalenarTimeStr];
    self.titleSize = titleSize;
    self.issueId = model.issueId;
    if ([model.level isEqualToString:@"danger"]) {
        self.state = IssueStateSeriousness;
    }else if([model.level isEqualToString:@"warning"]){
        self.state = IssueStateWarning;
    }else{
        self.state =IssueStateCommon;
    }
    self.isEnd =  [model.status isEqualToString:@"recovered"];
    self.seq = model.seq;
    self.isIssue = YES;
}
@end
