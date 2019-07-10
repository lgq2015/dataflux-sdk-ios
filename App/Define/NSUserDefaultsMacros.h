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

////首页是否展示未连接状态
#define PWConnect               [NSString stringWithFormat:@"%@/isConnect", getPWUserID]
#define setConnect(bool)        [kUserDefaults setBool:bool forKey:PWConnect]
#define getConnectState         [kUserDefaults boolForKey:PWConnect]

//上次请求issue的时间
#define PWLastTime              [NSString stringWithFormat:@"%@/lastRequestTimet", getPWUserID]
#define setLastTime(str)        [kUserDefaults setObject:str forKey:PWLastTime]
#define getLastTime             [kUserDefaults objectForKey:PWLastTime]

#define PWLastHeartBeat                  @"heartBeatTime"
#define setHeartBeatLastTime(str)        [kUserDefaults setObject:str forKey:PWLastHeartBeat]
#define getHeartBeatLastTime             [kUserDefaults objectForKey:PWLastHeartBeat]


//当前用户id
#define PWUserID @"userid"
#define setPWUserID(str)        [kUserDefaults setObject:str forKey:PWUserID]
#define getPWUserID             [kUserDefaults objectForKey:PWUserID]
#define getPWUserIDWithDBCompat            [getPWUserID stringByReplacingOccurrencesOfString:@"-" withString:@""]
//用户默认团队id
#define PWDefaultTeamID @"teamId"
#define setPWDefaultTeamID(str)        [kUserDefaults setObject:str forKey:PWDefaultTeamID]
#define getPWDefaultTeamID             [kUserDefaults objectForKey:PWDefaultTeamID]
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

//首页是否展示未连接状态
#define PW_IsHideGuide  @"ishideguide"
#define setIsHideGuide(str)       [kUserDefaults setObject:str forKey:PW_IsHideGuide]
#define getIsHideGuide             [kUserDefaults objectForKey:PW_IsHideGuide]

#define PW_DevMode   @"isDevMode"
#define setIsDevMode(str)   [kUserDefaults setBool:str forKey:PW_DevMode]
#define getIsDevMode   [kUserDefaults boolForKey:PW_DevMode]

#define PW_IsNotConnect  @"PW_IsNotConnect"



#define  REMOTE_NOTIFICATION_JSPUSH_EXTRA @"jpush_notification_extra"
#define setRemoteNotificationData(data)       [kUserDefaults setObject:data forKey:REMOTE_NOTIFICATION_JSPUSH_EXTRA]
#define getRemoteNotificationData            [kUserDefaults objectForKey:REMOTE_NOTIFICATION_JSPUSH_EXTRA]

#define NewVersionUpdateAlert  @"NewVersionUpdateAlert"
#define setNewVersionDict(dict)        [kUserDefaults setObject:dict forKey:NewVersionUpdateAlert]
#define getNewVersionDict              [kUserDefaults objectForKey:NewVersionUpdateAlert]

// 通知设置
#define UserNotificationSettings  @"UserNotificationSettings"
#define setUserNotificationSettings(str)        [kUserDefaults setObject:str forKey:UserNotificationSettings]
#define getUserNotificationSettings             [kUserDefaults objectForKey:UserNotificationSettings]
//
#define PWRegister       @"PWRegister"
#define PWUnRegister     @"PWUnRegister"

#endif /* NSUserDefaultsMacros_h */
