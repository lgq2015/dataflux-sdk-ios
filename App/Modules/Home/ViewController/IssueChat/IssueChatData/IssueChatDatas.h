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

@interface IssueChatDatas : NSObject
/**
 发送消息回调
 
 @param layout 消息
 @param error 发送是否成功
 @param progress 发送进度
 */
typedef void (^MessageBlock)(IssueChatMessagelLayout *layout, NSError *error, NSProgress *progress);

/**
 发送一条消息
 
 @param dict 消息主体
 @param sessionId 会话id
 @param messageType 消息类型
 @param messageBlock 发送消息回调
 */
+(void)sendMessage:(NSDictionary *)dict sessionId:(NSString *)sessionId messageType:(PWChatMessageType)messageType messageBlock:(MessageBlock)messageBlock;
/**
 接收一条消息
 
 @param dic 消息内容
 @return 消息模型布局
 */
+(IssueChatMessagelLayout *)receiveMessage:(NSDictionary *)dic;
/**
 请求进入页面前新的聊天内容
 @param sessionId 传入会话id
 @param callback 返回会话对象数组
 */
+(void)LoadingMessagesStartWithChat:(NSString *)sessionId callBack:(void (^)(NSMutableArray <IssueChatMessagelLayout *> *))callback;
/**
 处理消息数组 一般进入聊天界面会初始化之前的消息展示
 
 @param sessionId 会话id  凭此去数据库拿消息缓存
 @return 返回消息模型布局后的数组
 */
+(NSMutableArray *)receiveMessages:(NSString *)sessionId;
@end

NS_ASSUME_NONNULL_END
