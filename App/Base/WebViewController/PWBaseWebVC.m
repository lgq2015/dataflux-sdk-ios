//
//  PWBaseWebVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWBaseWebVC.h"
#import <WebKit/WebKit.h>

@interface PWBaseWebVC ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WebViewJavascriptBridge *jsBridge;

@end

@implementation PWBaseWebVC
- (instancetype)initWithTitle:(NSString *)title andURLString:(nonnull NSString *)urlString{
      NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     return [self initWithTitle:title andURL:[NSURL URLWithString:encodedString]];
}

- (instancetype)initWithTitle:(NSString *)title andURL:(NSURL *)url{
    if (self = [super init]) {
        self.title = title;
        self.webUrl = url;
    }
    return self;;
}
-(void)backBtnClicked{
    if ([self.webview canGoBack]) {
        //如果有则返回
        [self.webview goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(WKWebView *)webview{
    if (!_webview) {
        
    }
    return _webview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // KVO，监听webView属性值得变化(estimatedProgress,title为特定的key)
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = userAgent;
    if ([userAgent rangeOfString:@"cloudcare"].location == NSNotFound) {
        newUserAgent = [userAgent stringByAppendingString:@"cloudcare"];
    }
//    if ([userAgent rangeOfString:@"Prof.Wang_iOS"].location == NSNotFound){
//        newUserAgent = [userAgent stringByAppendingString:@"Prof.Wang_iOS"];
//    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    config.preferences.javaScriptEnabled = YES;
    config.selectionGranularity = YES;

    self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];

    self.webview.allowsBackForwardNavigationGestures = YES;
    _jsBridge = [WebViewJavascriptBridge bridgeForWebView:self.webview];

    [self.webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        DLog(@"%@", result);
    }];
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    // UIProgressView初始化
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, self.webview.frame.size.width, 2);
    self.progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
    self.progressView.progressTintColor = PWBlueColor;
    // 设置初始的进度，防止用户进来就懵逼了（微信大概也是一开始设置的10%的默认值）
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
    [self.view addSubview:self.webview];
    [self.progressView setProgress:0.1 animated:YES];
    [self.webview addSubview:self.progressView];
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
    self.webview.scrollView.bounces = NO;
    // Do any additional setup after loading the view.
    
    [_jsBridge registerHandler:@"addEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"dataFrom JS : %@",data[@"data"]);
        
//responseCallback(@"扫描结果 : www.baidu.com");
    }];
    [_jsBridge registerHandler:@"sendEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"dataFrom JS : %@",data[@"data"]);
        
        responseCallback(@"扫描结果 : www.baidu.com");
    }];
}


- (void)dealloc {
    
    // 最后一步：移除监听
    [_webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webview removeObserver:self forKeyPath:@"title"];
}
#pragma mark - KVO监听
// 第三部：完成监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isEqual:self.webview] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"打印测试进度值：%f", newprogress);
        
        if (newprogress == 1) { // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
            
        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    } else if ([object isEqual:self.webview] && [keyPath isEqualToString:@"title"]) { // 标题
        
        self.title = self.webview.title;
    } else { // 其他
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return nil;
//}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
       
        [webView loadRequest:navigationAction.request];
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
        return nil;
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
