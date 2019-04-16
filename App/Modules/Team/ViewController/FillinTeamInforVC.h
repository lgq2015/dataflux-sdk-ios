//
//  FillinTeamInforVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "TeamFillConfige.h"

NS_ASSUME_NONNULL_BEGIN

@interface FillinTeamInforVC : RootViewController
@property (nonatomic, copy) void(^changeSuccess)(void);

@property (nonatomic, assign) NSInteger count;
@end

NS_ASSUME_NONNULL_END
