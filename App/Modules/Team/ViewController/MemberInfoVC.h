//
//  MemberInfoVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
@class MemberInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MemberInfoVC : RootViewController
@property (nonatomic, strong) MemberInfoModel *model;
@property (nonatomic, assign) BOOL isInfo;
@property (nonatomic, assign) BOOL isExpert;
@property (nonatomic, copy) void(^teamMemberRefresh)(void);

@property (nonatomic, strong) NSDictionary *expertDict;
@end

NS_ASSUME_NONNULL_END
