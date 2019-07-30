//
//  SelectAssignVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectAssignVC : RootViewController
@property (nonatomic, copy) void(^itemClick)(NSString *assign);

@end

NS_ASSUME_NONNULL_END
