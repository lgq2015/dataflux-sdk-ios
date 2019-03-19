//
//  MonitorListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/27.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "MonitorListModel.h"
#import "IssueModel.h"
@implementation MonitorListModel
- (instancetype)initWithJsonDictionary:(IssueModel *)model{
    if (![model isKindOfClass:[IssueModel class]]) return nil;
    if (self = [super init]) {
        [self setValueWithModel:model];
    }
    return self;
}
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}
- (void)setValueWithModel:(IssueModel *)model{
    if ([model.level isEqualToString:@"danger"]) {
        self.state = MonitorListStateSeriousness;
    }else if([model.level isEqualToString:@"warning"]){
        self.state = MonitorListStateWarning;
    }else{
        self.state =MonitorListStateCommon;
    }
    if ([model.status isEqualToString:@"recovered"]) {
        self.state =MonitorListStateRecommend;
    }else if ([model.status isEqualToString:@"expired"] || [model.status isEqualToString:@"discarded"]){
        self.state = MonitorListStateLoseeEfficacy;
    }
    NSArray *latestIssueLogs = [model.latestIssueLogsStr jsonValueDecoded];
    NSDictionary *issueLogDict =latestIssueLogs[0];
    if (![model.renderedTextStr isEqualToString:@""]) {
        NSDictionary *dict = [model.renderedTextStr jsonValueDecoded];
        self.title = [dict stringValueForKey:@"title" default:@""];
        self.content = [dict stringValueForKey:@"detail" default:@""];
        self.highlight = [dict stringValueForKey:@"highlight" default:@""];
        self.attrs = [dict stringValueForKey:@"suggestion" default:@""];
    }else{
        if ([model.subType isEqualToString:@"buildInCheck"] && ![model.originInfoJSONStr isEqualToString:@""] ) {
            NSDictionary *dict = [model.originInfoJSONStr jsonValueDecoded];
            NSString *checkKey = [dict stringValueForKey:@"checkKey" default:@""];
            if ([checkKey isEqualToString:@"invalidIssueSource"]) {
                self.title =@"情报源异常";
            }
        }else{
        self.title = model.title;
        self.content = model.content;
        }
    }
    NSDictionary *account_info = issueLogDict[@"account_info"];
    if (account_info.allKeys>0) {
        NSString *account = [account_info stringValueForKey:@"name" default:@""];
        self.issueLog =[NSString stringWithFormat:@"%@:%@",account,[issueLogDict stringValueForKey:@"content" default:@""]];
    }else{
        self.issueLog = [issueLogDict stringValueForKey:@"content" default:@""];
    }
    self.time = [NSString getLocalDateFormateUTCDate:model.updateTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    if ([model.origin isEqualToString:@"user"]) {
        self.isFromUser = YES;
    }else{
        self.isFromUser = NO;
    }
    
    self.isRead = model.isRead;
    self.issueId = model.issueId;
    self.accountId = model.accountId;
}
- (void)setValueWithDict:(NSDictionary *)dict{
    IssueModel *model = [[IssueModel alloc]initWithDictionary:dict];
    [self setValueWithModel:model];
}
@end
