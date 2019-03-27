//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWChatMessagelLayout.h"


@interface IssueLogModel : PWChatMessagelLayout

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *subType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic) NSInteger sendStatus;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, strong) NSString *id;
@property (nonatomic) long long seq;
@property (nonatomic,strong) NSString* origin;
@property (nonatomic,strong) NSString* originInfoJSONStr;
@property (nonatomic,strong) NSString* metaJsonStr;
@property (nonatomic,strong) NSString* externalDownloadURLstr;
@property (nonatomic,strong) NSString* accountInfoStr;


//@property (nonatomic,strong) NSDictionary* originInfoJSON;
//@property (nonatomic,strong) NSDictionary* metaJson;
//@property (nonatomic,strong) NSDictionary* externalDownloadURL;
//@property (nonatomic,strong) NSDictionary* accountInfo;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end