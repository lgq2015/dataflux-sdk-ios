//
//  PWNetworking.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/9.
//  Copyright © 2018年 hll. All rights reserved.
//
#import "PWNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PWNetworking+RequestManager.h"
#import "PWCacheManager.h"

#define YQ_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define YQ_ERROR [NSError errorWithDomain:@"com.hyq.YQNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:YQ_ERROR_IMFORMATION}]

static NSMutableArray   *requestTasksPool;

static NSDictionary     *headers;

static PWNetworkStatus  networkStatus;

static NSTimeInterval   requestTimeout = 60.f;

@implementation PWNetworking
#pragma mark - manager
+ (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //默认解析模式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = requestTimeout;
    headers = @{@"Content-Type":@"application/json",@"Accept":@"application/json"};
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    DLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    
    [self checkNetworkStatus];
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[YQCacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[PWCacheManager shareManager] clearLRUCache];
    
    return manager;
}

#pragma mark - 检查网络
+ (void)checkNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = PWNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = PWNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = PWNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = PWNetworkStatusReachableViaWiFi;
                break;
            default:
                networkStatus = PWNetworkStatusUnknown;
                break;
        }
        
    }];
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [NSMutableArray array];
    });
    
    return requestTasksPool;
}

#pragma mark ========== get/post hasToken ==========
+ (PWURLSessionTask *)requsetHasTokenWithUrl:(NSString *)url
                     withRequestType:(NetworkRequestType)type
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary*)params
                   progressBlock:(PWProgress)progressBlock
                    successBlock:(PWResponseSuccessBlock)successBlock
                       failBlock:(PWResponseFailBlock)failBlock {
    AFHTTPSessionManager *manager = [self manager];
    [manager.requestSerializer setValue:getXAuthToken forHTTPHeaderField:@"X-Core-Stone-Auth-Token"];
    return [self requsetWithUrl:url manager:manager withRequestType:type refreshRequest:refresh cache:cache params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
}
#pragma mark ========== get/post noToken==========
+ (PWURLSessionTask *)requsetWithUrl:(NSString *)url
                     withRequestType:(NetworkRequestType)type
                      refreshRequest:(BOOL)refresh
                               cache:(BOOL)cache
                              params:(NSDictionary*)params
                       progressBlock:(PWProgress)progressBlock
                        successBlock:(PWResponseSuccessBlock)successBlock
                           failBlock:(PWResponseFailBlock)failBlock{
    AFHTTPSessionManager *manger = [self manager];
    return [self requsetWithUrl:url manager:manger withRequestType:type refreshRequest:refresh cache:cache params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
}
+ (PWURLSessionTask *)requsetWithUrl:(NSString *)url
                              manager:(AFHTTPSessionManager *)manager
                     withRequestType:(NetworkRequestType)type
                      refreshRequest:(BOOL)refresh
                               cache:(BOOL)cache
                              params:(NSDictionary*)params
                       progressBlock:(PWProgress)progressBlock
                        successBlock:(PWResponseSuccessBlock)successBlock
                           failBlock:(PWResponseFailBlock)failBlock {
    __block PWURLSessionTask *session = nil;
    NSString *typestr = type == NetworkPostType? @"Post":@"Get";
    if (networkStatus == PWNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    id responseObj = [[PWCacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj);
    }
    switch (type) {
        case NetworkGetType:
        {   
            session = [manager GET:url
                        parameters:params
                          progress:^(NSProgress * _Nonnull downloadProgress) {
                              if (progressBlock) progressBlock(downloadProgress.completedUnitCount,
                                                               downloadProgress.totalUnitCount);
                              
                          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              if (successBlock) successBlock(responseObject);
                              DLog(@"method = %@ baseUrl = %@ param = %@ response = %@ header = %@  ",typestr,url,params,responseObject,manager.requestSerializer.HTTPRequestHeaders);

                              if (cache) [[PWCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
                              
                              [[self allTasks] removeObject:session];
                              
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              DLog(@"method = %@ baseUrl = %@ param = %@ token =%@ error = %@",typestr,url,params,manager.requestSerializer.HTTPRequestHeaders,error);
                              if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                                  // server error
                                  id response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                                  if (successBlock) successBlock(response);
                                  if ([response[ERROR_CODE] isEqualToString:@"home.auth.unauthorized"]) {
                                      [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                          KPostNotification(KNotificationOnKick, nil);
                                      });
                                  }
                                  // response中包含服务端返回的内容
                              } else if ([error.domain isEqualToString:NSCocoaErrorDomain]) {
                                  // server throw exception
                                  if (failBlock) failBlock(error);

                              } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
                                  // network error
                                  if (failBlock) failBlock(error);
                              }

                              
                          }];
            
            if ([self haveSameRequestInTasksPool:session] && !refresh) {
                //取消新请求
                [session cancel];
                return session;
            }else {
                //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
                PWURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
                if (oldTask) [[self allTasks] removeObject:oldTask];
                if (session) [[self allTasks] addObject:session];
                [session resume];
                return session;
            }
        }
            break;
         case NetworkPostType:
          {  // body传输
              session = [manager POST:url
                        parameters:params
                            progress:^(NSProgress * _Nonnull uploadProgress) {
                              if (progressBlock) progressBlock(uploadProgress.completedUnitCount,
                                                        uploadProgress.totalUnitCount);
                       
                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              if (successBlock) successBlock(responseObject);
                            DLog(@"method = %@ baseUrl = %@ param = %@ token = %@ response = %@",typestr,url,params,manager.requestSerializer.HTTPRequestHeaders,responseObject);
                              if (cache) [[PWCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
                       
                                if ([[self allTasks] containsObject:session]) {
                                        [[self allTasks] removeObject:session];
                                 }
                       
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                DLog(@"method = %@ baseUrl = %@ param = %@ token = %@ error = %@",typestr,url,params,manager.requestSerializer.HTTPRequestHeaders,error);
                                if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                                    // server error
                                    id response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                                  DLog(@"response = %@",response)
                                    if ([response[ERROR_CODE] isEqualToString:@"home.auth.unauthorized"]) {
                                        KPostNotification(KNotificationOnKick, nil);
                                    }
                                    if (successBlock) successBlock(response);
                                    // response中包含服务端返回的内容
                                } else if ([error.domain isEqualToString:NSCocoaErrorDomain]) {
                                    // server throw exception
                                    if (failBlock) failBlock(error);

                                } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
                                    // network error
                                    if (failBlock) failBlock(error);
                                }else{
                                     if (failBlock) failBlock(error);
                                }
                                    [[self allTasks] removeObject:session];
                    
                                }];
    
                           if ([self haveSameRequestInTasksPool:session] && !refresh) {
                               [session cancel];
                               return session;
                           }else {
                               PWURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
                               if (oldTask) [[self allTasks] removeObject:oldTask];
                               if (session) [[self allTasks] addObject:session];
                               [session resume];
                               return session;
                           }
        }
            break;
        
    }
    
    
}

#pragma mark - 文件上传
+ (PWURLSessionTask *)uploadFileWithUrl:(NSString *)url
                                 params:(NSDictionary *)params
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(PWUploadProgressBlock)progressBlock
                           successBlock:(PWResponseSuccessBlock)successBlock
                              failBlock:(PWResponseFailBlock)failBlock{
    __block PWURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    [manager.requestSerializer setValue:getXAuthToken forHTTPHeaderField:@"X-Core-Stone-Auth-Token"];
    DLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    if (networkStatus == PWNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    session = [manager POST:url
                 parameters:nil
  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      NSString *fileName = nil;
      
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = @"yyyyMMddHHmmss";
      
      NSString *day = [formatter stringFromDate:[NSDate date]];
      
      fileName = [NSString stringWithFormat:@"%@.%@",day,type];
      
      [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
      
  } progress:^(NSProgress * _Nonnull uploadProgress) {
      if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
      
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if (successBlock) successBlock(responseObject);
      [[self allTasks] removeObject:session];
      
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (failBlock) failBlock(error);
      [[self allTasks] removeObject:session];
      
  }];
    
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}
+ (PWURLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(PWUploadProgressBlock)progressBlock
                           successBlock:(PWResponseSuccessBlock)successBlock
                              failBlock:(PWResponseFailBlock)failBlock {
    return [self uploadFileWithUrl:url params:nil fileData:data type:type name:name mimeType:type progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
}

#pragma mark - 多文件上传
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                     progressBlock:(PWUploadProgressBlock)progressBlock
                      successBlock:(PWMultUploadSuccessBlock)successBlock
                         failBlock:(PWMultUploadFailBlock)failBlock {
    
    if (networkStatus == PWNetworkStatusNotReachable) {
        if (failBlock) failBlock(@[YQ_ERROR]);
        return nil;
    }
    
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    NSInteger count = datas.count;
    for (int i = 0; i < count; i++) {
        __block PWURLSessionTask *session = nil;
        
        dispatch_group_enter(uploadGroup);
        
        session = [self uploadFileWithUrl:url
                                 fileData:datas[i]
                                     type:type name:name
                                 mimeType:mimeTypes
                            progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                                if (progressBlock) progressBlock(bytesWritten,
                                                                 totalBytes);
                                
                            } successBlock:^(id response) {
                                [responses addObject:response];
                                
                                dispatch_group_leave(uploadGroup);

                                [sessions removeObject:session];
                                
                            } failBlock:^(NSError *error) {
                                NSError *Error = [NSError errorWithDomain:url code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i]}];
                                
                                [failResponse addObject:Error];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                            }];
        
        [session resume];
        if (session) [sessions addObject:session];
    }
    [[self allTasks] addObjectsFromArray:sessions];
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (responses.count > 0) {
            if (successBlock) {
                successBlock([responses copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
    });
    
    return [sessions copy];
}

#pragma mark - 下载
+ (PWURLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(PWDownloadProgress)progressBlock
                         successBlock:(PWDownloadSuccessBlock)successBlock
                            failBlock:(PWDownloadFailBlock)failBlock {
    NSString *type = nil;
    NSArray *subStringArr = nil;
    __block PWURLSessionTask *session = nil;
    
    NSURL *fileUrl = [[PWCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
    
    if (fileUrl) {
        if (successBlock) successBlock(fileUrl);
        return nil;
    }
    
    if (url) {
        subStringArr = [url componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }
    
    AFHTTPSessionManager *manager = [self manager];
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"X-Auth-Token"];
    session = [manager GET:url
                parameters:nil
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (successBlock) {
                          NSData *dataObj = (NSData *)responseObject;
                          
                          [[PWCacheManager shareManager] storeDownloadData:dataObj requestUrl:url];
                          
                          NSURL *downFileUrl = [[PWCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
                          
                          successBlock(downFileUrl);
                      }
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failBlock) {
                          failBlock (error);
                      }
                  }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - other method
+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(PWURLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PWURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(PWURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PWURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}

+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}

@end

@implementation PWNetworking (cache)
+ (NSUInteger)totalCacheSize {
    return [[PWCacheManager shareManager] totalCacheSize];
}

+ (NSUInteger)totalDownloadDataSize {
    return [[PWCacheManager shareManager] totalDownloadDataSize];
}

+ (void)clearDownloadData {
    [[PWCacheManager shareManager] clearDownloadData];
}

+ (NSString *)getDownDirectoryPath {
    return [[PWCacheManager shareManager] getDownDirectoryPath];
}

+ (NSString *)getCacheDiretoryPath {
    return [[PWCacheManager shareManager] getCacheDiretoryPath];
}

+ (void)clearTotalCache {
    [[PWCacheManager shareManager] clearTotalCache];
}


@end
