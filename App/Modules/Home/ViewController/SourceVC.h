//
//  SourceVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "PWInfoSourceModel.h"


@interface SourceVC : RootViewController
@property (nonatomic, assign) SourceType type;
@property (nonatomic, strong) PWInfoSourceModel *model;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) void(^RefreshClick)(void);
@end


