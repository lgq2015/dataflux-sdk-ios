//
//  NetworkToolboxView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PWToolType) {
    PWToolTypeWhois = 0,         //Whois查询
    PWToolTypeWebsiteRecord = 1, //网站备案查询
    PWToolTypeIP,                //IP查询
    PWToolTypePing,              //Ping检测
    PWToolTypeDNS,               //DNS查询
    PWToolTypeNslookup,          //nslookup查询
    PWToolTypeTraceroute,        //路由追踪
    PWToolTypePortDetection,     //端口检测
    PWToolTypeSSH,               //在线SSH
};
NS_ASSUME_NONNULL_BEGIN

@interface NetworkToolboxView : UIView
@property (nonatomic, copy) void(^itemClick)(PWToolType type);
- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
