//
//  IssueChatDatas.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssueChatMessagelLayout.h"

NS_ASSUME_NONNULL_BEGIN
@class IssueLogModel;
typedef NS_ENUM(NSInteger, UploadType){
    UploadTypeNotStarted,
    UploadTypeSuccess,
    UploadTypeError,
};
@interface IssueChatDatas : NSObject
/**
 发送消息回调
 
 @param model 消息
 @param type 发送是否成功
 @param progress 发送进度
 */
typedef void (^MessageBlock)(IssueLogModel *model, UploadType type, float progress);

/**
 发送一条消息
 
 @param model 消息主体
 @param sessionId 会话id
 @param messageType 消息类型
 @param messageBlock 发送消息回调
 */
+(void)sendMessage:(IssueLogModel *)model sessionId:(NSString *)sessionId messageType:(PWChatMessageType)messageType messageBlock:(MessageBlock)messageBlock;
/**
 接收一条消息
 
 @param dic 消息内容
 @return 消息模型布局
 */
+(IssueChatMessagelLayout *)receiveMessage:(NSDictionary *)dic;
/**
 请求进入页面前新的聊天内容
 @param issueId 传入会话id
 @param callback 返回会话对象数组
 */
+(void)LoadingMessagesStartWithChat:(NSString *)issueId callBack:(void (^)(NSMutableArray <IssueChatMessagelLayout *> *))callback;

+ (NSMutableArray *)bindArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END