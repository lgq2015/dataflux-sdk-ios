//
//  PWBaseWebVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWBaseWebVC : RootViewController
@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic, strong) NSURL *webUrl;

#pragma mark - 初始化方法
- (instancetype)initWithTitle:(NSString *)title andURLString:(NSString *)urlString;

- (instancetype)initWithTitle:(NSString *)title andURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
