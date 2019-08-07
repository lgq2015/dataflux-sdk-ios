//
//  IssueChatMessage.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatMessage.h"
#import "IssueLogModel.h"

@implementation IssueChatMessage
- (instancetype)initWithIssueLogModel:(IssueLogModel *)model{
    if (![model isKindOfClass:[IssueLogModel class]]) return nil;
    if (self = [super init]) {
        [self setValueWithModel:model];
    }
    return self;
}
//文本消息
-(void)setTextString:(NSMutableAttributedString *)textString{
    _textString = textString;
    
}
- (void)setValueWithModel:(IssueLogModel *)model{
    self.textColor = PWTextBlackColor;
    if([model.origin isEqualToString:@"me"]){
        [self setUserSendIssueLog:model];
        return;
    }
    NSString *createTime = model.createTime;
    NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    if ([model.origin isEqualToString:@"user"]) {
        NSDictionary *accountInfo =[model.accountInfoStr jsonValueDecoded];
        NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
    
       
        self.messageFrom = PWChatMessageFromOther;
        NSString *userID = [accountInfo stringValueForKey:@"id" default:@""];
        self.memberId = userID;
        self.isAdmin  = [self.memberId isEqualToString:[userManager getTeamAdminId]];
        self.nameStr = [NSString stringWithFormat:@"%@ %@",name,[time accurateTimeStr]];
        if ([userID  isEqualToString:getPWUserID]) {
            self.headerImgurl =[userManager.curUserInfo.tags stringValueForKey:@"pwAvatar" default:@""];
        }else{
            [userManager getTeamMenberWithId:userID memberBlock:^(NSDictionary *member) {
                if (member) {
                    NSDictionary *tags =PWSafeDictionaryVal(member,@"tags");
                    self.headerImgurl = [tags stringValueForKey:@"pwAvatar" default:@""];
                }
            }];
        }
        
    }else if([model.origin isEqualToString:@"staff"]){
        self.textColor = PWTextBlackColor;
        self.messageFrom = PWChatMessageFromStaff;
        NSString *createTime = model.createTime;
        NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSArray *isps = [userManager getTeamISPs];
        NSDictionary *displayName = PWSafeDictionaryVal(isps[0], @"displayName");
        self.stuffName = [displayName stringValueForKey:@"zh_CN" default:@""];
        self.nameStr = [time accurateTimeStr];

    }else if([model.origin isEqualToString:@"bizSystem"]){
        self.messageFrom = PWChatMessageFromOther;
    }
    
    NSString *type = model.type;
    if ([type isEqualToString:@"text"]) {
        self.messageType = PWChatMessageTypeText;
        __block NSString *string = model.content;
        __block NSMutableArray *atStr = [NSMutableArray new];
        if (model.atInfoJSONStr) {
            NSDictionary *atInfoJSON = [model.atInfoJSONStr jsonValueDecoded];
            NSDictionary *serviceMap = PWSafeDictionaryVal(atInfoJSON, @"serviceMap");
            NSDictionary *accountIdMap = PWSafeDictionaryVal(atInfoJSON, @"accountIdMap");
            if(serviceMap.allKeys.count>0){
                [serviceMap.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    string = [string stringByReplacingOccurrencesOfString:obj withString:serviceMap[obj]];
                    [atStr addObject:[NSString stringWithFormat:@"@%@",serviceMap[obj]]];
                }];
            }
            if(accountIdMap.allKeys.count>0){
                [accountIdMap.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    string=  [string stringByReplacingOccurrencesOfString:obj withString:accountIdMap[obj]];
                    [atStr addObject:[NSString stringWithFormat:@"@%@",accountIdMap[obj]]];
                }];
            }
            if (self.messageFrom == PWChatMessageFromMe) {
                self.isHasAtStr = YES;
            }
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:PWTextBlackColor range:NSMakeRange(0, str.length)];
        [atStr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [string rangeOfString:obj];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2A7AF7 "] range:range];
        }];
        [str addAttribute:NSFontAttributeName value:RegularFONT(17) range:NSMakeRange(0, str.length)];
        self.textString = str;
        self.cellString = PWChatTextCellId;
    }else if([type isEqualToString:@"attachment"]){
        NSDictionary *externalDownloadURL = [model.externalDownloadURLStr jsonValueDecoded];
        NSString *url = [externalDownloadURL stringValueForKey:@"url" default:@""];
        NSString *type =  [url pathExtension];
        
        if([type isEqualToString:@"jpg"]||[type isEqualToString:@"png"]||[type isEqualToString:@"jpeg"]){
            self.messageType = PWChatMessageTypeImage;
            self.imageString = [url imageTransStr];
            self.cellString = PWChatImageCellId;
        }else{
            self.messageType = PWChatMessageTypeFile;
            self.filePath = url;
            self.cellString = PWChatFileCellId;
          
            NSDictionary *metaJSON = [model.metaJsonStr jsonValueDecoded];
            self.fileName = [metaJSON stringValueForKey:@"originalFileName" default:@""];
            self.fileSize = [NSString transformedValue:[metaJSON stringValueForKey:@"byteSize" default:@""]];
            self.fileIcon = [type getFileIcon];
        }
    }else if([model.type isEqualToString:@"keyPoint"]){
        NSDictionary *accountInfo =[model.accountInfoStr jsonValueDecoded];
        NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
       
        self.messageType = PWChatMessageTypeKeyPoint;
        if ([model.subType isEqualToString:@"markTookOver"]) {
            NSString *text = NSLocalizedString(model.subType, @"");
            self.stuffName = [text stringByReplacingOccurrencesOfString:@"#" withString:name];

        }else if([model.subType isEqualToString:@"issueCreated"]){
            if (self.messageFrom == PWChatMessageFromOther) {
                self.stuffName = [NSString stringWithFormat:NSLocalizedString(@"issue.create%@", @""),name];
            }else{
             self.stuffName = NSLocalizedString(@"issue.issueCreated", @"");
            }
        }else if([model.subType isEqualToString:@"markRecovered"]){
            NSString *text = NSLocalizedString(model.subType, @"");
            self.stuffName = [text stringByReplacingOccurrencesOfString:@"#" withString:name];
        }else if([model.subType isEqualToString:@"issueFixed"]){
            NSString *reText=[NSString stringWithFormat:NSLocalizedString(@"issue.issueFixed%@", @""),name];
            self.stuffName = reText;
        }else if([model.subType isEqualToString:@"issueLevelChanged"]){
            NSString *key = [NSString stringWithFormat:@"issue.%@",model.subType];
            if (model.issueSnapshotJSON_cacheStr){
             self.stuffName = [NSString stringWithFormat:@"%@%@",NSLocalizedString(key, @""),[[model.issueSnapshotJSON_cacheStr jsonValueDecoded][@"level"] getIssueStateLevel]];
            }else{
                self.stuffName = NSLocalizedString(@"issue.issueLogLevelChanged", @"");
            }
      
        }else if([model.subType isEqualToString:@"issueAssigned"]){
            if (model.assignedToAccountInfoStr.length>0) {
                NSDictionary *assignedToAccountInfo = [model.assignedToAccountInfoStr jsonValueDecoded];
                NSString *key = NSLocalizedString(model.subType, @"");
                self.stuffName  = [NSString stringWithFormat:@"%@ %@ %@",name,key,assignedToAccountInfo[@"name"]];
            }
        }else if([model.subType isEqualToString:@"issueCancelAssigning"]){
            if (model.issueSnapshotJSON_cacheStr.length>0) {
                NSString *key = NSLocalizedString(model.subType, @"");
                self.stuffName  = [NSString stringWithFormat:@"%@ %@",name,key];
            }

        }else if([model.subType isEqualToString:@"issueChildAdded"]){
            
            NSDictionary *childIssue = [model.childIssueStr jsonValueDecoded];
            NSString *key = [childIssue stringValueForKey:@"title" default:@""];
            self.stuffName = key;

        }else{
            NSString *key = [NSString stringWithFormat:@"issue.%@",model.subType];
            self.stuffName  = NSLocalizedString(key, @"");

        }
        self.cellString = PWChatKeyPointCellId;
        self.nameStr = [NSString compareCurrentTime:time];
    }else{
        NSDictionary *metaJSON = [model.metaJsonStr jsonValueDecoded];
        NSString *subType = model.subType;
        NSString *key = [NSString stringWithFormat:@"issue.%@",subType];
         self.systermStr = [NSLocalizedString(key, @"") stringByReplacingOccurrencesOfString:@"#" withString:NSLocalizedString(@"local.experts", @"")];
        if ([metaJSON[@"expertGroups"] isKindOfClass:NSArray.class]) {
            [userManager getExpertNameByKey:metaJSON[@"expertGroups"][0] name:^(NSString *name) {
                if ([subType isEqualToString:@"updateExpertGroups"] || [subType isEqualToString:@"exitExpertGroups"]) {
                    self.systermStr = [NSLocalizedString(key, @"") stringByReplacingOccurrencesOfString:@"#" withString:name];
                }
            }];
        }
        self.messageType = PWChatMessageTypeKeyPoint;
        self.cellString = PWChatKeyPointCellId;

    }
    if(self.messageFrom == PWChatMessageFromSystem){
        self.messageType = PWChatMessageTypeSysterm;
        self.cellString = PWChatSystermCellId;
    }
    self.model =model;
}
- (void)setUserSendIssueLog:(IssueLogModel *)model{
    NSString *createTime = model.updateTime;
    NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    self.messageFrom = PWChatMessageFromMe;
    self.headerImgurl =[userManager.curUserInfo.tags stringValueForKey:@"pwAvatar" default:@""];
    self.nameStr = [time accurateTimeStr];
    self.messageType = PWChatMessageTypeText;
    
    if (model.imageData) {
        self.messageType = PWChatMessageTypeImage;
        self.cellString = PWChatImageCellId;
        self.image = [UIImage imageWithData:model.imageData];
    }
    if (model.text) {
        __block NSString *string = model.text;
        self.messageType = PWChatMessageTypeText;
        __block NSMutableArray *atStr = [NSMutableArray new];
        if (model.atInfoJSONStr.length>0) {
            NSDictionary *atInfoJSON = [model.atInfoJSONStr jsonValueDecoded];
            NSDictionary *serviceMap = PWSafeDictionaryVal(atInfoJSON, @"serviceMap");
            NSDictionary *accountIdMap = PWSafeDictionaryVal(atInfoJSON, @"accountIdMap");
            if(serviceMap.allKeys.count>0){
                [serviceMap.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    string = [string stringByReplacingOccurrencesOfString:obj withString:serviceMap[obj]];
                    [atStr addObject:[NSString stringWithFormat:@"@%@",serviceMap[obj]]];
                }];
            }
            if(accountIdMap.allKeys.count>0){
                [accountIdMap.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    string=  [string stringByReplacingOccurrencesOfString:obj withString:accountIdMap[obj]];
                    [atStr addObject:[NSString stringWithFormat:@"@%@",accountIdMap[obj]]];
                }];
            }
            self.isHasAtStr = YES;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:PWTextBlackColor range:NSMakeRange(0, str.length)];
        [atStr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [string rangeOfString:obj];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2A7AF7"] range:range];
        }];
        [str addAttribute:NSFontAttributeName value:RegularFONT(17) range:NSMakeRange(0, str.length)];
        self.textString =str;
        self.cellString = PWChatTextCellId;
    }
    if (model.fileName) {
        self.messageType = PWChatMessageTypeFile;
        self.cellString = PWChatFileCellId;
        self.fileName = model.fileName;
    }
    self.sendStates = model.sendError?ChatSentStatesSendError:ChatSentStatesSendSuccess;
    self.model = model;
}
@end
