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
#import "IssueChatDataManager.h"

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
                        setPWDefaultTeamID(self.teamModel.teamID);
                        YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
                        NSDictionary *dic = [self.teamModel modelToJSONObject];
                        [cache setObject:dic forKey:KTeamModelCache];
                        if (isSuccess) {
                            isSuccess(YES);
                        }
                    }
                    if ([self.teamModel.type isEqualToString:@"singleAccount"]){
                        setTeamState(PW_isPersonal);
                    }else{
                        setTeamState(PW_isTeam);
                    }
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
             [iToast alertWithTitleCenter:@"账号或密码错误"];
                
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
            [error errorToast];
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
                if([response[ERROR_CODE] isEqualToString:@"home.auth.tooManyIncorrectAttempts"]){
                    NSString *toast = [NSString stringWithFormat:@"您尝试的错误次数过多，请 %lds 后再尝试",(long)[response longValueForKey:@"ttl" default:0]];
                    [SVProgressHUD showErrorWithStatus:toast];
                }else{
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(response[ERROR_CODE], @"")];
                }
               
            }
            
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (completion) {
                completion(NO,@"");
            }
            [error errorToast];

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
                    [kUserDefaults synchronize];
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
                NSDictionary *content =PWSafeDictionaryVal(response, @"content");
                if (content.allKeys.count>0) {
                    NSError *error;
                    self.teamModel = [[TeamInfoModel alloc]initWithDictionary:content error:&error];
                    if (self.teamModel) {
                        setPWDefaultTeamID(self.teamModel.teamID);
                        YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
                        NSDictionary *dic = [self.teamModel modelToJSONObject];
                        [cache setObject:dic forKey:KTeamModelCache];
                    }
                    if ([self.teamModel.type isEqualToString:@"singleAccount"]){
                        setTeamState(PW_isPersonal);
                    }else{
                        setTeamState(PW_isTeam);
                    }
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
                isSuccess? isSuccess(YES):nil;
            }else{
                isSuccess? isSuccess(NO):nil;
                [iToast alertWithTitleCenter:@"网络异常"];
            }
        });
        
    });
    [self loadExperGroups:nil];
    [self requestMemberList:NO complete:nil];
    [self requestTeamIssueCount];
}
-(void)judgeIsHaveTeam:(void(^)(BOOL isSuccess,NSDictionary *content))isHave{
    [PWNetworking requsetHasTokenWithUrl:PW_CurrentTeam withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content =PWSafeDictionaryVal(response, @"content");
            if (content.allKeys.count>0) {
                NSError *error;
                self.teamModel = [[TeamInfoModel alloc]initWithDictionary:content error:&error];
                setPWDefaultTeamID(self.teamModel.teamID);
                if ([self.teamModel.type isEqualToString:@"singleAccount"]){
                    setTeamState(PW_isPersonal);
                    if (isHave){
                        isHave(NO,nil);
                    }
                }else{
                    setTeamState(PW_isTeam);
                    if (isHave){
                        isHave(YES,content);
                    }
                }
                [kUserDefaults synchronize];
            }
        }else{
            if (isHave){
                isHave(NO,nil);
            }
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {
        if (isHave){
            isHave(NO,nil);
        }
        [error errorToast];
    }];
}
- (void)reloadTeamInfo
{
    [self addTeamSuccess:^(BOOL isSuccess) {
        
    }];
}
#pragma mark ========== 退出登录 ==========
- (void)logout:(void (^)(BOOL, NSString *))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            //            [[UIApplication sharedApplication] endBackgroundTask:taskID];
        });
    });
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogout object:nil];//被踢下线通知用户退出直播间
    [kUserDefaults removeObjectForKey:PWLastTime];
    [kUserDefaults removeObjectForKey:PWTeamState];
    [kUserDefaults removeObjectForKey:XAuthToken];

    self.curUserInfo = nil;
    self.teamModel = nil;
    self.isLogined = NO;

//    [[IssueListManger sharedIssueListManger] clearAllIssueData];

    [[InformationStatusReadManager sharedInstance] shutDown];
    [[IssueChatDataManager sharedInstance] shutDown];
    [[IssueListManger sharedIssueListManger] shutDown];
    [[HandBookManager sharedInstance] shutDown];
    [[PWSocketManager sharedPWSocketManager] shutDown];
    [[IssueSourceManger sharedIssueSourceManger] logout];
    [[IssueListManger sharedIssueListManger] createData];


    //移除缓存
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    YYCache *cacheteam = [[YYCache alloc]initWithName:KTeamCacheName];
    YYCache *cacheTeamList = [[YYCache alloc]initWithName:KTeamListCacheName];
    [cache removeAllObjects];
    [cacheteam removeObjectForKey:KTeamModelCache];
    [cacheteam removeObjectForKey:kAuthTeamIssueCountDict];
    [cacheTeamList removeObjectForKey:kAuthTeamListDict];
    KPostNotification(KNotificationLoginStateChange, @NO);
}

//-(void)autoLoginToServer:(loginBlock)completion{
//    
//}
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
//    YYCache *cache = [[YYCache alloc]initWithName:KTeamMemberCacheName];
//    NSArray *teamMember = (NSArray *)[cache objectForKey:KTeamMemberCacheName];
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
- (void)getissueSourceNameByKey:(NSString *)key name:(void(^)(NSString *name))name{
    NSString *nameStr = [self privateGetissueSourceNameByKey:key];
    if ([nameStr isEqualToString:@""]) {
        [self loadIssueSourceName:^(NSArray *experGroups) {
            name? name([self privateGetissueSourceNameByKey:key]):nil;
        }];
    }else{
         name? name([self privateGetissueSourceNameByKey:key]):nil;
    }
}
- (NSString *)privateGetissueSourceNameByKey:(NSString *)key{
    YYCache *cache = [[YYCache alloc]initWithName:KUtilsConstCacheName];
    NSArray *issueSourceName = (NSArray *)[cache objectForKey:KIssueSourceNameModelCache];
    __block NSString *typeName = @"";
    if(issueSourceName.count>0){
        [issueSourceName enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([key isEqualToString:[obj stringValueForKey:@"provider" default:@""]]) {
                NSDictionary *displayName = PWSafeDictionaryVal(obj, @"displayName");
                typeName = [displayName stringValueForKey:@"zh_CN" default:@""];
            }
        }];
    }
    return typeName;
}
- (void)loadIssueSourceName:(void (^)(NSArray *IssueSourceNames))completion{
    NSDictionary *param = @{@"keys":@"issueSourceProvider"};
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            NSArray *IssueSourceName =PWSafeArrayVal(content, @"issueSourceProvider");
            YYCache *cache = [[YYCache alloc]initWithName:KUtilsConstCacheName];
            [cache setObject:IssueSourceName forKey:KIssueSourceNameModelCache];

            completion ? completion(IssueSourceName):nil;
        }else{
            completion ? completion(nil):nil;
        }
        
    } failBlock:^(NSError *error) {
        completion ? completion(nil):nil;
        [error errorToast];
    }];
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
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            NSArray *expertGroups =PWSafeArrayVal(content, @"expertGroups");
            self.expertGroups = [NSMutableArray new];
            [self.expertGroups addObjectsFromArray:expertGroups];
            completion ? completion(expertGroups):nil;
        }else{
           completion ? completion(nil):nil;
        }
        
    } failBlock:^(NSError *error) {
        completion ? completion(nil):nil;
        [error errorToast];
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
#pragma mark ========== 团队列表相关 ==========
- (void)getTeamMember:(void(^)(BOOL isSuccess,NSArray *member))memberBlock{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    NSArray *teamMember = (NSArray *)[cache objectForKey:KTeamMemberCacheName];
    if (teamMember) {
        memberBlock ? memberBlock(YES,teamMember):nil;
    }else{
        memberBlock ? memberBlock(NO,nil):nil;
    }
}
- (void)setTeamMember:(NSArray *)memberArray{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    [cache removeObjectForKey:KTeamMemberCacheName];
    [cache setObject:memberArray forKey:KTeamMemberCacheName];
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
- (void)getTeamMenberWithId:(NSString *)memberId memberBlock:(void(^)(NSDictionary *member))memberBlock{
    if (memberId==nil || [memberId isEqualToString:@""]) {
        memberBlock? memberBlock(nil):nil;
    }
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    NSArray *teamMember = (NSArray *)[cache objectForKey:KTeamMemberCacheName];
   __block NSDictionary *memberDict = nil;
    if (teamMember) {
        [teamMember enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSDictionary.class]) {
                if( [[obj stringValueForKey:@"id" default:@""] isEqualToString:memberId]){
                    memberDict = obj;
                    *stop = YES;
                }
            }
        }];
        memberBlock? memberBlock(memberDict):nil;
    }else{
        [PWNetworking requsetHasTokenWithUrl:PW_TeamAccount withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSArray *content =PWSafeArrayVal(response, @"content");
                [userManager setTeamMember:content];
                [content enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:NSDictionary.class]) {
                        if( [[obj stringValueForKey:@"id" default:@""] isEqualToString:memberId]){
                            memberDict = obj;
                            *stop = YES;
                        }
                    }
                }];
                memberBlock? memberBlock(memberDict):nil;
            }else{
                memberBlock? memberBlock(nil):nil;
            }
        } failBlock:^(NSError *error) {
            memberBlock? memberBlock(nil):nil;
        }];
    }
   
}
#pragma mark ========== 团队列表===============
- (void)setAuthTeamList:(NSArray *)teamList{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamListCacheName];
    [cache removeObjectForKey:kAuthTeamListDict];
    [cache setObject:teamList forKey:kAuthTeamListDict];
}
- (void)getAuthTeamList:(void(^)(id obj))resultBlock{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamListCacheName];
    [cache objectForKey:kAuthTeamListDict withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        resultBlock(object);
    }];
}
- (NSArray *)getAuthTeamList{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamListCacheName];
    NSArray *lists = (NSArray *)[cache objectForKey:kAuthTeamListDict];
    return lists;
}
- (void)setAuthTeamIssueCount:(NSDictionary *)dic{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamListCacheName];
    [cache removeObjectForKey:kAuthTeamIssueCountDict];
    [cache setObject:dic forKey:kAuthTeamIssueCountDict];
}
- (NSDictionary *)getAuthTeamIssueCount{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamListCacheName];
    NSDictionary *dic = (NSDictionary *)[cache objectForKey:kAuthTeamIssueCountDict];
    return dic;
}

#pragma mark ========== 更新默认团队===============
- (void)updateTeamModelWithGroupID:(NSString *)groupID{
    NSArray *lists = [self getAuthTeamList];
    [lists enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TeamInfoModel *model = (TeamInfoModel *)obj;
        if ([model.teamID isEqualToString:groupID]){
            self.teamModel = model;
            //更新teammodel缓存
            YYCache *cacheteam = [[YYCache alloc]initWithName:KTeamCacheName];
            NSDictionary *dic = [model modelToJSONObject];
            [cacheteam removeObjectForKey:KTeamModelCache];
            [cacheteam setObject:dic forKey:KTeamModelCache withBlock:nil];
            *stop = YES;
        }
    }];
}
#pragma mark ========== 常用请求==========
//团队列表
- (void)requestMemberList:(BOOL)isShowProgress complete:(void(^)(BOOL isFinished))isFinished{
    if (isShowProgress){
        [SVProgressHUD show];
    }
    NSMutableArray *teamlists = [NSMutableArray array];
    [PWNetworking requsetHasTokenWithUrl:PW_AuthTeamList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count == 0 || content == nil){
                if (isFinished){
                    isFinished(NO);
                }
                return ;
            }
            for(NSDictionary *dic in content){
                NSError * error = nil;
                TeamInfoModel *model = [[TeamInfoModel alloc] initWithDictionary:dic error:&error];
                [teamlists addObject:model];
            }
            //缓存
            [userManager setAuthTeamList:teamlists];
            //回调
            if (isFinished){
                isFinished(YES);
            }
            if (isShowProgress){
                [SVProgressHUD dismiss];
            }
        }else{
            //回调
            if (isFinished){
                isFinished(NO);
            }
            if (isShowProgress){
                [SVProgressHUD dismiss];
            }
            if (isShowProgress){
                [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
            }
        }
    } failBlock:^(NSError *error) {
        if (isFinished){
            isFinished(NO);
        }
    }];
}
//团队活跃情报树
- (void)requestTeamIssueCount{
    NSMutableArray *teamlists = [NSMutableArray array];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamIssueCount withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            if (content.allKeys.count == 0 || content == nil){
                return ;
            }
            //缓存团队列表红点
            [self setAuthTeamIssueCount:content];
        }else{
            
        }
    } failBlock:^(NSError *error) {
    }];
}
- (void)getIssueStateAndLevelByKey:(NSString *)key displayName:(void(^)(NSString *displayName))displayName{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamProductDict];
//    [cache removeAllObjectsWithBlock:^{
//        [cache setObject:teamProduct forKey:KTeamProductDict];
//    }];
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
