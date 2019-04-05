//
//  ZTShareView.h
//  123
//
//  Created by tao on 2019/4/5.
//  Copyright © 2019 shitu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger{
    //微信聊天
    WechatSession_PlatformType,
    //微信朋友圈
    WechatTimeLine_PlatformType,
    //QQ聊天页面
    QQ_PlatformType,
    //qq空间
    Qzone_PlatformType,
    //钉钉
    Dingding_PlatformType,
    //系统
    System_PlatformType,
}SharePlatformType;
typedef void(^ShareBlock)(SharePlatformType sharePlatformType);
NS_ASSUME_NONNULL_BEGIN

@interface ZYSocialUIManager : UIView
- (void)showWithPlatformSelectionBlock:(ShareBlock)shareBlock;
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
