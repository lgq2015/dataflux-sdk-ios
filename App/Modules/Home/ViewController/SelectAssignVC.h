//
//  SelectAssignVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class MemberInfoModel;
@interface SelectAssignVC : RootViewController
@property (nonatomic, copy) void(^itemClick)(MemberInfoModel *model);
@property (nonatomic, copy) void(^disMissClick)(void);

@end

NS_ASSUME_NONNULL_END
