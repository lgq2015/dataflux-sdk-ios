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
@property (nonatomic, copy) NSString *baseTitle;
@end

@implementation PWBaseWebVC
-(void)viewWillAppear:(BOOL)animated{
    
}
#pragma mark ========== init ==========
- (instancetype)initWithTitle:(NSString *)title andURLString:(nonnull NSString *)urlString{
      NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     return [self initWithTitle:title andURL:[NSURL URLWithString:encodedString]];
}

- (instancetype)initWithTitle:(NSString *)title andURL:(NSURL *)url{
    if (self = [super init]) {
        self.title = title;
        self.baseTitle = title;
        self.webUrl = url;
    }
    return self;
}
- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        self.baseTitle = @"";
        self.webUrl = url;
    }
    return self;
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
        if (![getXAuthToken isKindOfClass:NSNull.class] &&getXAuthToken != nil) {
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
        }
    
    
        config.selectionGranularity = WKSelectionGranularityDynamic;
        config.allowsInlineMediaPlayback = YES;
        config.mediaPlaybackRequiresUserAction = false;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
       
    }
    return _webView;
}
// UIProgressView初始化
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.webView.frame.size.width, 2);
        _progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
        _progressView.progressTintColor = PWBlueColor;
    }
    return _progressView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // KVO，监听webView属性值得变化(estimatedProgress,title为特定的key)
    UIWebView *webView = [[UIWebView alloc]init];
   

    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = userAgent;
    if ([userAgent rangeOfString:@"cloudcare"].location == NSNotFound) {
        newUserAgent = [userAgent stringByAppendingString:@"cloudcare;Prof.Wang_iOS"];
    }

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        DLog(@"%@", result);
    }];
    if (self.isHidenNaviBar) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.webView.frame = self.view.bounds;
    }else{
        self.webView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    }

   
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:self.webUrl];
    if (![getXAuthToken isKindOfClass:NSNull.class] &&getXAuthToken != nil) {
       [request setValue:[NSString stringWithFormat:@"%@=%@",@"loginTokenName", getXAuthToken] forHTTPHeaderField:@"Cookie"];
    }
    
    [self dealWithProgressView];

    //对文件格式做兼容处理
    [self dealFileFormat:request];
    [self.view addSubview:self.webView];

    self.jsBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.jsBridge registerHandler:@"sendEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dict = [data jsonValueDecoded];
        DLog(@"%@",dict);
        [self dealWithDict:dict];

    }];
    [self.jsBridge callHandler:@"JS Echo" data:nil responseCallback:^(id responseData) {
        NSLog(@"ObjC received response: %@", responseData);
    }];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
- (void)dealWithProgressView{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    if (self.isHideProgress) {
        self.progressView.hidden = YES;
    }else{
        [self.progressView setProgress:0.1 animated:YES];
        [self.webView addSubview:self.progressView];
    }
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
}
- (void)dealWithDict:(NSDictionary *)dict{
    NSString *name = dict[@"name"];
    NSDictionary *extra = dict[@"extra"];
    if ([name isEqualToString:@"teamView"]) {
        [self eventOfTeamViewWithExtra:extra];
    }else if([name isEqualToString:@"open"]){
        [self eventOfOpenWithExtra:extra];
    }else if([name isEqualToString:@"bookSuccess"]){
        [self eventBookSuccess:extra];
    }else if([name isEqualToString:@"switchToken"]){
        [self eventSwitchToken:extra];
    }else if([name isEqualToString:@"teamCreate"]){
        [self eventTeamCreate:extra];
    }else if([name isEqualToString:@"call"]){
        [self eventCall:extra];
    }else if([name isEqualToString:@"feedback"]){
        [self eventFeedback];
    }
  
}
- (void)eventOfTeamViewWithExtra:(NSDictionary *)extra{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)eventOfOpenWithExtra:(NSDictionary *)extra{
   
    
}
- (void)eventFeedback{
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
    KPostNotification(KNotificationFeedBack,nil);
}
- (void)eventSwitchToken:(NSDictionary *)extra{
    
}
- (void)eventBookSuccess:(NSDictionary *)extra{
    
}
- (void)eventTeamCreate:(NSDictionary *)extra{
    
    
}
- (void)eventCall:(NSDictionary *)extra{
    NSString *phone = [extra stringValueForKey:@"phone" default:@""];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}
-(void)backBtnClicked{
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark ========== KVO监听/进度条/导航title ==========
// 第三部：完成监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        
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
    } else if ([object isEqual:self.webView] && [keyPath isEqualToString:@"title"]) { // 标题
        if ([self.webView canGoBack] ||[self.baseTitle isEqualToString:@""]){
            self.title = self.webView.title;
        }else{
            self.title = self.baseTitle;
        }
        //做个兼容处理
        if (self.isShowCustomNaviBar){
            self.topNavBar.titleLabel.text = self.title;
        }
    } else { // 其他
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ========== WKNavigationDelegate ==========
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        DLog(@"%@",navigationAction.request);
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
- (void)dealloc {
    // 最后一步：移除监听
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}
#pragma mark =========对乱码文件的兼容处理======
- (void)dealFileFormat:(NSMutableURLRequest *)request{
    NSString *lastName =[[self.webUrl.absoluteString lastPathComponent] lowercaseString];
    NSString *path =self.webUrl.absoluteString;
    if ([lastName containsString:@".txt"]){
        NSStringEncoding * usedEncoding = nil;
        NSURL *url = self.webUrl;
        NSString *body = [NSString stringWithContentsOfURL:url usedEncoding:usedEncoding error:nil];
        if (!body)
        {
            //如果之前不能解码，现在使用GBK解码
            body = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
        }
        if (!body) {
            //再使用GB18030解码
            body = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
        }
        if (body) {
            NSString* responseStr = [NSString stringWithFormat:
                                     @"<HTML>"
                                     "<head>"
                                     "<title>Text View</title>"
                                     "</head>"
                                     "<BODY>"
                                     "<pre>"
                                     "%@"
                                     "</pre>"
                                     "</BODY>"
                                     "</HTML>",
                                     body];
            [self.webView loadHTMLString:responseStr baseURL:nil];
        }
        else {
            [self.webView loadRequest:request];
        }
    }
    else{
        [self.webView loadRequest:request];
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    //    UIImageView *shadowImg = [self seekLineImageViewOn:self.navigationController.navigationBar];
//    //    self.navigationController.navigationBar.hidden = offsetY <= 0 ? YES : NO;
//    NSLog(@"offsetY-----%f",offsetY);
//}

@end
