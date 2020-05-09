//
//  CreateSuccessVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateSuccessVC : RootViewController
@property (nonatomic, copy) void(^btnClick)(void);
@property (nonatomic, copy) NSString *groupName;
//是否是补充团队信息
@property (nonatomic, assign)BOOL isSupplement;
@end

NS_ASSUME_NONNULL_END