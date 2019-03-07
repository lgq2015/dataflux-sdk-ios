//
//  PWNetWorkURLs.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/10.
//  Copyright © 2018年 hll. All rights reserved.
//

#ifndef PWNetWorkURLs_h
#define PWNetWorkURLs_h
#ifdef DEV //开发环境
#define HTTP_PROTOCOL @"http://"
#define API_SEVERID HTTP_PROTOCOL@"testing.home-via-core-stone.cloudcare.cn:10100"
#define API_SHRINE  HTTP_PROTOCOL@"testing.shrine-via-core-stone.cloudcare.cn:10100"
#define API_FORUM   HTTP_PROTOCOL@"testing.forum-via-core-stone.cloudcare.cn:10100"
#define API_CORE_STONE   HTTP_PROTOCOL@"testing.core-stone.cloudcare.cn:10100"
#define API_H5_HOST   HTTP_PROTOCOL@"testing.profwang-h5.cloudcare.cn:10302"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"testing.profwang-h5.cloudcare.cn:10302"
#define API_LIBRARY    HTTP_PROTOCOL@"testing.profwang-h5.cloudcare.cn:10302"
#define JPUSH_ID @"e008337585ca5df269038d4f"

#elif PREPROD //预发环境
#define HTTP_PROTOCOL @"https://"
#define API_SEVERID HTTP_PROTOCOL@"preprod-home-via-core-stone.cloudcare.cn"
#define API_SHRINE  HTTP_PROTOCOL@"preprod-shrine-via-core-stone.cloudcare.cn"
#define API_FORUM   HTTP_PROTOCOL@"preprod-forum-via-core-stone.cloudcare.cn"
#define API_CORE_STONE   HTTP_PROTOCOL@"preprodcore-stone.cloudcare.cn:10100"
#define API_H5_HOST   HTTP_PROTOCOL@"preprod-terms.prof.wang"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"preprod-service.cloudcare.cn"
#define API_LIBRARY    HTTP_PROTOCOL@"preprod-library.prof.wang"
#define JPUSH_ID @"557856f95bfb15efc965ff99"

#else //正式环境
#define HTTP_PROTOCOL @"https://"
#define API_SEVERID HTTP_PROTOCOL@"home-via-core-stone.cloudcare.cn"
#define API_SHRINE  HTTP_PROTOCOL@"shrine-via-core-stone.cloudcare.cn"
#define API_FORUM   HTTP_PROTOCOL@"forum-via-core-stone.cloudcare.cn"
#define API_CORE_STONE   HTTP_PROTOCOL@"core-stone.cloudcare.cn:10100"
#define API_H5_HOST   HTTP_PROTOCOL@"terms.prof.wang"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"service.cloudcare.cn"
#define API_LIBRARY    HTTP_PROTOCOL@"library.prof.wang"
#define JPUSH_ID @"a0d40a210d0969b07a9c472e"

#endif

#define API_HOST [NSString stringWithFormat:@"%@/api", API_SEVERID]

#pragma mark ========== 登录/注册 ==========
// 登录接口 密码登录
#define PW_loginUrl                    API_SEVERID@"/v1/auth/password-login"
// 发送验证码
#define PW_sendAuthCodeUrl             API_SEVERID@"/v1/auth/send-sms"
// 验证码验证
#define PW_checkCodeUrl                API_SEVERID@"/v1/auth/sms-login"

// 当前用户的信息
#define PW_currentUser                 API_SEVERID@"/v1/auth/account"

// 修改密码
#define PW_changePassword              API_SEVERID@"/v1/auth/change-password"
// 忘记密码
#define PW_forgottenPassword           API_SEVERID@"/v1/auth/forgotten-password"




#pragma mark ========== 情报 ==========
//首页News列表   // @"http://testing.forum-via-core-stone.cloudcare.cn:10100/v1/post?orderBy=updatedAt"
#define PW_newsList                   API_FORUM@"/v1/post?orderBy=updatedAt"

//情报列表
#define PW_issueList                   API_SEVERID@"/v1/issue/list"
//情报源添加
#define PW_addIssueSource  [NSString stringWithFormat:@"%@/v1/issue_source/add", API_SEVERID]
//情报源列表
#define PW_issueSourceList [NSString stringWithFormat:@"%@/v1/issue_source/list", API_SEVERID]
//情报源修改
#define PW_issueSourceModify(issueid) [NSString stringWithFormat:@"%@/v1/issue_source/%@/modify", API_SEVERID,issueid]
//情报源详情
#define PW_issueDetail(issueid) [NSString stringWithFormat:@"%@/v1/issue_source/%@/get", API_SEVERID,issueid]


#define PW_issueSourceDelete(issueid) [NSString stringWithFormat:@"%@/v1/issue_source/%@/delete", API_SEVERID,issueid]
//情报添加
#define PW_issueAdd                     API_SEVERID@"/v1/issue/add"
//文章推荐
#define PW_recommendation               API_SEVERID@"/v1/recommendation/list"


#define PW_favoritesAdd                 API_SEVERID@"/v1/favorites/add"

#pragma mark ========== 智库 ==========
//文章详情链接：
#define PW_articleDetails(ID) [NSString stringWithFormat:@"%@/forum/a/%@",API_H5_HOST,ID]
//handbook详情链接：(嵌套iframe
#define PW_handbook(ID)     [NSString stringWithFormat:@"%@/handbook/h/:%@",API_LIBRARY,ID]
#define PW_handbookList                API_SEVERID@"/v1/handbook/active/list"

#define PW_issueClose(str)     [NSString stringWithFormat:@"%@/v1/issue/%@/ticket/close", API_SEVERID,str]

#define PW_issueRecover(str)      [NSString stringWithFormat:@"%@/v1/issue/%@/recover", API_SEVERID,str]

#pragma mark ========== 团队 ==========
#define PW_CurrentTeam                 API_SEVERID@"/v1/auth/team"
#define PW_teamInvite                  API_SEVERID@"/v1/team/account/invite"
#define PW_AddTeam                     API_SEVERID@"/v1/team/add"
#define PW_CancelTeam                  API_SEVERID@"/v1/team/cancel"
#define PW_TeamAccount                 API_SEVERID@"/v1/team/account/list"
#define PW_TeamModify                  API_SEVERID@"/v1/team/modify"
#define PW_AccountRemove(str)   [NSString stringWithFormat:@"%@/v1/team/account/%@/remove", API_SEVERID,str]
#define PW_OwnertTransfer(str) [NSString stringWithFormat:@"%@/v1/team/account/%@/owner-transfer", API_SEVERID,str]
#pragma mark ========== 我的 ==========
//添加反馈信息
#define PW_addFeedback                 API_SEVERID@"/v1/feedback/add"
#define PW_verifycodeVerify            API_SEVERID@"/v1/account/verifycode/verify"

#define PW_verifycodesend              API_SEVERID@"/v1/account/verifycode/send"
#define PW_systemMessageCount          API_SEVERID@"/v1/system_message/count"
#define PW_systemMessageList           API_SEVERID@"/v1/system_message/list"
#define PW_systemMessageDetail(str)    [NSString stringWithFormat:@"%@/v1/system_message/%@/get", API_SEVERID,str]
#define PW_systemMessageSetRead        API_SEVERID@"/v1/system_message/set/read"
#define PW_verifyoldpassword           API_SEVERID@"/v1/auth/verify-old-password"
//新手机号码 验证码验证
#define PW_modify_un                   API_SEVERID@"/v1/account/modify_un"
#define PW_accountName                 API_SEVERID@"/v1/account/modify"
#define PW_favoritesList               API_SEVERID@"/v1/favorites/list"

#define PW_customerOpenAdmin           API_SHRINE@"/api/resources/action/getWorkGroupMember@workGroupOpenAdmin"
#define PW_favoritesDelete(str)        [NSString stringWithFormat:@"%@/v1/favorites/delete/%@", API_SEVERID,str]
#define PW_accountAvatar               API_SEVERID@"/v1/account/avatar"
#pragma mark ========== 常量 ==========
//获取常量字典
#define PW_utilsConst                  API_SEVERID@"/v1/utils/const"

#pragma mark ========== 协议 ==========
#define PW_privacylegal                API_H5_HOST@"/terms/legal"
#define PW_servicelegal                API_H5_HOST@"/terms/service"
#endif /* PWNetWorkURLs_h */
