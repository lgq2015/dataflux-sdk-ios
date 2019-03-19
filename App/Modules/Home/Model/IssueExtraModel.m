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
    self.fileSize = [self transformedValue:byteSize];
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
    }
}
- (NSString *)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"M",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%0.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}


@end
