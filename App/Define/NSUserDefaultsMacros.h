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

//个人还是团队
#define PWTeamState                 [NSString stringWithFormat:@"/isTeam"]
#define setTeamState(str)        [kUserDefaults setObject:str forKey:PWTeamState]
#define getTeamState             [kUserDefaults objectForKey:PWTeamState]

#define PW_isTeam @"isTeam"
#define PW_isPersonal @"isPersonal"

#define PW_historySearch @"historySearch"
#define setPWhistorySearch(ary)    [kUserDefaults setObject:ary forKey:PW_historySearch]
#define getPWhistorySearch         [kUserDefaults objectForKey:PW_historySearch]

#define PW_IssueTabName            [NSString stringWithFormat:@"%@issueSource", getPWUserID]


#define PW_IsHideGuide  @"ishideguide"
#define setIsHideGuide(bool)       [kUserDefaults setBool:bool forKey:PW_IsHideGuide]
#define getIsHideGuide             [kUserDefaults boolForKey:PW_IsHideGuide]


#define  REMOTE_NOTIFICATION_JSPUSH_EXTRA @"jpush_notification_extra"
#define setRemoteNotificationData(data)       [kUserDefaults setObject:data forKey:REMOTE_NOTIFICATION_JSPUSH_EXTRA]
#define getRemoteNotificationData            [kUserDefaults objectForKey:REMOTE_NOTIFICATION_JSPUSH_EXTRA]

#endif /* NSUserDefaultsMacros_h */
