//
//  SelectConditionVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
@class RuleModel;
NS_ASSUME_NONNULL_BEGIN

@interface SelectConditionVC : RootViewController
@property (nonatomic, strong) RuleModel *model;
@property (nonatomic, copy) void (^SelectConditionBlock)(RuleModel *ruleModel);

@end

NS_ASSUME_NONNULL_END
