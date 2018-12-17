//
//  PWNetWorkURLs.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/10.
//  Copyright © 2018年 hll. All rights reserved.
//

#ifndef PWNetWorkURLs_h
#define PWNetWorkURLs_h

#define API_SEVERID @"http://testing.home.cloudcare.cn:85"

#define API_HOST [NSString stringWithFormat:@"%@/api", API_SEVERID]

#pragma mark ========== 登录/注册 ==========
// 登录接口 获取token
#define PW_loginUrl           [NSString stringWithFormat:@"%@/v3/auth/token", API_HOST]
// 发送验证码
#define PW_sendAuthCodeUrl    [NSString stringWithFormat:@"%@/v3/auth/sms_verify_code_old", API_HOST]
// 验证码验证
#define PW_checkCodeUrl       [NSString stringWithFormat:@"%@/v3/auth/phone_sms_verify", API_HOST]
// 设备上短信数量
#define PW_smsCountUrl        [NSString stringWithFormat:@"%@v3/auth/sms_count", API_HOST]

/*
 // ---serviceUrl 相关 start --
 
 //消息列表
 message_list: 'v3/system_message',
 message_logo_list: 'v3/system_message/definition',
 message_pull_list: 'v3/system_message/${id}/recent',
 service_record_list: 'v3/event',
 read_message: 'v3/subuser_message_map',
 // 文章搜索列表
 article_search_list: 'article',
 // 活动
 activity_list: 'v2/activity',
 // 报名活动
 enroll_activity: 'v2/activity/${activityId}/enroll',
 //获取活动详情
 get_activity_detail: 'v2/activity/${activityId}',
 // banner
 banner_list: 'v2/banner',
 // 获取消息对应url
 message_redirect_url: 'v2/dispatch/messages/${eventType}/${eventId}',
 // 获取事件详情
 get_event_detail: 'v3/event/${event_id}',
 // 事件评星
 submit_evaluate: 'v3/event/${event_id}/evaluate',
 // 删除消息
 delete_messages_url: 'v3/subuser_message_deleted_map',
 // 创建企业
 create_company: 'v3/subuser/create_company',
 
 // 用户读取文章
 user_read_info: 'v2/auth/user_read_info',
 // 文章分享
 share_article: 'v2/auth/share_article',
 // 用户验证
 
 sso_token: 'v3/auth/sso_token',
 
 clear_token: 'v3/auth/clear_token/${token}',
 
 open_pw: 'v3/auth/open_pw',
 
 // 获取图形验证码图片
 auth_captcha: 'v3/auth/captcha',
 
 // 图形验证
 verify_captcha: 'v3/auth/verify/captcha',
 
 // 设备上短信数量
 sms_count: 'v3/auth/sms_count/${deviceId}',
 
 // 短信验证码
 sms_verify_code: 'v3/auth/sms_verify_code_old',
 
 // 短信验证码验证
 phone_sms_verify: 'v3/auth/phone_sms_verify',
 
 //验证邮箱验证码
 email_sms_verify: 'v3/auth/email_sms_verify',
 
 //发送邮箱验证码
 email_verify_code: 'v2/auth/email_verify_code', //发送邮箱验证码
 email_verify_code_v3: 'v3/auth/email_verify_code',
 // 修改用户信息，需要验证码
 user_change_info_verify: 'v3/auth/user_change_info_verify',
 
 sms_verify_code_for_change_phone: 'v3/auth/sms_verify_code_for_change_phone',
 
 //重置密码
 reset_password: 'v3/auth/reset_password',
 reset_password_v2: 'v2/auth/reset_password',
 
 //修改密码
 change_password: 'v3/auth/change_password',
 
 // 邮箱邀请
 send_email_link: 'v3/auth/send_email_link',
 
 //当前用户信息
 current_user: 'v3/current_user',
 
 // 用户头像
 current_user_icon: 'v3/current_user/icon',
 
 //成员注册
 subuser_register: 'v3/auth/subuser_register',
 
 //成员
 subuser_by_id: 'v3/subuser/${id}',
 
 subuser: 'v3/subuser',
 
 subuser_change_primary_user: 'v3/subuser/${subId}/change_primary_user',
 //
 subuser_cancel: 'v3/subuser/${subId}/cancel',
 
 //
 subuser_deactivate: 'v3/subuser/${subId}/deactivate_old',
 
 //
 subuser_bind_info: 'v3/auth/subuser_bind_info/${uuid}',
 
 //职位列表
 user_position: 'v2/user_position',
 
 // 心跳接口
 auth_heartbeat: 'v3/auth/heartbeat',
 
 // 登录页面
 entry_option: 'v3/auth/entry_option',
 
 // 成员邀请二维码
 auth_qrcode: 'v3/auth/qrcode',
 
 // 用户权限
 auth_permission: 'v3/auth/permission',
 
 // 验证登录密码
 auth_password: 'v3/auth/auth_password',
 
 //
 auth_check_uuid: 'v2/auth/check_uuid/${uuid}',
 
 sms_verify_code_for_change: 'v3/auth/sms_verify_code_for_change',
 
 // 隐私条款
 about_legal: 'v2/dispatch/about/legal',
 
 // 服务协议
 about_terms: 'v2/dispatch/about/terms',
 
 // 服务计划
 about_plan: 'v2/dispatch/about/plan',
 
 //
 tools_purchase: 'v2/dispatch/tools/purchase',
 
 device: 'v2/device',
 
 // 服务咨询类型
 service: 'v3/service',
 
 // 服务咨询列表
 service_list: 'v3/service/available',
 
 // 服务咨询详情
 service_detail: 'v3/service/detail',
 
 service_package: 'v3/service/package',
 
 //调起发起服务咨询
 event: 'v3/event',
 
 // 服务类型标题判断
 event_title_judgement: 'v3/event/title/judgement',
 // 事件消息
 event_system_message: 'v3/event_system_message',
 
 // 获取工作时间数据
 is_working_time: 'v2/utils/is_working_time',
 
 // 订单详情
 trade_order: 'v3/trade/order/${order_no}/info',
 // 订单物流信息
 trade_order_delivery: 'v3/trade/order/${order_no}/delivery',
 
 // 订单取消
 trade_delete: 'v3/trade/delete',
 
 // 订单取消
 trade_open_event: 'v3/trade/open_event',
 
 // 订单列表
 trade_list: 'v3/trade/list',
 
 // 事件评价
 event_evaluate: 'v3/event/${event_id}/evaluate',
 
 //
 about_us: 'v2/dispatch/about/us',
 
 //
 app_version: 'v2/app_version',
 
 // 获取城市信息
 address_book: 'v2/utils/address_book',
 
 //
 change_address_by_user_id: 'v2/address/${user_id}',
 
 change_address: 'v2/address',
 
 
 communication_phonecall: 'v2/communication/phonecall',
 
 // 云账号列表
 cloud_account: 'v2/cloud_account',
 
 // 获取云账号信息
 cloud_account_info: 'v2/cloud_account/${id}',
 
 
 // 获取云账号信息
 user_opinion: 'v2/user_opinion',
 
 handbook_category: 'v3/handbook/category/',
 
 handbook_category_by_id: 'v3/handbook/category/${id}/',
 
 handbook_detail_by_id: 'v3/handbook/t/${id}/',
 
 column_images_by_id: 'v3/handbook/category/${id}/images',
 
 // 获取分享短链接
 shorturl: 'v3/shorturl',
 
 
 // 获取情报列表
 issue_list: 'v3/issue',
 // 获取情报日志
 issue_log_list: '/v3/issue_log',
 
 issue_service_list: 'v3/issue/service/issues',
 issue_definition: 'v3/issue/definition',
 issue_count_url: 'v3/issue/${issueType}/count',
 event_read_count: 'v3/event_system_message/event_read_status_count',
 // --- serviceUrl 相关 end ---
 
 // --- homeBaseApiUrl 相关 start ---
 
 // 个人新区标签
 'prefer-classes': 'v1/user/prefer-classes',
 // 兴趣标签列表
 'tag-classes': 'v1/tag-classes',
 
 
 // 解决方案列表
 solution_list: 'v1/solution/search',
 // 问候语
 ai_greeting: 'v2/ai/greeting',
 
 ai_query: 'v2/ai/query',
 
 hot_question: 'v2/hot_question/get',
 
 // --- homeBaseApiUrl 相关 end ---
 
 // --- dotBaseApiUrl 相关 start ---
 
 // 全文搜索
 custom_search: 'v1/custom/search',
 // 文章列表
 push_list: 'v3/push-list',
 // ding／收藏
 ding: 'v3/ding',
 
 'history-today': 'v1/history-today',
 
 // 文章详情
 article_detail: 'v3/article/detail',
 // 文章详情
 vote: 'v2/vote',
 
 // 查询文库
 article_search: 'v1/article',
 
 //收藏
 favorite_list: 'v2/favorite-list',
 favorite_delete: 'v2/favorite',
 */
#endif /* PWNetWorkURLs_h */
