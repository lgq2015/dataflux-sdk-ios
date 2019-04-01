//
//  PWNetworking+RequestManager.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/9.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWNetworking.h"

@interface PWNetworking (RequestManager)
/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return bool
 */
+ (BOOL)haveSameRequestInTasksPool:(PWURLSessionTask *)task;

/**
 *  如果有旧请求则取消旧请求
 *
 *  @param task 新请求
 *
 *  @return 旧请求
 */
+ (PWURLSessionTask *)cancleSameRequestInTasksPool:(PWURLSessionTask *)task;
@end
