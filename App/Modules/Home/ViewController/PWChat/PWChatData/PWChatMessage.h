//
//  PWChatMessage.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
//cell的一些设置
#define PWChatTextCellId        @"PWChatTextCellId"
#define PWChatImageCellId       @"PWChatImageCellId"
#define PWChatVoiceCellId       @"PWChatFileCellId"


#define PWChatCellTop           8           //顶部距离cell
#define PWChatCellBottom        15           //底部距离cell
#define PWChatIconWH            40           //原型头像尺寸
#define PWChatIconLeft          16           //头像与左边距离
#define PWChatIconRight         16           //头像与右边距离
#define PWChatDetailLeft        10           //详情与左边距离
#define PWChatDetailRight       10           //详情与右边距离
#define PWChatTextTop           12           //文本距离详情顶部
#define PWChatTextBottom        12           //文本距离详情底部
#define PWChatTextLRS           5           //文本左右短距离
#define PWChatTextLRB           10           //文本左右长距离




#define PWChatAirTop            35           //气泡距离详情顶部
#define PWChatAirLRS            10           //气泡左右短距离
#define PWChatAirBottom         10           //气泡距离详情底部
#define PWChatAirLRB            10           //气泡左右长距离
#define PWChatTextFont          17           //内容字号

#define PWChatTextLineSpacing   5            //文本行高
#define PWChatTextRowSpacing    0            //文本间距

#define PWChatFileWidth                 ZOOM_SCALE(248)
#define PWChatFileHeight                ZOOM_SCALE(84)

//文本颜色
#define PWChatTextColor        PWTextBlackColor

//右侧头像的X坐标
#define PWChatIcon_RX            kWidth-PWChatIconRight-PWChatIconWH

//文本自适应限制宽度
#define PWChatTextInitWidth      kWidth-128-PWChatTextLRS-PWChatTextLRB

//图片最大尺寸(正方形)
#define PWChatImageMaxSize       ZOOM_SCALE(140)


/**
 判断消息的发送者
 - SSChatMessageFromMe:     我发的
 - SSChatMessageFromOther:  对方发的(单聊群里同等对待)
 - SSChatMessageFromSystem: 系统消息(提示撤销删除、商品信息等)
 */
typedef NS_ENUM(NSInteger, PWChatMessageFrom) {
    PWChatMessageFromMe    = 1,
    PWChatMessageFromOther = 2,
    PWChatMessageFromSystem
};


/**
 判断发送消息所属的类型
 - PWChatMessageTypeText:        发送文本消息
 - PWChatMessageTypeImage:       发送图片消息
 - PWChatMessageTypeFile:        发送文件
 */
typedef NS_ENUM(NSInteger, PWChatMessageType) {
    PWChatMessageTypeText =1,
    PWChatMessageTypeImage,
    PWChatMessageTypeFile,
    PWChatMessageTypeSysterm,
};
@interface PWChatMessage : NSObject
//消息发送方  消息类型  消息对应cell类型
@property (nonatomic, assign) PWChatMessageFrom messageFrom;
@property (nonatomic, assign) PWChatMessageType messageType;
@property (nonatomic, strong) NSString     *cellString;

//会话id
@property (nonatomic, strong) NSString    *sessionId;

//消息是否发送失败
@property (nonatomic, assign) BOOL sendError;

//头像
@property (nonatomic, strong) NSString    *headerImgurl;
@property (nonatomic, strong) NSString    *nameStr;

//文本消息内容 颜色  消息转换可变字符串
@property (nonatomic, strong) NSString    *textString;
@property (nonatomic, strong) UIColor     *textColor;
@property (nonatomic, strong) NSMutableAttributedString  *attTextString;

//图片消息链接或者本地图片 图片展示格式
@property (nonatomic, strong) NSString    *imageString;
@property (nonatomic, strong) UIImage     *image;
@property (nonatomic, assign) UIViewContentMode contentMode;

//文件 文件类型  文件名字  文件地址
@property (nonatomic, strong) NSString    *fileName;
@property (nonatomic, strong) NSString    *fileAddress;
@property (nonatomic, strong) NSString    *filePath;

// 系统消息
@property (nonatomic, strong) NSString    *systermStr;
//拓展消息
@property(nonatomic,strong)NSDictionary *dict;
@end


