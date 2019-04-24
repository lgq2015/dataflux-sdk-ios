//
//  IssueChatDatas.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatDatas.h"
#import "IssueChatDataModel.h"
#import "IssueChatDataManager.h"
#import "IssueLogModel.h"
#import "IssueListManger.h"
#import "IssueLogListModel.h"
#import "AddIssueLogReturnModel.h"

@implementation IssueChatDatas
+(void)sendMessage:(IssueLogModel *)model sessionId:(NSString *)sessionId messageType:(PWChatMessageType)messageType messageBlock:(MessageBlock)messageBlock{

    switch (messageType) {
        case PWChatMessageTypeText:{
            [[PWHttpEngine sharedInstance] addIssueLogWithIssueid:sessionId text:model.text callBack:^(id response) {
                AddIssueLogReturnModel *data = ((AddIssueLogReturnModel *) response) ;
                if (data.isSuccess) {
                    model.id = data.id;
                    messageBlock ? messageBlock(model, UploadTypeSuccess, 1) : nil;
                } else {
                    messageBlock ? messageBlock(model, UploadTypeError, 1) : nil;
                }
            }];
        }
            break;
        case PWChatMessageTypeImage:{
           
            NSDictionary *param = @{@"type":@"attachment",@"subType":@"comment"};
            [PWNetworking uploadFileWithUrl:PW_issueUploadAttachment(sessionId) params:param fileData:model.imageData type:@"jpg" name:@"files" fileName:model.imageName mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                float progress = 1.0*bytesWritten/totalBytes;
                messageBlock(model,UploadTypeNotStarted,progress);

            } successBlock:^(id response) {
                messageBlock(model,UploadTypeSuccess,1);
            } failBlock:^(NSError *error) {
                messageBlock(model,UploadTypeError,0);
                [error errorToast];
            }];
        }
            break;
    
    
        default:
            break;
    }
    
//    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:message];
    
   
   
}
+(IssueChatMessagelLayout *)receiveMessage:(NSDictionary *)dic{
    return [IssueChatDatas getMessageWithDic:dic];
}
//消息内容生成消息模型
+(IssueChatMessagelLayout *)getMessageWithDic:(NSDictionary *)dic{
    IssueChatDataModel *model = [[IssueChatDataModel alloc]initWithDictionary:dic];
    
    IssueChatMessage *message = [IssueChatMessage new];
    
    PWChatMessageType messageType = (PWChatMessageType)model.type;
    PWChatMessageFrom messageFrom = (PWChatMessageFrom)model.from;
    
    if(messageFrom == PWChatMessageFromMe){
        message.messageFrom = PWChatMessageFromMe;
//        message.backImgString = @"icon_qipao1";
    }else if(messageType == PWChatMessageFromOther){
        message.messageFrom = PWChatMessageFromOther;
//        message.backImgString = @"icon_qipao2";
    }else{
        message.messageFrom = PWChatMessageFromSystem;
        message.systermStr = model.systermStr;
    }
    
    
    message.sendError    = NO;
    message.headerImgurl = model.headerImg;
//    message.messageId    = dic[@"messageId"];
    message.textColor    = PWChatTextColor;
    message.messageType  = messageType;
    
    
    
    //判断消息类型
    if(message.messageType == PWChatMessageTypeText){
        
        message.cellString   = PWChatTextCellId;
        message.textString = model.text;
    }else if (message.messageType == PWChatMessageTypeImage){
        message.cellString   = PWChatImageCellId;
        message.imageString = model.image;
        
    }else if(message.messageType == PWChatMessageTypeFile){
        message.fileName = model.fileName;
        message.filePath = model.fileUrl;
    }
    
    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:message];
    return layout;
    
}

+ (void)LoadingMessagesStartWithChat:(NSString *)issueId callBack:(void (^)(NSMutableArray <IssueChatMessagelLayout *> *))callback {

    BOOL endDataComplete = [[IssueListManger sharedIssueListManger] checkIssueLastStatus:issueId];
    __block long long lastCheckSeq = [[IssueChatDataManager sharedInstance] getLastDataCheckSeqInOnPage:issueId pageMarker:nil];

    void (^bindView)(long long) = ^void(long long newLastCheckSeq){

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *array = [[IssueChatDataManager sharedInstance]
                    getChatIssueLogDatas:issueId startSeq:nil endSeq:newLastCheckSeq];
            dispatch_sync_on_main_queue(^{
                NSMutableArray *newChatArray = [self bindArray:array];
                callback ? callback(newChatArray) : nil;
            });
        });
    };


    if (!endDataComplete || lastCheckSeq > 0) {

        long long pageMarker = !endDataComplete? 0 :lastCheckSeq;
        [[IssueChatDataManager sharedInstance] fetchHistory:issueId
                                                 pageMarker:pageMarker callBack:^(IssueLogListModel *model) {
            if(model.isSuccess){
                //重新获取最后一页需要请求的标记位置
                long long newLastCheckSeq =[[IssueChatDataManager sharedInstance]
                        getLastDataCheckSeqInOnPage:issueId pageMarker:nil];
                bindView(newLastCheckSeq);
            } else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
            
        }];

    } else {
        bindView(lastCheckSeq);
    }

}

+(NSMutableArray *)bindArray:(NSArray *)array{
     NSMutableArray *newChatArray = [NSMutableArray new];

    [array enumerateObjectsUsingBlock:^(IssueLogModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        IssueChatMessage *chatModel = [[IssueChatMessage alloc] initWithIssueLogModel:obj];
        IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc] initWithMessage:chatModel];
        [newChatArray addObject:layout];
    }];

    return newChatArray;
}

@end
