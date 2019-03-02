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

#elif PREPROD //预发环境
#define HTTP_PROTOCOL @"https://"
#define API_SEVERID HTTP_PROTOCOL@"preprod-home-via-core-stone.cloudcare.cn"
#define API_SHRINE  HTTP_PROTOCOL@"preprod-shrine-via-core-stone.cloudcare.cn"
#define API_FORUM   HTTP_PROTOCOL@"preprod-forum-via-core-stone.cloudcare.cn"
#define API_CORE_STONE   HTTP_PROTOCOL@"preprodcore-stone.cloudcare.cn:10100"
#define API_H5_HOST   HTTP_PROTOCOL@"preprod-terms.prof.wang"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"preprod-service.cloudcare.cn"
#define API_LIBRARY    HTTP_PROTOCOL@"preprod-library.prof.wang"

#else //正式环境
#define HTTP_PROTOCOL @"https://"
#define API_SEVERID HTTP_PROTOCOL@"home-via-core-stone.cloudcare.cn"
#define API_SHRINE  HTTP_PROTOCOL@"shrine-via-core-stone.cloudcare.cn"
#define API_FORUM   HTTP_PROTOCOL@"forum-via-core-stone.cloudcare.cn"
#define API_CORE_STONE   HTTP_PROTOCOL@"core-stone.cloudcare.cn:10100"
#define API_H5_HOST   HTTP_PROTOCOL@"terms.prof.wang"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"service.cloudcare.cn"
#define API_LIBRARY    HTTP_PROTOCOL@"library.prof.wang"

#endif

#define API_HOST [NSString stringWithFormat:@"%@/api", API_SEVERID]

#pragma mark ========== 登录/注册 ==========
// 登录接口 密码登录
#define PW_loginUrl           [NSString stringWithFormat:@"%@/v1/auth/password-login", API_SEVERID]
// 发送验证码
#define PW_sendAuthCodeUrl    [NSString stringWithFormat:@"%@/v1/auth/send-sms", API_SEVERID]
// 验证码验证
#define PW_checkCodeUrl       [NSString stringWithFormat:@"%@/v1/auth/sms-login", API_SEVERID]
// 设备上短信数量
#define PW_smsCountUrl        [NSString stringWithFormat:@"%@/v3/auth/sms_count", API_HOST]
// 当前用户的信息
#define PW_currentUser  [NSString stringWithFormat:@"%@/v1/auth/account", API_SEVERID]
// 用户头像
#define PW_currentUserIcon            [NSString stringWithFormat:@"%@/v3/current_user/icon", API_HOST]
// 修改密码
#define PW_changePassword     [NSString stringWithFormat:@"%@/v1/auth/change-password", API_SEVERID]
// 忘记密码
#define PW_forgottenPassword     [NSString stringWithFormat:@"%@/v1/auth/forgotten-password", API_SEVERID]





#pragma mark ========== 情报 ==========
//首页News列表   // @"http://testing.forum-via-core-stone.cloudcare.cn:10100/v1/post?orderBy=updatedAt"
#define PW_newsList     [NSString stringWithFormat:@"%@/v1/post?orderBy=updatedAt", API_FORUM]


//情报列表
#define PW_issueList       API_SEVERID@"/v1/issue/list"
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
#define PW_issueAdd              [NSString stringWithFormat:@"%@/v1/issue/add",API_SEVERID]
//文章推荐
#define PW_recommendation      [NSString stringWithFormat:@"%@/v1/recommendation/list",API_SEVERID]




#pragma mark ========== 智库 ==========
//文章详情链接：
#define PW_articleDetails(ID) [NSString stringWithFormat:@"%@/forum/a/%@",API_H5_HOST,ID]
//handbook详情链接：(嵌套iframe
#define PW_handbook(ID)     [NSString stringWithFormat:@"%@/handbook/h/:%@",API_LIBRARY,ID]
#define PW_handbookList    [NSString stringWithFormat:@"%@/v1/handbook/active/list", API_SEVERID]

#define PW_issueClose(str)     [NSString stringWithFormat:@"%@/v1/issue/%@/ticket/close", API_SEVERID,str]

#define PW_issueRecover(str)      [NSString stringWithFormat:@"%@/v1/issue/%@/recover", API_SEVERID,str]

#pragma mark ========== 团队 ==========
#define PW_CurrentTeam    [NSString stringWithFormat:@"%@/v1/auth/team", API_SEVERID]
#define PW_teamInvite     [NSString stringWithFormat:@"%@/v1/team/account/invite", API_SEVERID]
#define PW_AddTeam        [NSString stringWithFormat:@"%@/v1/team/add", API_SEVERID]
#define PW_CancelTeam                  API_SEVERID@"/v1/team/cancel"
#define PW_TeamAccount                 API_SEVERID@"/v1/team/account/list"
#define PW_TeamModify                  API_SEVERID@"/v1/team/modify"
#define PW_AccountRemove(str)   [NSString stringWithFormat:@"%@/v1/team/account/%@/remove", API_SEVERID,str]
#define PW_OwnertTransfer(str) [NSString stringWithFormat:@"%@//v1/team/account/%@/owner-transfer", API_SEVERID,str] 
#pragma mark ========== 我的 ==========
//添加反馈信息
#define PW_addFeedback                 API_SEVERID@"/v1/feedback/addt"
#define PW_verifycodeVerify            API_SEVERID@"/v1/account/verifycode/verify"

#define PW_verifycodesend              API_SEVERID@"/v1/account/verifycode/send"
#define PW_system_message              API_SEVERID@"/v1/system_message/count"
#pragma mark ========== 常量 ==========
//获取常量字典
#define PW_utilsConst                  API_SEVERID@"/v1/utils/const"

#pragma mark ========== 协议 ==========
#define PW_privacylegal                API_H5_HOST@"/terms/legal"
#define PW_servicelegal                API_H5_HOST@"/terms/service"
#endif /* PWNetWorkURLs_h */
