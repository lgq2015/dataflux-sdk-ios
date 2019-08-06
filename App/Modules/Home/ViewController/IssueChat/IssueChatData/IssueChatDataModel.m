//
//  IssueChatDataModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatDataModel.h"
#import "IssueLogModel.h"
@implementation IssueChatDataModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}
- (instancetype)initWithIssueLogModel:(IssueLogModel *)model{
    if (![model isKindOfClass:[IssueLogModel class]]) return nil;
    if (self = [super init]) {
        [self setValueWithModel:model];
    }
    return self;
}
- (void)setValueWithDict:(NSDictionary *)dict{
    if ([dict[@"origin"] isEqualToString:@"user"]) {
        NSDictionary *accountInfo = dict[@"accountInfo"];
        NSString *nickname = [accountInfo stringValueForKey:@"nickname" default:@""];
        if ([nickname isEqualToString:@""]) {
            NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
            nickname = name;
        }
        NSString *createTime = [dict stringValueForKey:@"createTime" default:@""];
        NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
        NSString *userID = [accountInfo stringValueForKey:@"id" default:@""];
        if ([userID isEqualToString:getPWUserID]) {
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
            self.fileIcon = [type getFileIcon];
        }
       
    }else{
        NSString *subType = dict[@"subType"];
        self.systermStr = [NSLocalizedString(subType, @"") stringByReplacingOccurrencesOfString:@"#" withString:NSLocalizedString(@"local.experts", @"")];
        self.type = 4;
    }
}
- (void)setValueWithModel:(IssueLogModel *)model{
    if ([model.origin isEqualToString:@"user"]) {
        NSDictionary *accountInfo =[model.accountInfoStr jsonValueDecoded];
        NSString *nickname = [accountInfo stringValueForKey:@"nickname" default:@""];
        if ([nickname isEqualToString:@""]) {
            NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
            nickname = name;
        }
        NSString *createTime = model.createTime;
        NSString *time =[NSString getLocalDateFormateUTCDate:createTime formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
        NSString *userID = [accountInfo stringValueForKey:@"id" default:@""];
        if ([userID isEqualToString:getPWUserID]) {
            self.from = 1;
            self.name = [time accurateTimeStr];
        }else{
            self.from = 2;
            self.name = [NSString stringWithFormat:@"%@ %@",nickname,[time accurateTimeStr]];
        }
        
    }else{
        self.from = 3;
    }
    NSString *type = model.type;
    if ([type isEqualToString:@"text"]) {
        self.type = 1;
        self.text = model.content;
    }else if([type isEqualToString:@"attachment"]){
        NSDictionary *externalDownloadURL = [model.externalDownloadURLStr jsonValueDecoded];
        NSString *url = [externalDownloadURL stringValueForKey:@"url" default:@""];
        NSString *type =  [url pathExtension];
        
        if([type isEqualToString:@"jpg"]||[type isEqualToString:@"png"]){
            self.type = 2;
            self.image = url;
        }else{
            self.type = 3;
            self.fileUrl = url;
            NSDictionary *metaJSON = [model.metaJsonStr jsonValueDecoded];
            self.fileName = [metaJSON stringValueForKey:@"originalFileName" default:@""];
            self.fileSize = [NSString transformedValue:[metaJSON stringValueForKey:@"byteSize" default:@""]];
            self.fileIcon = [type getFileIcon];
        }
        
    }else{
        NSString *subType = model.subType;
        self.systermStr = [NSLocalizedString(subType, @"") stringByReplacingOccurrencesOfString:@"#" withString:NSLocalizedString(@"local.experts", @"")];
        self.type = 4;
    }
}
@end
