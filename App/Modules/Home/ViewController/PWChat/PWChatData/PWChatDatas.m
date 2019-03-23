//
//  PWChatDatas.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatDatas.h"
#import "PWChatDataModel.h"

@implementation PWChatDatas
+(void)sendMessage:(NSDictionary *)dict sessionId:(NSString *)sessionId messageType:(PWChatMessageType)messageType messageBlock:(MessageBlock)messageBlock{
    
    PWChatMessage *message = [PWChatMessage new];

    message.nameStr = @"今天：";
    switch (messageType) {
        case PWChatMessageTypeText:{
            message.messageFrom = PWChatMessageFromMe;
            message.messageType = PWChatMessageTypeText;
            message.textString = dict[@"text"];
            message.headerImgurl = userManager.curUserInfo.avatar;
            message.cellString = PWChatTextCellId;
        }
            break;
        case PWChatMessageTypeImage:{
            message.messageFrom = PWChatMessageFromMe;
            message.messageType = PWChatMessageTypeImage;
            message.headerImgurl = userManager.curUserInfo.avatar;
            message.cellString = PWChatImageCellId;
        }
            break;
    
    
        default:
            break;
    }
    
    PWChatMessagelLayout *layout = [[PWChatMessagelLayout alloc]initWithMessage:message];
    NSError *error;
    NSProgress *pre = [[NSProgress alloc]init];
    messageBlock(layout,error,pre);
}
+(PWChatMessagelLayout *)receiveMessage:(NSDictionary *)dic{
    return [PWChatDatas getMessageWithDic:dic];
}
//消息内容生成消息模型
+(PWChatMessagelLayout *)getMessageWithDic:(NSDictionary *)dic{
    PWChatDataModel *model = [[PWChatDataModel alloc]initWithDictionary:dic];
    
    PWChatMessage *message = [PWChatMessage new];
    
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
    
    PWChatMessagelLayout *layout = [[PWChatMessagelLayout alloc]initWithMessage:message];
    return layout;
    
}


@end
