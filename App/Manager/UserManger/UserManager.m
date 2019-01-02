//
//  UserManager.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "UserManager.h"
#import "OpenUDID.h"
#import "CurrentUserModel.h"
#import "UserInfo.h"
typedef void(^completeBlock)(id response);

@implementation UserManager
SINGLETON_FOR_CLASS(UserManager);

-(instancetype)init{
    self = [super init];
    if (self) {
        //被踢下线
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKick)
                                                     name:KNotificationOnKick
                                                   object:nil];
    }
    return self;
}
#pragma mark ========== 获取短信/图片验证码 ==========
-(void)getVerificationCodeType:(CodeType)codeType WithParams:(NSDictionary *)params completion:(codeBlock)completion{
   //验证码
    if (codeType == CodeTypeCode) {
        [self cheackSmsCountComplete:^(id response) {
            //大于5
//            NSDictionary *dict = response;
//            if ([dict[@"count"] integerValue]>=5) {
//                if (completion) {
//                    completion(CodeStatusNeedImgCode,nil);
//                }
//            }else{
//
//            }
//            [PWNetworking requsetWithUrl:PW_sendAuthCodeUrl withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
//                DLog(@"%@",response);
//            } failBlock:^(NSError *error) {
//                DLog(@"%@",error);
//
//            }];
        }];
    }else{
    //短信请求过多 图片验证
        
    }
    
}
#pragma mark ========== 检验短信数量 ==========
-(void)cheackSmsCountComplete:(completeBlock)complete{
    NSString *deviceId = [OpenUDID value];
    NSDictionary *param = @{@"deviceId":deviceId};
    [PWNetworking requsetWithUrl:PW_smsCountUrl withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if (complete) {
            complete(response);
        }
        DLog(@"%@",response);
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
        if (complete) {
            complete(error);
        }
    }];
}
#pragma mark ========== 刷新验证图片 ==========

#pragma mark ========== 登录操作 ==========
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{
    if(loginType == kUserLoginTypePwd){
      //密码登录
        [PWNetworking requsetWithUrl:PW_loginUrl withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
            if ([response[@"code"] isEqual:@0]) {
                NSError *error;
                _curUserInfo = [[UserInfo alloc]initWithDictionary:response[@"data"] error:&error];
                setXAuthToken(response[@"data"][@"ticket"]);
                KPostNotification(KNotificationLoginStateChange, @YES);
                [self saveUserInfo];
            }
            if ([response[@"code"] isEqual:@77]) {
                DLog(@"%@",response);
                [iToast alertWithTitleCenter:response[@"zh_CN"]];
            }
        } failBlock:^(NSError *error) {
            DLog(@"%@",error);

        }];
    }else{
      //验证码登录
        [PWNetworking requsetWithUrl:PW_checkCodeUrl withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
            if ([response[@"code"] isEqual:@0]) {
                NSError *error;
                _curUserInfo = [[UserInfo alloc]initWithDictionary:response[@"data"] error:&error];
                [self saveUserInfo];
                KPostNotification(KNotificationLoginStateChange, @YES);
            }
            if ([response[@"code"] isEqual:@77]) {
                DLog(@"%@",response);
                [iToast alertWithTitleCenter:response[@"zh_CN"]];
            }
        } failBlock:^(NSError *error) {
                DLog(@"%@",error);
        }];
    }
    
}
#pragma mark ========== 储存用户信息 ==========
-(void)saveUserInfo{
//    [PWNetworking requsetHasTokenWithUrl:PW_currentUser withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
//        if([response[@"code"] isEqual:@0]){
//            NSError *error;
//            self.curUserInfo = [[CurrentUserModel alloc]initWithDictionary:response[@"data"] error:&error];
//        }
//    } failBlock:^(NSError *error) {
//        DLog(@"%@",error);
//    }];
    if (self.curUserInfo) {
        YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
        NSDictionary *dic = [self.curUserInfo modelToJSONObject];
        [cache setObject:dic forKey:KUserModelCache];
    }
    
}
#pragma mark ========== 退出登录 ==========
- (void)logout:(void (^)(BOOL, NSString *))completion{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogout object:nil];//被踢下线通知用户退出直播间
    
    
    self.curUserInfo = nil;
    self.isLogined = NO;
    
    //    //移除缓存
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    [cache removeAllObjectsWithBlock:^{
        if (completion) {
            completion(YES,nil);
        }
    }];
    
    KPostNotification(KNotificationLoginStateChange, @NO);
}
-(void)autoLoginToServer:(loginBlock)completion{
    
}
#pragma mark ========== 加载缓存的用户信息 ==========
-(BOOL)loadUserInfo{
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    NSDictionary * userDic = (NSDictionary *)[cache objectForKey:KUserModelCache];
    if (userDic) {
        self.curUserInfo = [CurrentUserModel modelWithJSON:userDic];
        return YES;
    }
    return NO;
}
#pragma mark ========== 被踢下线 ==========
-(void)onKick{
    [self logout:nil];
}


@end
