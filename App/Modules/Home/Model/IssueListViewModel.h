//
//  IssueListViewModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/11/27.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssueSourceViewModel.h"
typedef NS_ENUM(NSInteger, IssueState){
    IssueStateWarning = 1,
    IssueStateSeriousness,
    IssueStateRecommend,
    IssueStateCommon,
    IssueStateLoseeEfficacy,
};

@class IssueModel;
@interface IssueListViewModel : NSObject
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *title;   //
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *attrs;
@property (nonatomic, strong) NSString *issueLog; //最后一条日志
@property (nonatomic, strong) NSString *markStatusStr;
@property (nonatomic, strong) NSString *markUserIcon;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) IssueState state;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *updataTime;
@property (nonatomic, strong) NSDictionary *reference;//handbooks array   "title": "文章标题","url"
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL issueLogRead;
@property (nonatomic, assign) BOOL isFromUser;
@property (nonatomic, assign) BOOL isCallME;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, strong) NSString * ticketStatus;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, assign) SourceType sourceType;
@property (nonatomic, assign) BOOL isInvalidIssue;
@property (nonatomic, strong) NSDictionary *tags;
@property (nonatomic, strong) NSString *issueSourceId;
@property (nonatomic, strong) NSString *sourceName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *chatTime;
@property (nonatomic, strong) NSDictionary *atStatus;
@property (nonatomic, strong) NSDictionary *statusChangeAccountInfo;
@property (nonatomic, strong) NSDictionary *assignAccountInfo;
@property (nonatomic, strong) NSDictionary *assignedToAccountInfo;
@property (nonatomic, strong) NSString *watchInfoJSONStr;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) BOOL recovered;
@property (nonatomic, strong) NSString *originName;
- (instancetype)initWithJsonDictionary:(IssueModel *)model;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
