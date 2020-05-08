//
//  WEBViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "WEBViewController.h"

@interface WEBViewController ()
@property (nonatomic , strong) WKWebView *webView;
@property WebViewJavascriptBridge* bridge;

@end

@implementation WEBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dotext];
}
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 偏好设置
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // 设置cookie
        config.processPool = [[WKProcessPool alloc] init];
        NSDictionary *dic = @{@"loginTokenName":getXAuthToken};
        // 将所有cookie以document.cookie = 'key=value';形式进行拼接
        NSMutableString *cookie = @"".mutableCopy;
        
        if (dic) {
            for (NSString *key in dic.allKeys) {
                [cookie appendFormat:@"document.cookie = '%@=%@';\n",key,dic[key]];
            }
        }
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        
        config.userContentController = userContentController;
        config.selectionGranularity = WKSelectionGranularityDynamic;
        config.allowsInlineMediaPlayback = YES;
        if (@available(iOS 10.0, *)) {
            config.mediaTypesRequiringUserActionForPlayback = false;
        }
        CGRect frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
    }
    return _webView;
}
- (void)dotext{
    [self.view addSubview:self.webView];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath =[resourcePath stringByAppendingPathComponent:@"demo.html"];
    
    NSMutableString *htmlstring=[[NSMutableString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl=[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    [self.webView loadHTMLString:htmlstring baseURL: baseUrl];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView showJSconsole:NO enableLogging:NO];
    [self.bridge registerHandler:@"shareClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        DLog(@"ObjC Echo called with: %@", data);
        responseCallback(data);
    }];
    [self.bridge callHandler:@"shareClick" data:nil responseCallback:^(id responseData) {
        DLog(@"ObjC received response: %@", responseData);
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
