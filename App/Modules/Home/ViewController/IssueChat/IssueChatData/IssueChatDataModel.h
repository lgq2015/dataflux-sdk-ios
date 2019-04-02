//
//  IssueChatDataModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IssueLogModel;
NS_ASSUME_NONNULL_BEGIN

@interface IssueChatDataModel : NSObject
@property (nonatomic, strong) NSString *headerImg;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger from;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *image;

//文件
@property (nonatomic, strong) NSString *fileIcon;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileSize;

//系统消息
@property (nonatomic, strong) NSString *systermStr;

@property (nonatomic, strong) NSString *issueID;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithIssueLogModel:(IssueLogModel *)model;

@end

NS_ASSUME_NONNULL_END
