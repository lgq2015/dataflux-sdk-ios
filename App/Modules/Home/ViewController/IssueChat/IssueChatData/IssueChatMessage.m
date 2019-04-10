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
-(void)setTextString:(NSString *)textString{
    _textString = textString;
    
}
- (void)setValueWithModel:(IssueLogModel *)model{
    self.textColor = PWTextBlackColor;
    if ([model.origin isEqualToString:@"user"]) {
        NSDictionary *account_info =[model.accountInfoStr jsonValueDecoded];
        NSString *nickname = [account_info stringValueForKey:@"nickname" default:@""];
        if ([nickname isEqualToString:@""]) {
            NSString *name = [account_info stringValueForKey:@"name" default:@""];
            nickname = name;
        }
        NSString *createTime = model.createTime;
        NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
        NSString *userID = [account_info stringValueForKey:@"id" default:@""];
        if ([[userID stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:getPWUserID]) {
            self.messageFrom = PWChatMessageFromMe;
            self.headerImgurl =[userManager.curUserInfo.tags stringValueForKey:@"pwAvatar" default:@""];
            self.nameStr = [time accurateTimeStr];
        }else{
            self.messageFrom = PWChatMessageFromOther;
            self.nameStr = [NSString stringWithFormat:@"%@ %@",nickname,[time accurateTimeStr]];
            [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
                if (isSuccess) {
                    [member enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:NSDictionary.class]) {
                            if(  [[(NSDictionary *)obj stringValueForKey:@"id" default:@""] isEqualToString:userID]){
                                NSDictionary *tags =PWSafeDictionaryVal(obj,@"tags");
                            self.headerImgurl = [tags stringValueForKey:@"pwAvatar" default:@""];
                                *stop = YES;
                            }
                        }
                    }];
                }
            }];
        }
        
    }else if([model.origin isEqualToString:@"staff"]){
        self.textColor = PWWhiteColor;
        self.messageFrom = PWChatMessageFromStaff;
        if (model.accountInfoStr.length>0) {
            NSDictionary *account_info =[model.accountInfoStr jsonValueDecoded];
            NSDictionary *tags = PWSafeDictionaryVal(account_info, @"tags");
            NSString *scoutAvatar = [tags stringValueForKey:@"scoutAvatar" default:@""];
            self.headerImgurl = scoutAvatar;
            NSString *nickname = [account_info stringValueForKey:@"nickname" default:@""];
            if ([nickname isEqualToString:@""]) {
                NSString *name = [account_info stringValueForKey:@"name" default:@""];
                nickname = name;
            }
            NSString *createTime = model.createTime;
            NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            self.nameStr = [NSString stringWithFormat:@"%@ %@",nickname,[time accurateTimeStr]];
        }
    }else if([model.origin isEqualToString:@"bizSystem"]){
        self.messageFrom = PWChatMessageFromSystem;
    }
    NSString *type = model.type;
    if ([type isEqualToString:@"text"]) {
        self.messageType = PWChatMessageTypeText;
        self.textString = model.content;
        self.cellString = PWChatTextCellId;

    }else if([type isEqualToString:@"attachment"]){
        NSDictionary *externalDownloadURL = [model.externalDownloadURLStr jsonValueDecoded];
        NSString *url = [externalDownloadURL stringValueForKey:@"url" default:@""];
        NSString *type =  [url pathExtension];
        
        if([type isEqualToString:@"jpg"]||[type isEqualToString:@"png"]){
            self.messageType = PWChatMessageTypeImage;
            self.imageString = url;
            self.cellString = PWChatImageCellId;
        }else{
            self.messageType = PWChatMessageTypeFile;
            self.filePath = url;
            self.cellString = PWChatFileCellId;
          
            NSDictionary *metaJSON = [model.metaJsonStr jsonValueDecoded];
            self.fileName = [metaJSON stringValueForKey:@"originalFileName" default:@""];
            self.fileSize = [NSString transformedValue:[metaJSON stringValueForKey:@"byteSize" default:@""]];
            if ([type isEqualToString:@"pdf"]) {
                self.fileIcon = @"file_PDF";
            }else if([type isEqualToString:@"docx"]){
                self.fileIcon = @"file_word";
            }else if([type isEqualToString:@"ppt"]){
                self.fileIcon = @"file_PPT";
            }else if([type isEqualToString:@"xlsx"]){
                self.fileIcon = @"file_excel";
            }else if([type isEqualToString:@"key"]){
                self.fileIcon = @"file_keynote";
            }else if([type isEqualToString:@"numbers"]){
                self.fileIcon = @"file_numbers";
            }else if([type isEqualToString:@"pages"]){
                self.fileIcon = @"file_pages";
            }else if([type isEqualToString:@"zip"]){
                self.fileIcon = @"file_zip";
            }else if([type isEqualToString:@"rar"]){
                self.fileIcon = @"file_rar";
            }
        }
        
    }else{
        NSDictionary *metaJSON = [model.metaJsonStr jsonValueDecoded];
        NSString *subType = model.subType;
        
        if ([metaJSON[@"expertGroups"] isKindOfClass:NSArray.class]) {
            [userManager getExpertNameByKey:metaJSON[@"expertGroups"][0] name:^(NSString *name) {
                if ([subType isEqualToString:@"updateExpertGroups"]) {
                    
                    self.systermStr = [NSString stringWithFormat:@"您邀请的%@已加入讨论",name];
                }
                if ([subType isEqualToString:@"exitExpertGroups"]) {
                    self.systermStr =[NSString stringWithFormat:@"您邀请的%@已退出讨论",name];
                }
            }];
        }
       
        self.messageType = PWChatMessageTypeSysterm;
        self.cellString = PWChatSystermCellId;

    }
    if(self.messageFrom == PWChatMessageFromSystem){
        self.messageType = PWChatMessageTypeSysterm;
        self.cellString = PWChatSystermCellId;
    }
}

@end
