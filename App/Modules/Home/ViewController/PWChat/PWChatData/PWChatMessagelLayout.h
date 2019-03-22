//
//  PWChatMessagelLayout.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWChatMessagelLayout : NSObject
/**
 根据模型生成布局
 
 @param message 传入消息模型
 @return 返回布局对象
 */
-(instancetype)initWithMessage:(PWChatMessage *)message;

//消息模型
@property (nonatomic, strong) PWChatMessage  *message;

//消息布局到CELL的总高度
@property (nonatomic, assign) CGFloat      cellHeight;

//时间控件的frame
@property (nonatomic, assign) CGRect       nameLabRect;
//头像控件的frame
@property (nonatomic, assign) CGRect       headerImgRect;
//背景按钮的frame
@property (nonatomic, assign) CGRect       backImgButtonRect;
//背景按钮图片的拉伸膜是和保护区域
@property (nonatomic, assign) UIEdgeInsets imageInsets;

//文本间隙的处理
@property (nonatomic, assign) UIEdgeInsets textInsets;
//文本控件的frame
@property (nonatomic, assign) CGRect       textLabRect;

//文件控件的frame
@property (nonatomic, assign) CGRect       fileLabRect;


@end

NS_ASSUME_NONNULL_END
