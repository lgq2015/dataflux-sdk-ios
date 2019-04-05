//
//  ZTOpenUrl.h
//  Created by zhangtao on 2018/9/17.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTOpenUrl : NSObject

//判断url是否存在
+(BOOL)isAppOpenURL:(NSURL *)url;
+(BOOL)isAppOpenStr:(NSString *)str;
//跳转到当前url
+(BOOL)newOpenURL:(NSURL *)url;
+(BOOL)newOpenStr:(NSString *)str;

@end
