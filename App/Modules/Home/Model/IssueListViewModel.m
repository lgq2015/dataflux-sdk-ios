//
//  IssueListViewModel.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/27.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "IssueListViewModel.h"
#import "IssueModel.h"
#import "IssueSourceManger.h"
@implementation IssueListViewModel
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

    [model checkInvalidIssue];
    self.isInvalidIssue = model.isInvalidIssue;

    if ([model.level isEqualToString:@"danger"]) {
        self.state = MonitorListStateSeriousness;
    }else if([model.level isEqualToString:@"warning"]){
        self.state = MonitorListStateWarning;
    }else{
        self.state =MonitorListStateCommon;
    }
    if ([model.status isEqualToString:@"recovered"]) {
        self.state =MonitorListStateRecommend;
    }else if ([model.status isEqualToString:@"discarded"]){
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
        self.title = model.title;
        self.content = model.content;
    }
    NSDictionary *account_info = issueLogDict[@"account_info"];
    if (account_info.allKeys>0) {
        NSString *account = [account_info stringValueForKey:@"name" default:@""];
        NSString *nickname = [account_info stringValueForKey:@"nickname" default:@""];
        NSString *type = [issueLogDict stringValueForKey:@"type" default:@""];
        NSString *content;
        if ([type isEqualToString:@"attachment"]) {
            NSString *fileName = [issueLogDict[@"metaJSON"] stringValueForKey:@"originalFileName" default:@""];
             NSString *type =  [fileName pathExtension];
            if([type isEqualToString:@"jpg"]||[type isEqualToString:@"png"]||[type isEqualToString:@"jpeg"]){
                content =@"[图片]";
            }else{
                content = [NSString stringWithFormat:@"[文件]%@",fileName];
            }
        }else{
            content =[issueLogDict stringValueForKey:@"content" default:@""];
        }
        if (nickname.length>0) {
            self.issueLog =[NSString stringWithFormat:@"%@:  %@",nickname,content];
        }else{
            self.issueLog =[NSString stringWithFormat:@"%@: %@",account,content];
        }
    }else{
        self.issueLog = [issueLogDict stringValueForKey:@"content" default:@""];
    }
    self.time = [NSString getLocalDateFormateUTCDate:model.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    if ([model.origin isEqualToString:@"user"]) {
        self.isFromUser = YES;
    }else{
        self.isFromUser = NO;
    }
    
    self.ticketStatus = model.ticketStatus;
    self.isRead = model.isRead;
    if(model.seq>0){
        self.issueLogRead = model.issueLogRead;
    } else{
        self.issueLogRead = YES;
    }
    self.issueId = model.issueId;
    self.accountId = model.accountId;
    self.issueSourceId = model.issueSourceId;
    if (model.issueSourceId.length>0) {
         NSDictionary *source = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameAndProviderWithID:model.issueSourceId];
        if (source) {
            NSString *type = [source stringValueForKey:@"provider" default:@""];
            self.sourceName = [source stringValueForKey:@"name" default:@""];
            if ([type isEqualToString:@"carrier.corsairmaster"]){
                self.icon = @"icon_foresight_small";
                
            }else if([type isEqualToString:@"aliyun"]) {
                self.icon = @"icon_alis";
            }else if([type isEqualToString:@"qcloud"]){
                self.icon = @"icon_tencent_small";
            }else if([type isEqualToString:@"aws"]){
                self.icon = @"icon_aws_small";
            }else if([type isEqualToString:@"ucloud"]){
                self.icon = @"icon_tencent_small";
            }else if ([type isEqualToString:@"domain"]){
                self.icon = @"icon_domainname_small";
            }else if([type isEqualToString:@"carrier.corsair"]){
                self.icon =@"icon_mainframe_small";
            }else if([type isEqualToString:@"carrier.alert"]){
                self.sourceName = @"消息坞";
                self.icon = @"message_docks";
            }
        }
    }else{
        self.icon = @"issue_selfbuild";
        self.sourceName = @"自建情报";
    }
   
}
- (void)setValueWithDict:(NSDictionary *)dict{
    IssueModel *model = [[IssueModel alloc]initWithDictionary:dict];
    [self setValueWithModel:model];
}
@end
