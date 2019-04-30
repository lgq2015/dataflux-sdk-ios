//
//  ZTCreateTeamVC.h
//  App
//
//  Created by tao on 2019/4/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "ZTCreateTeamConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTCreateTeamVC : RootViewController
@property (nonatomic, copy) void(^changeSuccess)(void);

@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
