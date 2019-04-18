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
@implementation IssueChatDatas
+(void)sendMessage:(IssueLogModel *)model sessionId:(NSString *)sessionId messageType:(PWChatMessageType)messageType messageBlock:(MessageBlock)messageBlock{

    switch (messageType) {
        case PWChatMessageTypeText:{
            [[PWHttpEngine sharedInstance] addIssueLogWithIssueid:sessionId text:model.text callBack:^(id response) {
                BaseReturnModel *data = ((BaseReturnModel *) response) ;
                if (data.isSuccess) {
                    messageBlock?messageBlock(model,UploadTypeSuccess,1):nil;
                }else{
                    messageBlock?messageBlock(model,UploadTypeError,1):nil;
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
+(void)LoadingMessagesStartWithChat:(NSString *)sessionId callBack:(void (^)(NSMutableArray <IssueChatMessagelLayout *> *))callback {
    long long pageMarker = [[IssueChatDataManager sharedInstance] getLastChatIssueLogMarker:sessionId];
    __block NSMutableArray *newChatArray = [NSMutableArray new];

    [[IssueChatDataManager sharedInstance] fetchLatestChatIssueLog:sessionId callBack:^(IssueLogListModel *model) {

    }];

}
+(NSMutableArray *)receiveMessages:(NSString *)sessionId{
    NSArray<IssueLogModel *> *historyDatas= [[IssueChatDataManager sharedInstance]
                            getChatIssueLogDatas:sessionId pageMarker:-1];
    NSMutableArray *messageDatas = [NSMutableArray new];
    [historyDatas enumerateObjectsUsingBlock:^(IssueLogModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        IssueChatMessage *chatModel = [[IssueChatMessage alloc]initWithIssueLogModel:obj];
        IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:chatModel];
        [messageDatas addObject:layout];

    }];
    return [NSMutableArray arrayWithArray:messageDatas];
}
@end
