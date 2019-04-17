//
//  ZYSocialManager.m
//  微信分享
//
//  Created by tao on 2019/4/7.
//  Copyright © 2019 shitu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZYSocialManager.h"
#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <DTShareKit/DTOpenKit.h>
@interface ZYSocialManager()
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *descr;
@property (nonatomic, strong)UIImage *thumImage;

@end
@implementation ZYSocialManager
- (instancetype)initWithTitle:(NSString *)title descr:(NSString *)descr thumImage:(UIImage *)thumImage{
    if (self = [super init]){
        _title = title;
        if (descr == nil || descr.length == 0) {
            _descr = @"\u3000";
        }else{
            _descr = descr;
        }
        _thumImage = thumImage;
    }
    return self;
}
- (void)shareToPlatform:(SharePlatformType)type{
    if (type == WechatSession_PlatformType || type ==  WechatTimeLine_PlatformType){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _title;//标题
        message.description = _descr;//描述
        [message setThumbImage:_thumImage];//设置预览图 >32K 分享图片有问题
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = _webpageUrl;//链接
        message.mediaObject = webObj;
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.message = message;  //WXSceneTimeline WXSceneSession
        sendReq.scene = (type == WechatSession_PlatformType ? WXSceneSession : WXSceneTimeline);
        [WXApi sendReq:sendReq];//发送对象实例
    }else if (type == QQ_PlatformType || type == Qzone_PlatformType){
        QQApiNewsObject *msgContentObj =
        [QQApiNewsObject objectWithURL:[NSURL URLWithString:_webpageUrl]
                                 title:_title
                           description:_descr
                      previewImageData:UIImageJPEGRepresentation(_thumImage,1.0f)];        
        SendMessageToQQReq *req = [SendMessageToQQReq
                                   reqWithContent:msgContentObj];
        if (type == QQ_PlatformType){
            [QQApiInterface sendReq:req];
        }else{
            [QQApiInterface SendReqToQZone:req];
        }
    }else if (type == Dingding_PlatformType){
        DTSendMessageToDingTalkReq *sendMessageReq = [[DTSendMessageToDingTalkReq alloc] init];
        DTMediaMessage *mediaMessage = [[DTMediaMessage alloc] init];
        DTMediaWebObject *webObject = [[DTMediaWebObject alloc] init];
        webObject.pageURL = _webpageUrl;
        mediaMessage.title = _title;
        mediaMessage.messageDescription = _descr;
        mediaMessage.thumbData = UIImageJPEGRepresentation(_thumImage,0.5f);
        mediaMessage.mediaObject=webObject;
        sendMessageReq.message = mediaMessage;
        [DTOpenAPI sendReq:sendMessageReq];
    }else if (type == System_PlatformType){
        NSURL *shareUrl = [NSURL URLWithString:_webpageUrl];
        NSArray *activityItems = @[_title,
                                   _thumImage,
                                   shareUrl]; // 必须要提供url 才会显示分享标签否则只显示图片
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:activityItems
                                                applicationActivities:nil];
        [self.showVC presentViewController:activityVC animated:YES completion:nil];
    }
    
}
@end
