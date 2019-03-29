//
//  IssueModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueModel : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *issueSourceId;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) long actSeq;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString * ticketStatus;
@property (nonatomic, strong) NSString *subType;

//转译为json 用于保存数据库
@property (nonatomic, strong) NSString *latestIssueLogsStr;  // issueList最下面显示 需拼接 //[@"title"] subtitle
@property (nonatomic, strong) NSString *renderedTextStr;     // 可能有可能无 有就显示
@property (nonatomic, strong) NSString *originInfoJSONStr;   // 异常情报处理  后台返回缺失，前端自己处理
@property (nonatomic, assign) BOOL isRead;                   // 数据库存储已读状态

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
