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
    if([model.origin isEqualToString:@"me"]){
        [self setUserSendIssueLog:model];
        return;
    }
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
        self.memberId = userID;
        if ([[userID stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:getPWUserID]) {
            self.messageFrom = PWChatMessageFromMe;
            self.headerImgurl =[userManager.curUserInfo.tags stringValueForKey:@"pwAvatar" default:@""];
            self.nameStr = [time accurateTimeStr];
        }else{
            self.messageFrom = PWChatMessageFromOther;
            self.nameStr = [NSString stringWithFormat:@"%@ %@",nickname,[time accurateTimeStr]];
            [userManager getTeamMenberWithId:userID memberBlock:^(NSDictionary *member) {
                if (member) {
                    NSDictionary *tags =PWSafeDictionaryVal(member,@"tags");
                    self.headerImgurl = [tags stringValueForKey:@"pwAvatar" default:@""];
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
     
            if ([type isEqualToString:@"pdf"]) {
                self.fileIcon = @"file_PDF";
            }else if([type isEqualToString:@"docx"]||[type isEqualToString:@"doc"]){
                self.fileIcon = @"file_word";
            }else if([type isEqualToString:@"jpg"]||[type isEqualToString:@"png"]){
                self.fileIcon = @"file_img";
            }else if([type isEqualToString:@"ppt"] ||[type isEqualToString:@"pptx"]){
                self.fileIcon = @"file_PPT";
            }else if([type isEqualToString:@"xlsx"]||[type isEqualToString:@"xls"]||[type isEqualToString:@"csv"]){
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
            }else if([type isEqualToString:@"txt"]){
                self.fileIcon = @"file_txt";
            }else{
                self.fileIcon = @"file";
            }
        }
        
    }else{
        NSDictionary *metaJSON = [model.metaJsonStr jsonValueDecoded];
        NSString *subType = model.subType;
        if ([subType isEqualToString:@"exitExpertGroups"]) {
            self.systermStr =@"您邀请的专家已退出讨论";
        }
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
        self.textString = model.text;
        self.messageType = PWChatMessageTypeText;
        self.cellString = PWChatTextCellId;
    }
    if (model.fileName) {
        self.messageType = PWChatMessageTypeFile;
        self.cellString = PWChatFileCellId;
        self.fileName = model.fileName;
    }
    self.sendError = model.sendError;
    self.isSend = YES;
    self.model = model;
}
@end
