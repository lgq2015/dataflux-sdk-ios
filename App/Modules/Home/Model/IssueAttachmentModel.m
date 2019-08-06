//
//  IssueAttachmentModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueAttachmentModel.h"

@implementation IssueAttachmentModel
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
    NSString *type =  [self.fileName pathExtension];
    self.fileType = type;
    self.fileIcon = [type getFileIcon];
}



@end
