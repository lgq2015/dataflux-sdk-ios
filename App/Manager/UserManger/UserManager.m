//
//  UserManager.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "UserManager.h"
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
            NSDictionary *dict = response;
            if ([dict[@"count"] integerValue]>=5) {
                if (completion) {
                    completion(CodeStatusNeedImgCode,nil);
                }
            }else{
                
            }
        }];
    }else{
    //短信请求过多 图片验证
        
    }
    
}
#pragma mark ========== 检验短信数量 ==========
-(void)cheackSmsCountComplete:(completeBlock)complete{
    //    [PWNetworking requsetWithUrl:PW_smsCount withRequestType:<#(NetworkRequestType)#> refreshRequest:<#(BOOL)#> cache:<#(BOOL)#> params:<#(NSDictionary *)#> progressBlock:<#^(int64_t bytesRead, int64_t totalBytes)progressBlock#> successBlock:<#^(id response)successBlock#> failBlock:<#^(NSError *error)failBlock#>]
}
#pragma mark ========== 登录操作 ==========
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{
    if(loginType == kUserLoginTypePwd){
      //密码登录
    }else{
      //验证码登录
    }
    
}
#pragma mark ========== 储存用户信息 ==========
-(void)saveUserInfo{
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
        self.curUserInfo = [UserInfo modelWithJSON:userDic];
        return YES;
    }
    return NO;
}
#pragma mark ========== 被踢下线 ==========
-(void)onKick{
    [self logout:nil];
}


@end
