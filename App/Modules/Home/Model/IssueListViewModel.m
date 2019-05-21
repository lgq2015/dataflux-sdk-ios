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
#import "IssueChatDataManager.h"

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
    self.time = [NSString getLocalDateFormateUTCDate:model.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    if ([model.level isEqualToString:@"danger"]) {
        self.state = MonitorListStateSeriousness;
    }else if([model.level isEqualToString:@"warning"]){
        self.state = MonitorListStateWarning;
    }else{
        self.state =MonitorListStateCommon;
    }
    if ([model.status isEqualToString:@"recovered"]) {
        self.state =MonitorListStateRecommend;
        self.time = [NSString getLocalDateFormateUTCDate:model.endTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }else if ([model.status isEqualToString:@"discarded"]){
        self.state = MonitorListStateLoseeEfficacy;
    }
    
    if (![model.renderedTextStr isEqualToString:@""]) {
        NSDictionary *dict = [model.renderedTextStr jsonValueDecoded];
        self.title = [dict stringValueForKey:@"title" default:@""];
        self.content = [dict stringValueForKey:@"detail" default:@""];
        self.attrs = [dict stringValueForKey:@"suggestion" default:@""];
    }else{
        self.title = model.title;
        self.content = model.content;
    }
  

    NSDictionary *markTookOverInfoJSON,*markEndAccountInfo;
    if (model.markTookOverInfoJSONStr) {
        markTookOverInfoJSON = [model.markTookOverInfoJSONStr jsonValueDecoded];
    }
    if (model.markEndAccountInfoStr) {
        markEndAccountInfo = [model.markEndAccountInfoStr jsonValueDecoded];
    }
    if (model.latestIssueLogsStr) {
        NSArray *latestIssueLogs = [model.latestIssueLogsStr jsonValueDecoded];
        
        NSDictionary *issueLogDict =latestIssueLogs[0];
        NSDictionary *account_info = issueLogDict[@"account_info"];
        NSString *chatTime = [issueLogDict stringValueForKey:@"createTime" default:@""];
        chatTime = [NSString getLocalDateFormateUTCDate:chatTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        self.chatTime = [NSString compareCurrentTime:chatTime];
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
        NSDictionary *atInfoJSON = PWSafeDictionaryVal(issueLogDict, @"atInfoJSON");
        if (atInfoJSON) {
           __block NSString *string = [issueLogDict stringValueForKey:@"content" default:@""];
            NSDictionary *serviceMap = PWSafeDictionaryVal(atInfoJSON, @"serviceMap");
            NSDictionary *accountIdMap = PWSafeDictionaryVal(atInfoJSON, @"accountIdMap");
            if(serviceMap.allKeys.count>0){
                [serviceMap.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    string = [string stringByReplacingOccurrencesOfString:obj withString:serviceMap[obj]];
                }];
            }
            if(accountIdMap.allKeys.count>0){
                [accountIdMap.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    string=  [string stringByReplacingOccurrencesOfString:obj withString:accountIdMap[obj]];
                }];
            }
    
            self.issueLog = string;
        }
    }
  
   
   
    NSDictionary *tags = PWSafeDictionaryVal(markTookOverInfoJSON, @"tags");
    if (tags) {
        self.markUserIcon = [tags stringValueForKey:@"pwAvatar" default:@""];
    }
    //标记状态
    if ([model.markStatus isEqualToString:@"tookOver"]){
        NSString *name = [markTookOverInfoJSON stringValueForKey:@"name" default:@""];
        self.markStatusStr = [NSString stringWithFormat:@"%@正在处理",name];
    }else if ([model.markStatus isEqualToString:@"recovered"]){
        NSString *name = [markEndAccountInfo stringValueForKey:@"name" default:@""];
        self.markStatusStr = [NSString stringWithFormat:@"%@标记为解决",name];
    }
   
    if ([model.origin isEqualToString:@"user"]) {
        self.isFromUser = YES;
    }else{
        self.isFromUser = NO;
    }
   
        if (model.atLogSeq && model.atLogSeq>0) {
            long long seq = [[IssueChatDataManager sharedInstance] getLastReadChatIssueLogMarker:model.issueId];
            if (model.atLogSeq>seq) {
                self.isCallME = YES;
            }
        }else{
            if (model.readAtInfoStr) {
                NSDictionary *readAtInfo = [model.readAtInfoStr jsonValueDecoded];
                int unreadCount = [readAtInfo intValueForKey:@"unreadCount" default:0];
                long long lastReadSeq = [readAtInfo longLongValueForKey:@"lastReadSeq" default:0];
                long long seq = [[IssueChatDataManager sharedInstance] getLastChatIssueLogMarker:model.issueId];
                if (unreadCount>0 && lastReadSeq<seq) {
                    self.isCallME = YES;
                }
            }
   
    }
    
    self.type = model.type;
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
