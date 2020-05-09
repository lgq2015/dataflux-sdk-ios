//
//  PWBaseWebVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWBaseWebVC : RootViewController
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL isHideProgress;
@property (nonatomic, strong) NSURL *webUrl;

#pragma mark - 初始化方法
- (instancetype)initWithTitle:(NSString *)title andURLString:(NSString *)urlString;

- (instancetype)initWithTitle:(NSString *)title andURL:(NSURL *)url;
/**
 导航title为webview title
 */
- (instancetype)initWithURL:(NSURL *)url;

// 交互
- (void)eventOfOpenWithExtra:(NSDictionary *)extra;
- (void)eventTeamCreate:(NSDictionary *)extra;
- (void)eventSwitchToken:(NSDictionary *)extra;
- (void)eventBookSuccess:(NSDictionary *)extra;
@end

NS_ASSUME_NONNULL_END