//
//  PWNetWorkURLs.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/10.
//  Copyright © 2018年 hll. All rights reserved.
//

#ifndef PWNetWorkURLs_h
#define PWNetWorkURLs_h

#define HTTPS_PROTOCOL_STRING @"https://"
#define HTTP_PROTOCOL_STRING @"http://"

#if DEV //开发环境
#define IS_HTTPS  0
#if IS_HTTPS
#define HTTP_PROTOCOL HTTPS_PROTOCOL_STRING
#else
#define HTTP_PROTOCOL HTTP_PROTOCOL_STRING
#endif

#define API_SEVERID HTTP_PROTOCOL@"testing.home-via-core-stone.cloudcare.cn:10100"
#define API_SHRINE  HTTP_PROTOCOL@"testing.shrine-via-core-stone.cloudcare.cn:10100"
#define API_FORUM   HTTP_PROTOCOL@"testing.forum-via-core-stone.cloudcare.cn:10100"
#define API_CORE_STONE   HTTP_PROTOCOL@"testing.core-stone.cloudcare.cn:10100"
#define API_H5_HOST   HTTP_PROTOCOL@"testing.profwang-h5.cloudcare.cn:10302"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"testing.profwang-h5.cloudcare.cn:10302"
#define API_LIBRARY    HTTP_PROTOCOL@"testing.profwang-h5.cloudcare.cn:10302"
#define API_CARRIER_HOST    HTTP_PROTOCOL@"testing.carrier-via-core-stone.cloudcare.cn:10100"
#define PW_ISSUE_HELP(str)                [NSString stringWithFormat:@"%@pre-library.prof.wang/handbook_html/user-help/%@-connect/index.html", HTTP_PROTOCOL,str]
#define JPUSH_ID            @"e008337585ca5df269038d4f"
#define QQ_APPKEY           @"1108030178"
#define WX_APPKEY           @"wx6d7b153b7387b5c4"
#define DINGDING_APPKEY     @"dingoagikluhqlvit4wovq"
#elif PREPROD //预发环境

#define IS_HTTPS  1
#if IS_HTTPS
#define HTTP_PROTOCOL HTTPS_PROTOCOL_STRING
#else
#define HTTP_PROTOCOL HTTP_PROTOCOL_STRING
#endif

#define API_SEVERID HTTP_PROTOCOL@"preprod-home-via-core-stone.cloudcare.cn"
#define API_SHRINE  HTTP_PROTOCOL@"preprod-shrine-via-core-stone.cloudcare.cn"
#define API_FORUM   HTTP_PROTOCOL@"preprod-forum-via-core-stone.cloudcare.cn"
#define API_CORE_STONE   HTTP_PROTOCOL@"preprod-core-stone.cloudcare.cn"
#define API_H5_HOST   HTTP_PROTOCOL@"preprod-terms.prof.wang"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"preprod-service.cloudcare.cn"
#define API_CARRIER_HOST    HTTP_PROTOCOL@"preprod-carrier-via-core-stone.cloudcare.cn"
#define API_LIBRARY    HTTP_PROTOCOL@"preprod-library.prof.wang"
#define PW_ISSUE_HELP(str)                [NSString stringWithFormat:@"%@pre-library.prof.wang/handbook_html/user-help/%@-connect/index.html", HTTP_PROTOCOL,str]
#define JPUSH_ID            @"557856f95bfb15efc965ff99"
#define QQ_APPKEY           @"1108154997"
#define WX_APPKEY           @"wx26ac01021209f766"
#define DINGDING_APPKEY     @"dingoaq9v3khnry2ayokri"

#else //正式环境
#define IS_HTTPS  1
#if IS_HTTPS
#define HTTP_PROTOCOL HTTPS_PROTOCOL_STRING
#else
#define HTTP_PROTOCOL HTTP_PROTOCOL_STRING
#endif

#define API_SEVERID HTTP_PROTOCOL@"home-via-core-stone.cloudcare.cn"
#define API_SHRINE  HTTP_PROTOCOL@"shrine-via-core-stone.cloudcare.cn"
#define API_FORUM   HTTP_PROTOCOL@"forum-via-core-stone.cloudcare.cn"
#define API_CORE_STONE   HTTP_PROTOCOL@"core-stone.cloudcare.cn"
#define API_H5_HOST   HTTP_PROTOCOL@"common.prof.wang"
#define API_CC_PLUS_HOST   HTTP_PROTOCOL@"service.cloudcare.cn"
#define API_LIBRARY    HTTP_PROTOCOL@"library.prof.wang"
#define API_CARRIER_HOST    HTTP_PROTOCOL@"carrier-via-core-stone.cloudcare.cn"
#define PW_ISSUE_HELP(str)                [NSString stringWithFormat:@"%@library.prof.wang/handbook_html/user-help/%@-connect/index.html", HTTP_PROTOCOL,str]
#define JPUSH_ID           @"a0d40a210d0969b07a9c472e"
#define QQ_APPKEY          @"1108030042"
#define WX_APPKEY          @"wx1c3b94b644454727"
#define DINGDING_APPKEY    @"dingoagfockwplqrickp6y"
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

#define PW_sendEmail                   API_SEVERID@"/v1/auth/send-email"


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
//#define PW_issueDetail(issueid)   [NSString stringWithFormat:@"%@/v1/issue_source/%@/get", API_SEVERID,issueid]

#define PW_issueDetail(issueid)    [NSString stringWithFormat:@"%@/v1/issue/%@/get", API_SEVERID,issueid]
//情报日志详情
#define PW_issueLog       [NSString stringWithFormat:@"%@/v1/issue/log/list", API_SEVERID]
#define PW_issueSourceDelete(issueid) [NSString stringWithFormat:@"%@/v1/issue_source/%@/delete", API_SEVERID,issueid]
//情报日志添加
#define PW_issueLogAdd(issueid)  [NSString stringWithFormat:@"%@/v1/issue/%@/log/add", API_SEVERID,issueid]
//情报日志 上传附件
#define PW_issueUploadAttachment(issueid) [NSString stringWithFormat:@"%@/v1/issue/%@/log/upload-attachment", API_SEVERID,issueid]
//情报日志附件外部下载链接地址
#define PW_issueDownloadurl(issueid)   [NSString stringWithFormat:@"%@/v1/issue/log/%@/attachment-external-download-url", API_SEVERID,issueid]
//开启工单
#define PW_issueTicketOpen(issueid)   [NSString stringWithFormat:@"%@/v1/issue/%@/ticket/open", API_SEVERID,issueid]
#define PW_heartBeat  API_SEVERID@"/v1/auth/heartbeat"

//情报添加
#define PW_issueAdd                     API_SEVERID@"/v1/issue/add"
//文章推荐
#define PW_recommendation               API_SEVERID@"/v1/recommendation/list"


#define PW_favoritesAdd                 API_SEVERID@"/v1/favorites/add"

#define PW_TIPS                       HTTP_PROTOCOL@"files.cloudcare.cn/home/tips/tips.json"

#define PW_AdduploaAttachment         API_SEVERID@"/v1/issue/add-upload-attachment"

#define PW_URL_CARRIER_PROBE          API_CARRIER_HOST@"/v1/probe"
#pragma mark ========== 智库 ==========
//文章详情链接：
#define PW_articleDetails(ID) [NSString stringWithFormat:@"%@/forum/a/%@",API_H5_HOST,ID]
//handbook详情链接：(嵌套iframe
#define PW_handbookUrl(ID)   [NSString stringWithFormat:@"%@/handbook/h/%@",API_LIBRARY,ID]
#define PW_handbook(ID)     [NSString stringWithFormat:@"%@/v1/handbook/%@/article/list",API_SEVERID,ID]
#define PW_handbookList                API_SEVERID@"/v1/handbook/active/list"

#define PW_issueClose(str)     [NSString stringWithFormat:@"%@/v1/issue/%@/ticket/close", API_SEVERID,str]

#define PW_issueRecover(str)      [NSString stringWithFormat:@"%@/v1/issue/%@/recover", API_SEVERID,str]
#define PW_articleSearch               API_SEVERID@"/v1/handbook/article/search"

#define PW_handbookdetail             API_SEVERID@"/v1/handbook/article/detail"
#pragma mark ========== 服务 ==========
#define PW_cloudcare                   API_H5_HOST@"/service/list"
#define PW_OrderList                   API_SHRINE@"/resources/action/listOrders@customerOpenAdmin"
//http://testing.shrine-via-core-stone.cloudcare.cn:10100/resources/action/listOrders@customerOpenAdmin,
#pragma mark ========== 团队 ==========
#define PW_CurrentTeam                 API_SEVERID@"/v1/auth/current-team"
#define PW_teamInvite                  API_SEVERID@"/v1/team/account/invite"
#define PW_AddTeam                     API_SEVERID@"/v1/team/add"
#define PW_AuthTeamList                API_SEVERID@"/v1/auth/team-list"
#define PW_AuthSwitchTeam              API_SEVERID@"/v1/auth/switch-team"
#define PW_CancelTeam                  API_SEVERID@"/v1/team/cancel"
#define PW_TeamAccount                 API_SEVERID@"/v1/team/account/list"
#define PW_TeamModify                  API_SEVERID@"/v1/team/modify"
#define PW_AccountRemove(str)   [NSString stringWithFormat:@"%@/v1/team/account/%@/remove", API_SEVERID,str]
#define PW_OwnertTransfer(str) [NSString stringWithFormat:@"%@/v1/team/account/%@/owner-transfer", API_SEVERID,str]
#define PW_TeamProduct                 API_SEVERID@"/v1/team/product"
//服务记录
#define PW_issueGeneralList    API_SEVERID@"/v1/issue/general-list"






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
#define PW_ExpertAvatarSmall(str)            [NSString stringWithFormat:@"%@files.cloudcare.cn/profwang/expert/small/%@.png", HTTP_PROTOCOL,str]
#define PW_ExpertAvatarBig(str)              [NSString stringWithFormat:@"%@files.cloudcare.cn/profwang/expert/big/%@.png", HTTP_PROTOCOL,str]
#pragma mark ========== 协议 ==========
#define PW_privacylegal                API_H5_HOST@"/terms/legal"
#define PW_servicelegal                API_H5_HOST@"/terms/service"

#define PW_Safelegal                   API_H5_HOST@"/terms/datasafe"
#define PW_fouctionIntro               API_SEVERID@"/v1/app/version/list"
#define PW_ContactUS                   API_SHRINE@"/resources/action/getWorkGroupMember@workGroupOpenAdmin"
#define PW_CMSCall                     API_SEVERID@"/v1/utils/csm-call"
#define PW_articelForumclick(id)           [NSString stringWithFormat:@"%@/v1/post/%@", API_FORUM,id]
#define PW_jpushDidLogin               API_SEVERID@"/v1/auth/device/registration"
#endif /* PWNetWorkURLs_h */

