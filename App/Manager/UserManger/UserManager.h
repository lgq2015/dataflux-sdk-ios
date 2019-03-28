//
//  UserManager.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentUserModel.h"
typedef NS_ENUM(NSInteger, UserLoginType){
    UserLoginTypeVerificationCode= 0,//未知
    UserLoginTypePwd,///账号登录
};
typedef NS_ENUM(NSInteger, CodeStatus){
    CodeStatusSuccess= 0,//未知
    CodeStatusNeedImgCode,///账号登录
    CodeStatusFaile,
};
typedef NS_ENUM(NSInteger, CodeType){
    CodeTypeCode= 0,//未知
    CodeTypeImg,//
};
typedef void (^loginBlock)(BOOL success, NSString * des);
typedef void (^codeBlock) (CodeStatus status, NSString * des);
@class UserInfo,CurrentUserModel,TeamInfoModel;
#define isLogin [UserManager sharedUserManager].isLogined
#define curUser [UserManager sharedUserManager].curUserInfo
#define userManager [UserManager sharedUserManager]
@interface UserManager : NSObject

//单例
SINGLETON_FOR_HEADER(UserManager)

+ (NSDictionary *)getDeviceInfo;

//当前用户
@property (nonatomic, strong) CurrentUserModel *curUserInfo;
@property (nonatomic, strong) TeamInfoModel *teamModel;
@property (nonatomic, assign) UserLoginType loginType;
@property (nonatomic, strong) NSMutableArray *expertGroups;
@property (nonatomic, assign) BOOL isLogined;
/**
 获取验证码
 
 @param params 参数，手机和账号登录需要
 @param completion 回调
 */
-(void)getVerificationCodeType:(CodeType)codeType WithParams:(NSDictionary *)params completion:(codeBlock)completion;

/**
 带参登录
 
 @param loginType 登录方式 密码 验证码
 @param params 参数，手机和账号登录需要
 @param completion 回调
 */
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion;
/**
 自动登录
 
 @param completion 回调
 */
-(void)autoLoginToServer:(loginBlock)completion;

/**
 退出登录
 
 @param completion 回调
 */
- (void)logout:(loginBlock)completion;

/**
 加载缓存用户数据
 
 @return 是否成功
 */
-(BOOL)loadUserInfo;
-(void)saveUserInfoLoginStateisChange:(BOOL)change success:(void(^)(BOOL isSuccess))isSuccess;
//-(void)judgeIsHaveTeam:(void(^)(BOOL isHave, NSDictionary *content))isHave;
- (void)addTeamSuccess:(void(^)(BOOL isSuccess))isSuccess;
/**
 更改用户信息后需要重新请求
 */
-(void)saveChangeUserInfo;
/**
 获取专家名
 */
- (void)getExpertNameByKey:(NSString *)key name:(void(^)(NSString *name))name;
/**
    获取team成员
 */
- (void)getTeamMember:(void(^)(BOOL isSuccess,NSArray *member))memberBlock;
/**
    team成员缓存
 */
- (void)setTeamMenber:(NSArray *)memberArray;
/**
    获取teamProduct 缓存
 */
- (void)getTeamProduct:(void(^)(BOOL isSuccess,NSArray *member))productBlock;
/**
   teamProduct 缓存
 */
- (void)setTeamProduct:(NSArray *)teamProduct;
/**
   判断是否有team
 */
-(void)judgeIsHaveTeam:(void(^)(BOOL isHave,NSDictionary *content))isHave;

-(void)onKick;
@end
