//
//  PWChatDataModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatDataModel.h"

@implementation PWChatDataModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}
- (void)setValueWithDict:(NSDictionary *)dict{
    if ([dict[@"origin"] isEqualToString:@"user"]) {
        NSDictionary *account_info = dict[@"account_info"];
        NSString *nickname = [account_info stringValueForKey:@"nickname" default:@""];
        if ([nickname isEqualToString:@""]) {
            NSString *name = [account_info stringValueForKey:@"name" default:@""];
            nickname = name;
        }
        NSString *createTime = [dict stringValueForKey:@"createTime" default:@""];
        NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
        NSString *userID = [account_info stringValueForKey:@"id" default:@""];
        if ([[userID stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:getPWUserID]) {
            self.from = 1;
            self.name = [time accurateTimeStr];
        }else{
            self.from = 2;
            self.name = [NSString stringWithFormat:@"%@ %@",nickname,[time accurateTimeStr]];
        }
        
    }else{
            self.from = 3;
    }
    NSString *type = [dict stringValueForKey:@"type" default:@""];
    if ([type isEqualToString:@"text"]) {
        self.type = 1;
        self.text = [dict stringValueForKey:@"content" default:@""];
    }else if([type isEqualToString:@"attachment"]){
        NSDictionary *externalDownloadURL = dict[@"externalDownloadURL"];
        NSString *url = [externalDownloadURL stringValueForKey:@"url" default:@""];
        NSString *type =  [url pathExtension];
        
        if([type isEqualToString:@"jpg"]||[type isEqualToString:@"png"]){
            self.type = 2;
            self.image = url;
        }else{
            self.type = 3;
            self.fileUrl = url;
        NSDictionary *metaJSON = dict[@"metaJSON"];
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
        NSString *subType = dict[@"subType"];
        if ([subType isEqualToString:@"updateExpertGroups"]) {
            self.systermStr = @"您邀请的专家已加入讨论";
        }
        if ([subType isEqualToString:@"exitExpertGroups"]) {
            self.systermStr = @"您邀请的专家已退出讨论";
        }
        self.type = 4;
    }
}
@end
