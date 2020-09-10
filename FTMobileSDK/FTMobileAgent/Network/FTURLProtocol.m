//
//  FTURLProtocol.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2020/4/21.
//  Copyright © 2020 hll. All rights reserved.
//

#import "FTURLProtocol.h"
#import "FTSessionConfiguration.h"
#import "FTMonitorManager.h"
#import "FTBaseInfoHander.h"
#import "FTConstants.h"
#import "NSURLRequest+FTMonitor.h"
static NSString *const URLProtocolHandledKey = @"URLProtocolHandledKey";//为了避免死循环

@interface FTURLProtocol ()<NSURLSessionDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue* sessionDelegateQueue;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSURLSessionTaskMetrics *metrics API_AVAILABLE(ios(10.0));
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) BOOL trackUrl;
@end
@implementation FTURLProtocol
static id<FTHTTPProtocolDelegate> sDelegate;

// 开始监听
+ (void)startMonitor {
    FTSessionConfiguration *sessionConfiguration = [FTSessionConfiguration defaultConfiguration];
    [NSURLProtocol registerClass:[FTURLProtocol class]];
    if (![sessionConfiguration isExchanged]) {
        [sessionConfiguration load];
    }
}

// 停止监听
+ (void)stopMonitor {
    FTSessionConfiguration *sessionConfiguration = [FTSessionConfiguration defaultConfiguration];
    [NSURLProtocol unregisterClass:[FTURLProtocol class]];
    if ([sessionConfiguration isExchanged]) {
        [sessionConfiguration unload];
    }
}
+ (id<FTHTTPProtocolDelegate>)delegate
{
    id<FTHTTPProtocolDelegate> result;
    
    @synchronized (self) {
        result = sDelegate;
    }
    return result;
}
+ (void)setDelegate:(id<FTHTTPProtocolDelegate>)newValue{
    @synchronized (self) {
        sDelegate = newValue;
    }
}
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSString * scheme = [[request.URL scheme] lowercaseString];
    
    //看看是否已经处理过了，防止无限循环 根据业务来截取
    if ([NSURLProtocol propertyForKey: URLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    if ([scheme isEqualToString:@"http"] ||
        [scheme isEqualToString:@"https"]) {
        return YES;
    }
    
    return NO;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest * mutableReqeust = [request mutableCopy];
    [[FTMonitorManager sharedInstance] trackUrl:mutableReqeust.URL completionHandler:^(BOOL track, BOOL sampled, FTNetworkTrackType type ,NSString *skyStr) {
        if (track) {
            switch (type) {
                case FTNetworkTrackTypeZipkin:
                    [mutableReqeust setValue:[FTBaseInfoHander ft_getNetworkTraceID] forHTTPHeaderField:FT_NETWORK_ZIPKIN_TRACEID];
                    [mutableReqeust setValue:[FTBaseInfoHander ft_getNetworkSpanID] forHTTPHeaderField:FT_NETWORK_ZIPKIN_SPANID];
                    [mutableReqeust setValue:[NSString stringWithFormat:@"%d",sampled] forHTTPHeaderField:FT_NETWORK_ZIPKIN_SAMPLED];
                    break;
                case FTNetworkTrackTypeJaeger:{
                    NSString *value = [NSString stringWithFormat:@"%@:%@:0:%@",[FTBaseInfoHander ft_getNetworkTraceID],[FTBaseInfoHander ft_getNetworkSpanID],[NSNumber numberWithBool:sampled]];
                    [mutableReqeust setValue:value forHTTPHeaderField:FT_NETWORK_JAEGER_TRACEID];
                }
                    break;
                case FTNetworkTrackTypeSKYWALKING_V2:{
                    if (skyStr) {
                        [mutableReqeust setValue:skyStr forHTTPHeaderField:FT_NETWORK_SKYWALKING_V2];
                    }
                }
                    break;
                case FTNetworkTrackTypeSKYWALKING_V3:{
                    if (skyStr) {
                        [mutableReqeust setValue:skyStr forHTTPHeaderField:FT_NETWORK_SKYWALKING_V3];
                    }
                }
                    break;
            }
        }
    }];
    return [mutableReqeust copy];
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

//开始请求
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    self.trackUrl = [[FTMonitorManager sharedInstance] trackUrl:mutableReqeust.URL];
    if (self.trackUrl) {
        self.startDate = [NSDate date];
    }
    //标示该request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    
    //使用NSURLSession继续把request发送出去
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionDelegateQueue                             = [[NSOperationQueue alloc] init];
    self.sessionDelegateQueue.maxConcurrentOperationCount = 1;
    self.sessionDelegateQueue.name                        = @"com.session.queue";
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:self.sessionDelegateQueue];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableReqeust];
    [task resume];
}

//结束请求
- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if (self.trackUrl) {
        self.data = data;
        self.endDate = [NSDate date];
    }
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
    id<FTHTTPProtocolDelegate> strongeDelegate;
    strongeDelegate = [[self class] delegate];
    if ([strongeDelegate respondsToSelector:@selector(ftHTTPProtocolWithTask:didCompleteWithError:)]) {
        [strongeDelegate ftHTTPProtocolWithTask:task didCompleteWithError:error];
    }
    if (self.trackUrl) {
        NSNumber *duration;
        NSDate *start;
        if (@available(iOS 10.0, *)) {
            duration = [NSNumber numberWithLong:[self.metrics.taskInterval duration]*1000*1000];
            start = [self.metrics.transactionMetrics lastObject].requestStartDate;
        }else{
            duration = [NSNumber numberWithDouble:[self.endDate timeIntervalSinceDate:self.startDate]*1000*1000];
            start = self.startDate;
        }
        if ([strongeDelegate respondsToSelector:@selector(ftHTTPProtocolWithTask:taskDuration:requestStartDate:responseData:didCompleteWithError:)]){
            [strongeDelegate ftHTTPProtocolWithTask:task taskDuration:duration requestStartDate:start responseData:self.data didCompleteWithError:error];
        }
    }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics  API_AVAILABLE(ios(10.0)){
    
    id<FTHTTPProtocolDelegate> strongeDelegate;
    strongeDelegate = [[self class] delegate];
    if ([strongeDelegate respondsToSelector:@selector(ftHTTPProtocolWithTask:didFinishCollectingMetrics:)]) {
        if (@available(iOS 10.0, *)) {
            [strongeDelegate ftHTTPProtocolWithTask:task didFinishCollectingMetrics:metrics];
        }
    }
    if (self.trackUrl) {
        self.metrics = metrics;
    }
    
}

@end