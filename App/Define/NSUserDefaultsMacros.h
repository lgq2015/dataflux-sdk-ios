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
#define PWConnect               [NSString stringWithFormat:@"%@/isConnect", getPWUserID]
#define setConnect(bool)        [kUserDefaults setBool:bool forKey:PWConnect]
#define getConnectState         [kUserDefaults boolForKey:PWConnect]

//上次请求issue的时间
#define PWLastTime              [NSString stringWithFormat:@"%@/lastRequestTimet", getPWUserID]
#define setLastTime(str)        [kUserDefaults setObject:str forKey:PWLastTime]
#define getLastTime             [kUserDefaults objectForKey:PWLastTime]

//当前用户id
#define PWUserID @"userid"
#define setPWUserID(str)        [kUserDefaults setObject:str forKey:PWUserID]
#define getPWUserID             [kUserDefaults objectForKey:PWUserID]

//seqAct
#define PWseqAct                [NSString stringWithFormat:@"%@/PWseqAct", getPWUserID]
#define setPWseqAct(str,type)   [kUserDefaults setObject:str forKey:[NSString stringWithFormat:@"%@/%@", getPWUserID,type]]
#define getPWseqAct(type)       [kUserDefaults objectForKey:[NSString stringWithFormat:@"%@/%@", getPWUserID,type]]

#endif /* NSUserDefaultsMacros_h */
