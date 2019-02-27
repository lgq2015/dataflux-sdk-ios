//
//  PWNetWorkURLs.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/10.
//  Copyright © 2018年 hll. All rights reserved.
//

#ifndef PWNetWorkURLs_h
#define PWNetWorkURLs_h

#define API_SEVERID @"http://testing.home-via-core-stone.cloudcare.cn:10100"

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
//首页News列表
#define PW_newsList        @"http://testing.forum-via-core-stone.cloudcare.cn:10100/v1/post?orderBy=updatedAt"


//情报列表
#define PW_issueList       [NSString stringWithFormat:@"%@/v1/issue/list", API_SEVERID]
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
#define PW_articleDetails(ID) [NSString stringWithFormat:@"http://testing.profwang-h5.cloudcare.cn:10302/forum/a/%@",ID]
//handbook详情链接：(嵌套iframe
#define PW_handbook(ID)     [NSString stringWithFormat:@"http://testing.profwang-h5.cloudcare.cn:10302/handbook/h/:%@",ID]
#define PW_handbookList    [NSString stringWithFormat:@"%@/v1/handbook/active/list", API_SEVERID]

#define PW_issueClose(str)     [NSString stringWithFormat:@"%@/v1/issue/%@/ticket/close", API_SEVERID,str]

#define PW_issueRecover(str)      [NSString stringWithFormat:@"%@/v1/issue/%@/recover", API_SEVERID,str]

#pragma mark ========== 团队 ==========
#define PW_CurrentTeam    [NSString stringWithFormat:@"%@/v1/auth/team", API_SEVERID]

#define PW_AddTeam        [NSString stringWithFormat:@"%@/v1/team/add", API_SEVERID]
#pragma mark ========== 我的 ==========
//添加反馈信息
#define PW_addFeedback  [NSString stringWithFormat:@"%@/v1/feedback/addt", API_SEVERID]
#define PW_verifycodeVerify [NSString stringWithFormat:@"%@/v1/account/verifycode/verify", API_SEVERID]

#define PW_verifycodesend [NSString stringWithFormat:@"%@/v1/account/verifycode/send", API_SEVERID] 

#pragma mark ========== 常量 ==========
//获取常量字典
#define PW_utilsConst [NSString stringWithFormat:@"%@/v1/utils/const", API_SEVERID]

#pragma mark ========== 协议 ==========
#define PW_privacylegal       @"http://testing.profwang-h5.cloudcare.cn:10302/protocol/legal"
#define PW_servicelegal       @"http://testing.profwang-h5.cloudcare.cn:10302/protocol/service"
#endif /* PWNetWorkURLs_h */
