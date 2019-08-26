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
#import "ZhugeIOLoginHelper.h"
#import "ZhugeIOUserDataHelper.h"
#import "MemberInfoModel.h"
#import "NSString+ErrorCode.h"
#import "BaseListReturnModel.h"
#import "UtilsConstManager.h"
#import "TeamAccountListModel.h"
#import "AuthTeamListModel.h"
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
- (void)addTeamSuccess:(void(^)(BOOL isSuccess))isSuccess{
    [[PWHttpEngine sharedInstance] getCurrentTeamInfoWithCallBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSError *error;
            self.teamModel = [[TeamInfoModel alloc]initWithDictionary:model.contentDict error:&error];
            if ([self.teamModel.type isEqualToString:@"singleAccount"]){
                setTeamState(PW_isPersonal);
            }else{
                setTeamState(PW_isTeam);
            }
            if (self.teamModel) {
                setPWDefaultTeamID(self.teamModel.teamID);
                YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
                NSDictionary *dic = [self.teamModel modelToJSONObject];
                [cache setObject:dic forKey:KTeamModelCache];
                if (isSuccess) {
                    isSuccess(YES);
                }
            }
            [kUserDefaults synchronize];
        }else{
            if (isSuccess) {
                isSuccess(NO);
            }
        }
    }];
}
-(void)registerWithParam:(NSDictionary *)params completion:(codeBlock)completion{
    NSMutableDictionary *param = [params mutableCopy];
    [param addEntriesFromDictionary:[self getDeviceInfo]];
    NSDictionary *data = @{@"data":param};

    [PWNetworking requsetWithUrl:PW_register withRequestType:NetworkPostType refreshRequest:NO cache:NO params:data progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            setXAuthToken(content[@"authAccessToken"]);
            [kUserDefaults synchronize];
            [self saveUserInfoLoginStateisChange:YES success:nil];
        }else
        {    [SVProgressHUD dismiss];
            [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
#pragma mark ========== 登录操作 ==========
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{
    if(loginType == UserLoginTypePwd){
      //密码登录
        [[PWHttpEngine sharedInstance] authPasswordLoginWithParam:params callBack:^(id response) {
            BaseReturnModel *model = response;
            if(model.isSuccess){
                if (completion) {
                    completion(YES,nil);
                }
                self.isLogined = YES;
                setXAuthToken(model.contentDict[@"authAccessToken"]);
                [kUserDefaults synchronize];
                [self saveUserInfoLoginStateisChange:YES success:nil];
                [[[[ZhugeIOLoginHelper new] eventLoginFail] eventLoginSuccess] track];
            }else{
                [SVProgressHUD dismiss];
                [iToast alertWithTitleCenter:NSLocalizedString(@"server.err.home.auth.passwordIncorrect", @"")];
                NSString *errorMsg = NSLocalizedString(model.errorCode, @"");
                [[[[ZhugeIOLoginHelper new] eventLoginFail] attrLoginFail:errorMsg] track];
            }
        }];
    }else{
      //验证码登录
        [[PWHttpEngine sharedInstance] authSmsLoginWithParam:params callBack:^(id response) {
            BaseReturnModel *model = response;
            if (model.isSuccess) {
              self.isLogined = YES;
              setXAuthToken(model.contentDict[@"authAccessToken"]);
             [kUserDefaults synchronize];
             [[[[[ZhugeIOLoginHelper new] eventInputGetVeryCode] attrSceneLogin] attrResultPass] track];
                BOOL isRegister = [model.contentDict[@"isRegister"] boolValue];
                if (isRegister) {
                    NSString *changePasswordToken = model.contentDict[@"changePasswordToken"];
                    if (completion) {
                        completion(YES, changePasswordToken);
                    }
                    [self saveUserInfoLoginStateisChange:YES success:nil];
                }
                [self saveUserInfoLoginStateisChange:YES success:nil];
                
                [[[[ZhugeIOLoginHelper new] eventLoginFail] eventLoginSuccess] track];
            }else{
                [SVProgressHUD dismiss];
                if (completion) {
                    completion(NO, @"");
                }
                [[[[[ZhugeIOLoginHelper new] eventInputGetVeryCode] attrSceneLogin] attrResultNoPass] track];
                [[[[ZhugeIOLoginHelper new] eventLoginFail] attrLoginFail:model.errorMsg] track];
                
                if ([model.errorCode isEqualToString:@"home.auth.tooManyIncorrectAttempts"]) {
                    NSString *time =[NSString stringWithFormat:@"%ld",[response longValueForKey:@"ttl" default:0]];
                    NSString *toast =[NSString stringWithFormat:model.errorMsg,time];
                    [SVProgressHUD showErrorWithStatus:toast];
                } else {
                    [SVProgressHUD showErrorWithStatus:[response[ERROR_CODE] toErrString]];
                }
            }
        }];
    }

}
#pragma mark ========== 储存用户信息 ==========
-(void)saveUserInfoLoginStateisChange:(BOOL)change success:(void(^)(BOOL isSuccess))isSuccess{
    __block BOOL isUserSuccess,isTeamSuccess = NO;
    WeakSelf
    dispatch_queue_t queueT = dispatch_queue_create("group.queue", DISPATCH_QUEUE_CONCURRENT);//一个并发队列
    dispatch_group_t grpupT = dispatch_group_create();//一个线程组

    dispatch_group_async(grpupT, queueT,^{
        dispatch_group_enter(grpupT);
        [[PWHttpEngine sharedInstance] getCurrentAccountInfoWithCallBack:^(id response) {
            BaseReturnModel *model = response;
            if(model.isSuccess){
               isUserSuccess = YES;
                NSError *error;
                weakSelf.curUserInfo = [[CurrentUserModel alloc]initWithDictionary:model.contentDict error:&error];
                if (weakSelf.curUserInfo) {
                    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
                    NSDictionary *dic = [weakSelf.curUserInfo modelToJSONObject];
                    [cache setObject:dic forKey:KUserModelCache];
                    setPWUserID(weakSelf.curUserInfo.userID);
                    [kUserDefaults synchronize];
                    [[ZhugeIOUserDataHelper new] bindUserData:weakSelf.curUserInfo];
                    dispatch_group_leave(grpupT);
                }else{
                    dispatch_group_leave(grpupT);
                }
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
                dispatch_group_leave(grpupT);
            }
        }];
    });

    dispatch_group_async(grpupT, queueT, ^{
        dispatch_group_enter(grpupT);
        [[PWHttpEngine sharedInstance] getCurrentTeamInfoWithCallBack:^(id response) {
            BaseReturnModel *model = response;
            if(model.isSuccess){
                isTeamSuccess = YES;
                NSError *error;
                weakSelf.teamModel = [[TeamInfoModel alloc]initWithDictionary:model.contentDict error:&error];
                if (weakSelf.teamModel) {
                    setPWDefaultTeamID(self.teamModel.teamID);
                    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
                    NSDictionary *dic = [weakSelf.teamModel modelToJSONObject];
                    [cache setObject:dic forKey:KTeamModelCache];
                }
                if ([self.teamModel.type isEqualToString:@"singleAccount"]){
                    setTeamState(PW_isPersonal);
                }else{
                    setTeamState(PW_isTeam);
                }
                [kUserDefaults synchronize];
                dispatch_group_leave(grpupT);
            }else{
                dispatch_group_leave(grpupT);
            }
        }];
    });
    dispatch_group_notify(grpupT, queueT, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if( isTeamSuccess && isUserSuccess){
                if(change){
                    [SVProgressHUD dismiss];
                    KPostNotification(KNotificationLoginStateChange, @YES);
                    //存储的团队列表、团队情报数、ISPs都和当前账号有关系，所以请求成功做处理
                    [weakSelf requestMemberList:nil];
                    [weakSelf requestTeamIssueCount:nil];
                    [[UtilsConstManager sharedUtilsConstManager] getAllUtilsConst];
                    if ([weakSelf getTeamAdminId].length == 0) {
                        [weakSelf loadTeamMember];
                    }
                }
                isSuccess? isSuccess(YES):nil;
            }else{
                isSuccess? isSuccess(NO):nil;
                [iToast alertWithTitleCenter:NSLocalizedString(@"local.err.netWorkError", @"")];
            }
        });

    });
}
-(void)judgeIsHaveTeam:(void(^)(BOOL isSuccess,NSDictionary *content))isHave{
    [[PWHttpEngine sharedInstance]getCurrentTeamInfoWithCallBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess) {
            NSError *error;
            self.teamModel = [[TeamInfoModel alloc]initWithDictionary:model.contentDict error:&error];
            setPWDefaultTeamID(self.teamModel.teamID);
            if ([self.teamModel.type isEqualToString:@"singleAccount"]){
                setTeamState(PW_isPersonal);
                isHave? isHave(NO,nil):nil;
            }else{
                setTeamState(PW_isTeam);
                isHave? isHave(YES,model.contentDict):nil;
            }
            [kUserDefaults synchronize];
        }else{
                isHave?isHave(NO,nil):nil;
            [iToast alertWithTitleCenter:model.errorMsg];
        }
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
        });
    });
  
    [kUserDefaults removeObjectForKey:PWLastTime];
    [kUserDefaults removeObjectForKey:PWTeamState];
    [kUserDefaults removeObjectForKey:XAuthToken];

    self.curUserInfo = nil;
    self.teamModel = nil;
    self.isLogined = NO;

    [[InformationStatusReadManager sharedInstance] shutDown];
    [[IssueChatDataManager sharedInstance] shutDown];
    [[IssueListManger sharedIssueListManger] shutDown];
    [[HandBookManager sharedInstance] shutDown];
    [[PWSocketManager sharedPWSocketManager] shutDown];
    [[IssueSourceManger sharedIssueSourceManger] logout];


    //移除缓存
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    YYCache *cacheteam = [[YYCache alloc]initWithName:KTeamCacheName];
    YYCache *cacheTeamList = [[YYCache alloc]initWithName:KTeamListCacheName];
    YYCache *cacheLastFetchTime = [[YYCache alloc]initWithName:KTeamLastFetchTime];
    [cache removeAllObjects];
    [cacheLastFetchTime removeAllObjects];
    [cacheteam removeAllObjects];
    [cacheTeamList removeAllObjects];
    KPostNotification(KNotificationLoginStateChange, @NO);
    if (completion){
        completion(YES,nil);
    }
}
-(CurrentUserModel *)getCurrentUserModel{
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    NSDictionary * userDic = (NSDictionary *)[cache objectForKey:KUserModelCache];
    if (userDic) {
       CurrentUserModel *model= [CurrentUserModel modelWithJSON:userDic];
        return model;
    }
    return nil;
}

#pragma mark ========== 加载缓存的用户信息 ==========
-(BOOL)loadUserInfo{
    YYCache *cache = [[YYCache alloc] initWithName:KUserCacheName];
    YYCache *cacheteam = [[YYCache alloc] initWithName:KTeamCacheName];
    NSDictionary *userDic = (NSDictionary *) [cache objectForKey:KUserModelCache];
    NSDictionary *teamDic = (NSDictionary *) [cacheteam objectForKey:KTeamModelCache];
    //旧数据错误数据过滤
    if([getPWUserID containsString:@"-"]){
        if ([getTeamState isEqualToString:PW_isTeam]) {
            if (userDic && teamDic) {
                self.curUserInfo = [CurrentUserModel modelWithJSON:userDic];
                self.teamModel = [TeamInfoModel modelWithJSON:teamDic];
                return YES;
            }
        } else {
            if (userDic) {
                self.curUserInfo = [CurrentUserModel modelWithJSON:userDic];
                return YES;
            }
        }
    }
    return NO;
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
- (TeamInfoModel *)getTeamModel{
    if (self.teamModel){
        return self.teamModel;
    }
    YYCache *cacheteam = [[YYCache alloc]initWithName:KTeamCacheName];
    NSDictionary * teamDic = (NSDictionary *)[cacheteam objectForKey:KTeamModelCache];
    self.teamModel  = [TeamInfoModel modelWithJSON:teamDic];
    return self.teamModel;
}
- (void)getTeamMember:(void(^)(BOOL isSuccess,NSArray *member))memberBlock{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    NSArray *teamMember = (NSArray *)[cache objectForKey:KTeamMemberCacheName];
    if (teamMember) {
        memberBlock ? memberBlock(YES,teamMember):nil;
    }else{
        memberBlock ? memberBlock(NO,nil):nil;
    }
}
#pragma mark ========== 团队管理员ID ==========
- (NSString *)getTeamAdminId{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    NSString *memberId =(NSString *)[cache objectForKey:KTeamAdminId];
    return memberId;
}
- (void)setTeamAdminIdWithId:(NSString *)memberId{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    [cache removeObjectForKey:KTeamAdminId];
    [cache setObject:memberId forKey:KTeamAdminId];
}
#pragma mark ========== 团队成员相关 ==========
- (void)setTeamMember:(NSArray *)memberArray{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    [cache removeObjectForKey:KTeamMemberCacheName];
    [cache setObject:memberArray forKey:KTeamMemberCacheName];
}
- (void)getTeamMenberWithId:(NSString *)memberId memberBlock:(void(^)(MemberInfoModel *member))memberBlock{
    if (memberId==nil || [memberId isEqualToString:@""]) {
        memberBlock? memberBlock(nil):nil;
    }
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    NSArray *teamMember = (NSArray *)[cache objectForKey:KTeamMemberCacheName];
    __block MemberInfoModel *memberDict = nil;
    if (teamMember) {
        [teamMember enumerateObjectsUsingBlock:^(MemberInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if( [obj.memberID  isEqualToString:memberId]){
                    memberDict = [obj copy];
                    *stop = YES;
                }
        }];
        memberBlock? memberBlock(memberDict):nil;
    }else{
        [[PWHttpEngine sharedInstance] getCurrentTeamMemberListWithCallBack:^(id response) {
            TeamAccountListModel *model = response;
            if(model.isSuccess){
                [userManager setTeamMember:model.list];
                [model.list enumerateObjectsUsingBlock:^(MemberInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if( [obj.memberID  isEqualToString:memberId]){
                            memberDict = [obj copy];
                            *stop = YES;
                        }
                }];
                memberBlock? memberBlock(memberDict):nil;
            }else{
                memberBlock? memberBlock(nil):nil;
            }
        }];
    }
}
-(void)loadTeamMember{
    [[PWHttpEngine sharedInstance] getCurrentTeamMemberListWithCallBack:^(id response) {
        TeamAccountListModel *model = response;
        if(model.isSuccess){
            [userManager setTeamMember:model.list];
            [[model.list copy] enumerateObjectsUsingBlock:^(MemberInfoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.isAdmin) {
                    [userManager setTeamAdminIdWithId:model.memberID];
                    *stop = YES;
                }
            }];
        }
    }];
}
#pragma mark ========== 团队权益 ==========
- (void)setTeamProduct:(NSDictionary *)teamProduct{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    [cache removeObjectForKey:KTeamProductDict];
    [cache setObject:teamProduct forKey:KTeamProductDict];
}
- (void)getTeamProduct:(void(^)(BOOL isSuccess,NSDictionary *product))productBlock{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamCacheName];
    NSDictionary *product = (NSDictionary *)[cache objectForKey:KTeamProductDict];
    if (product) {
        productBlock ? productBlock(YES,product):nil;
    }else{
        productBlock ? productBlock(NO,nil):nil;
    }
}
#pragma mark ========== 团队列表===============
- (void)setAuthTeamList:(NSArray *)teamList{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamListCacheName];
    [cache removeObjectForKey:kAuthTeamListDict];
    [cache setObject:teamList forKey:kAuthTeamListDict];
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
            //更新teammodel缓存
            YYCache *cacheteam = [[YYCache alloc]initWithName:KTeamCacheName];
            NSDictionary *dic = [model modelToJSONObject];
            [cacheteam removeObjectForKey:KTeamModelCache];
            [cacheteam setObject:dic forKey:KTeamModelCache];
            *stop = YES;
        }
    }];
}
#pragma mark ========== 团队列表 ==========
- (void)requestMemberList:(void(^)(BOOL isFinished))isFinished{
    [[PWHttpEngine sharedInstance] getAuthTeamListCallBack:^(id response) {
        AuthTeamListModel *model = response;
        if (model.isSuccess && model.list.count !=0) {
            [userManager setAuthTeamList:model.list];
            isFinished? isFinished(YES):nil;
        }else{
            isFinished? isFinished(NO):nil;
        }
    }];
}
//团队活跃情报树
- (void)requestTeamIssueCount:(void(^)(bool isFinished))completeBlock{
    [[PWHttpEngine sharedInstance] getTeamIssueCountCallBack:^(id response) {
        BaseReturnModel *model = response;
        if (model.isSuccess && model.contentDict.allKeys.count>0) {
            [self setAuthTeamIssueCount:model.contentDict];
            completeBlock? completeBlock(YES):nil;
        }else{
            completeBlock? completeBlock(NO):nil;
        }
    }];
}
-(NSDictionary *)getDeviceInfo{
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
#pragma mark ========== 日历页面视图类型 ==========
-(CalendarViewType)getCurrentCalendarViewType{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
    BOOL isContain= [cache containsObjectForKey:KCurrentCalendarViewType];
    if (isContain) {
        NSNumber *currentType = (NSNumber *)[cache objectForKey:KCurrentCalendarViewType];
        return (CalendarViewType)[currentType integerValue];
    }else{
        return CalendarViewTypeGeneral;
    }
}
-(void)setCurrentIssueSortType:(CalendarViewType)type{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
    [cache removeObjectForKey:KCurrentCalendarViewType];
    [cache setObject:[NSNumber numberWithInteger:(NSInteger)type] forKey:KCurrentCalendarViewType];
}
@end
