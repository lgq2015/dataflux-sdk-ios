//
//  MessageDetailVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class MineMessageModel;
@interface MessageDetailVC : RootViewController
@property (nonatomic, copy) void(^refreshTable)(void);
@property (nonatomic, strong) MineMessageModel *model;
@end

NS_ASSUME_NONNULL_END
