//
//  UserManager.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <JPush/JPUSHService.h>
#import "UserManager.h"
#import "OpenUDID.h"
#import "TeamInfoModel.h"
#import "InformationStatusReadManager.h"
#import "PWSocketManager.h"
#import "IssueListManger.h"
#import "HandBookManager.h"
#import "IssueSourceManger.h"
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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadTeamInfo)
                                                     name:KNotificationTeamStatusChange
                                                   object:nil];
    }
    return self;
}
- (void)addTeamSuccess:(void(^)(BOOL isSuccess))isSuccess
{
    
        [PWNetworking requsetHasTokenWithUrl:PW_CurrentTeam withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSDictionary *content = response[@"content"];
                if (content.allKeys.count>0) {
                    NSError *error;
                    self.teamModel = [[TeamInfoModel alloc]initWithDictionary:content error:&error];
                    if (self.teamModel) {
                        YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
                        NSDictionary *dic = [self.teamModel modelToJSONObject];
                        [cache setObject:dic forKey:KTeamModelCache];
                        if (isSuccess) {
                            isSuccess(YES);
                        }
                    }
                    setTeamState(PW_isTeam);
                    [kUserDefaults synchronize];
                }else{
                    setTeamState(PW_isPersonal);
                    [kUserDefaults synchronize];
                }
                
            }
        } failBlock:^(NSError *error) {
            if (isSuccess) {
                isSuccess(NO);
            }
        }];
    
}


#pragma mark ========== 登录操作 ==========
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{
    if(loginType == UserLoginTypePwd){
      //密码登录
        [PWNetworking requsetWithUrl:PW_loginUrl withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            NSString *errCode = response[ERROR_CODE];
            if(errCode.length>0){
                if (completion) {
                    completion(NO,nil);
                }
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
                
//          [iToast alertWithTitleCenter:];
                
            }else{
                if (completion) {
                    completion(YES,nil);
                }
                self.isLogined = YES;
                NSDictionary *content = response[@"content"];
                setXAuthToken(content[@"authAccessToken"]);
                [kUserDefaults synchronize];
                [self saveUserInfoLoginStateisChange:YES success:nil];
            }
            
        } failBlock:^(NSError *error) {
            DLog(@"%@",error);
            if (completion) {
                completion(NO,nil);
            }
            [SVProgressHUD dismiss];
            [iToast alertWithTitleCenter:@"网络异常"];
        }];
    }else{
      //验证码登录
        [PWNetworking requsetWithUrl:PW_checkCodeUrl withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                self.isLogined = YES;
                NSDictionary *content = response[@"content"];
                setXAuthToken(content[@"authAccessToken"]);
                [kUserDefaults synchronize];                
                BOOL isRegister = [content[@"isRegister"] boolValue];
             if (isRegister) {
                 NSString *changePasswordToken = content[@"changePasswordToken"];
                    if (completion) {
                        completion(YES,changePasswordToken);
                    }
                    [self saveUserInfoLoginStateisChange:NO success:nil];
                }else{
                    [self saveUserInfoLoginStateisChange:YES success:nil];
                }
            }else{
                if (completion) {
                    completion(NO,@"");
                }
               
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
            }
            
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (completion) {
                completion(NO,@"");
            }
            [iToast alertWithTitleCenter:@"网络异常"];

        }];
    }
    
}
#pragma mark ========== 储存用户信息 ==========
-(void)saveUserInfoLoginStateisChange:(BOOL)change success:(void(^)(BOOL isSuccess))isSuccess{
    __block BOOL isUserSuccess,isTeamSuccess = NO;

    dispatch_queue_t queueT = dispatch_queue_create("group.queue", DISPATCH_QUEUE_CONCURRENT);//一个并发队列
    dispatch_group_t grpupT = dispatch_group_create();//一个线程组
    
    dispatch_group_async(grpupT, queueT,^{
        dispatch_group_enter(grpupT);
        [PWNetworking requsetHasTokenWithUrl:PW_currentUser withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            NSString *errCode = response[ERROR_CODE];
            if(errCode.length>0){
                [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
                 dispatch_group_leave(grpupT);
            }else{
                isUserSuccess = YES;
                NSError *error;
                self.curUserInfo = [[CurrentUserModel alloc]initWithDictionary:response[@"content"] error:&error];
                if (self.curUserInfo) {
                    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
                    NSDictionary *dic = [self.curUserInfo modelToJSONObject];
                    [cache setObject:dic forKey:KUserModelCache];
                    NSString *userID= [self.curUserInfo.userID stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    setPWUserID(userID);
                    dispatch_group_leave(grpupT);
                }else{
                  dispatch_group_leave(grpupT);
                }
            }
           
        } failBlock:^(NSError *error) {
            DLog(@"%@",error);
           
            dispatch_group_leave(grpupT);
        }];
        
    });
   
    dispatch_group_async(grpupT, queueT, ^{
        dispatch_group_enter(grpupT);
        [PWNetworking requsetHasTokenWithUrl:PW_CurrentTeam withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                isTeamSuccess = YES;
                NSDictionary *content = response[@"content"];
                if (content.allKeys.count>0) {
                    NSError *error;
                    self.teamModel = [[TeamInfoModel alloc]initWithDictionary:content error:&error];
                    if (self.teamModel) {
                        YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
                        NSDictionary *dic = [self.teamModel modelToJSONObject];
                        [cache setObject:dic forKey:KTeamModelCache];
                    }
                    setTeamState(PW_isTeam);
                    [kUserDefaults synchronize];
                }else{
                    setTeamState(PW_isPersonal);
                    [kUserDefaults synchronize];
                }
                  dispatch_group_leave(grpupT);
            }else{
                  dispatch_group_leave(grpupT);
            }
          
        } failBlock:^(NSError *error) {
           
            dispatch_group_leave(grpupT);
        }];
    });
    dispatch_group_notify(grpupT, queueT, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if( isTeamSuccess && isUserSuccess){
                if(change){
                    
                    KPostNotification(KNotificationLoginStateChange, @YES);
                }
                if (isSuccess) {
                    isSuccess(YES);
                }
            }else{
                [iToast alertWithTitleCenter:@"网络异常"];
            }
        });
        
    });
    [self loadExperGroups:nil];
}
-(void)judgeIsHaveTeam:(void(^)(BOOL isHave,NSDictionary *content))isHave{
    [PWNetworking requsetHasTokenWithUrl:PW_CurrentTeam withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            if (content.allKeys.count>0) {
                NSError *error;
                self.teamModel = [[TeamInfoModel alloc]initWithDictionary:content error:&error];
                setTeamState(PW_isTeam);
                [kUserDefaults synchronize];
                isHave(YES,content);
            }else{
                setTeamState(PW_isPersonal);
                [kUserDefaults synchronize];
                isHave(NO,nil);
            }
            
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)reloadTeamInfo
{
    [self addTeamSuccess:^(BOOL isSuccess) {
        
    }];
}
#pragma mark ========== 退出登录 ==========
- (void)logout:(void (^)(BOOL, NSString *))completion{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogout object:nil];//被踢下线通知用户退出直播间
    [kUserDefaults removeObjectForKey:PWLastTime];
    [kUserDefaults removeObjectForKey:PWTeamState];

    self.curUserInfo = nil;
    self.teamModel = nil;
    self.isLogined = NO;
   
    [[InformationStatusReadManager sharedInstance] shutDown];
    [[IssueListManger sharedIssueListManger] shutDown];
    [[HandBookManager sharedInstance] shutDown];
    [[PWSocketManager sharedPWSocketManager] shutDown];
    [[IssueSourceManger sharedIssueSourceManger] logout];
    [[IssueListManger sharedIssueListManger] createData];
    //    //移除缓存
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    YYCache *cacheteam = [[YYCache alloc]initWithName:KTeamCacheName];
    __block BOOL iscompletion1,completion2;
    [cache removeAllObjectsWithBlock:^{
        iscompletion1 = YES;
    }];
    [cacheteam removeAllObjectsWithBlock:^{
        completion2 = YES;
    }];
    if (iscompletion1&&completion2) {
        if (completion) {
            completion(YES,nil);
        }
    }else{
        if (completion) {
            completion(NO,nil);
        }
    }
    KPostNotification(KNotificationLoginStateChange, @NO);

}

-(void)autoLoginToServer:(loginBlock)completion{
    
}
#pragma mark ========== 加载缓存的用户信息 ==========
-(BOOL)loadUserInfo{
    [self loadExperGroups:nil];
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    YYCache *cacheteam = [[YYCache alloc]initWithName:KTeamCacheName];
    NSDictionary * userDic = (NSDictionary *)[cache objectForKey:KUserModelCache];
    NSDictionary * teamDic = (NSDictionary *)[cacheteam objectForKey:KTeamModelCache];
    if([getTeamState isEqualToString:PW_isTeam]){
    if (userDic && teamDic) {
        self.curUserInfo = [CurrentUserModel modelWithJSON:userDic];
        self.teamModel = [TeamInfoModel modelWithJSON:teamDic];
        return YES;
    }
    }else{
        if (userDic) {
        self.curUserInfo = [CurrentUserModel modelWithJSON:userDic];
        return YES;
        }
    }
    return NO;
}
- (void)getExpertNameByKey:(NSString *)key name:(void(^)(NSString *name))name{
    if (self.expertGroups.count == 0) {
        self.expertGroups = [NSMutableArray new];
        [self loadExperGroups:^(NSArray *experGroups) {
            [self.expertGroups addObjectsFromArray:experGroups];
            if (name) {
                name([self privateGetExpertNameByKey:key]);
            }
        }];
        
    }else{
        if (name) {
            name([self privateGetExpertNameByKey:key]);
        }
    }
}

- (NSString *)privateGetExpertNameByKey:(NSString *)key{
    __block NSString *typeName;
    [self.expertGroups enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([key isEqualToString:obj[@"expertGroup"]]) {
            *stop = YES;
            typeName = obj[@"displayName"][@"zh_CN"];
        }
    }];
    return typeName;
}
- (void)loadExperGroups:(void (^)(NSArray *experGroups))completion{
    NSDictionary *param = @{@"keys":@"expertGroups"};
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *expertGroups = content[@"expertGroups"];
            self.expertGroups = [NSMutableArray new];
            [self.expertGroups addObjectsFromArray:expertGroups];
            completion ? completion(expertGroups):nil;
        }
        
    } failBlock:^(NSError *error) {
       
        
    }];
}
#pragma mark ========== 被踢下线 ==========
-(void)onKick{
    [self logout:nil];
}
#pragma mark ========== 保存更改过的用户信息 ==========
-(void)saveChangeUserInfo{
    if (self.curUserInfo) {
        YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
        NSDictionary *dic = [self.curUserInfo modelToJSONObject];
        [cache setObject:dic forKey:KUserModelCache];
    }
}
#pragma mark ========== team 相关 ==========
- (void)getTeamMember:(void(^)(BOOL isSuccess,NSArray *member))memberBlock{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamMemberCacheName];
    NSArray *teamMember = (NSArray *)[cache objectForKey:KTeamMemberCacheName];
    if (teamMember) {
        memberBlock ? memberBlock(YES,teamMember):nil;
    }else{
        memberBlock ? memberBlock(NO,nil):nil;
    }
}
- (void)setTeamMenber:(NSArray *)memberArray{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamMemberCacheName];
    
    [cache removeAllObjectsWithBlock:^{
         [cache setObject:memberArray forKey:KTeamMemberCacheName];
    }];
}
- (void)getTeamProduct:(void(^)(BOOL isSuccess,NSArray *member))productBlock{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamProductDict];
    NSArray *product = (NSArray *)[cache objectForKey:KTeamProductDict];
    if (product) {
        productBlock ? productBlock(YES,product):nil;
    }else{
        productBlock ? productBlock(NO,nil):nil;
    }
        
}
- (void)setTeamProduct:(NSArray *)teamProduct{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamProductDict];
    [cache removeAllObjectsWithBlock:^{
        [cache setObject:teamProduct forKey:KTeamProductDict];
    }];
}

+(NSDictionary *)getDeviceInfo{
    NSString *os_version =  [[UIDevice currentDevice] systemVersion];
    NSString *openUDID = [OpenUDID value];
    NSString *device_version = [NSString getCurrentDeviceModel];
    NSString *registrationId = [JPUSHService registrationID];
#if (TARGET_IPHONE_SIMULATOR)
    registrationId =@"123456789";
#endif
    return @{
            @"deviceId": openUDID,
            @"registrationId":registrationId,
            @"deviceOSVersion": os_version,
            @"deviceVersion":device_version,
    };
}

@end
