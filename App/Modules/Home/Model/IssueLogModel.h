//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssueChatMessagelLayout.h"


@interface IssueLogModel : NSObject 

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *subType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger sendStatus;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, strong) NSString *id;
@property (nonatomic) long long seq;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *originInfoJSONStr;
@property (nonatomic, strong) NSString* metaJsonStr;
@property (nonatomic, strong) NSString* externalDownloadURLStr;
@property (nonatomic, strong) NSString* accountInfoStr;

//自发 issueLog
@property (nonatomic, strong) NSData *imageData;  //图片
@property (nonatomic, strong) NSString *imageName; //图片名字
@property (nonatomic, strong) NSString *text;     //文本
@property (nonatomic, assign) BOOL sendError; // true 上传失败
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, assign) BOOL dataCheckFlag;


//@property (nonatomic,strong) NSDictionary* originInfoJSON;
//@property (nonatomic,strong) NSDictionary* metaJson;
//@property (nonatomic,strong) NSDictionary* externalDownloadURL;
//@property (nonatomic,strong) NSDictionary* accountInfo;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSString *)createLastIssueLogJsonString;

- (instancetype)initSendIssueLogDefaultLogModel;
@end
