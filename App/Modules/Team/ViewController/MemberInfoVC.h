//
//  MemberInfoVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger, PWMemberViewType) {
    PWMemberViewTypeTeamMember = 1,
    PWMemberViewTypeMe,
    PWMemberViewTypeExpert,
    PWMemberViewTypeTrans,
    PWMemberViewTypeSpecialist,
};
@class MemberInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MemberInfoVC : RootViewController
@property (nonatomic, strong) MemberInfoModel *model;
//成员ID
@property (nonatomic, copy)NSString *memberID;
//备注名称
@property (nonatomic, copy)NSString *noteName;
@property (nonatomic, assign) PWMemberViewType type;
@property (nonatomic, copy) void(^teamMemberRefresh)(void);
@property (nonatomic, copy) void(^memberBeizhuChangeBlock)(NSString *name);
@property (nonatomic, strong) NSDictionary *expertDict;
@end

NS_ASSUME_NONNULL_END
