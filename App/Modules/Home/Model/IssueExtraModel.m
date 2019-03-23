//
//  IssueExtraModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueExtraModel.h"

@implementation IssueExtraModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}
- (void)setValueWithDict:(NSDictionary *)dict{
    NSDictionary *externalDownloadURL = dict[@"externalDownloadURL"];
    self.fileUrl = [externalDownloadURL stringValueForKey:@"url" default:@""];
    NSDictionary *metaJSON = dict[@"metaJSON"];
    self.fileName = [metaJSON stringValueForKey:@"originalFileName" default:@""];
    
    NSNumber *byteSize = [metaJSON numberValueForKey:@"byteSize" default:@0];
    self.fileSize = [NSString transformedValue:byteSize];
    NSString *type =  [self.fileUrl pathExtension];
    if ([type isEqualToString:@"pdf"]) {
        self.fileIcon = @"file_PDF";
    }else if([type isEqualToString:@"docx"]){
        self.fileIcon = @"file_word";
    }else if([type isEqualToString:@"jpg"]||[type isEqualToString:@"png"]){
        self.fileIcon = @"file_img";
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



@end
