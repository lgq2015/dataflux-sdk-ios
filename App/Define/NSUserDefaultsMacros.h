//
//  NSUserDefaultsMacros.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/14.
//  Copyright © 2019 hll. All rights reserved.
//

#ifndef NSUserDefaultsMacros_h
#define NSUserDefaultsMacros_h

#define kUserDefaults       [NSUserDefaults standardUserDefaults]
//请求头 Token
#define XAuthToken @"X-Auth-Token"
#define setXAuthToken(str)      [kUserDefaults setObject:str forKey:XAuthToken]
#define getXAuthToken           [kUserDefaults objectForKey:XAuthToken]

//首页是否展示未连接状态
#define PWConnect @"isConnect"
#define setConnect(bool)        [kUserDefaults setBool:bool forKey:PWConnect]
#define getConnectState         [kUserDefaults objectForKey:PWConnect]

//上次请求issue的时间
#define PWLastTime @"lastRequestTime"
#define setLastTime(str)        [kUserDefaults setObject:str forKey:PWLastTime]
#define getLastTime             [kUserDefaults objectForKey:PWLastTime]

#endif /* NSUserDefaultsMacros_h */
