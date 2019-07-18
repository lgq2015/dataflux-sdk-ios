//
//  MoreRuleLinkVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class NotiRuleModel;
@interface MoreRuleLinkVC : RootViewController
@property (nonatomic, copy) void (^addRuleLinkBlock)(NotiRuleModel *ruleModel);

@property (nonatomic, strong) NotiRuleModel *sendModel;

@end

NS_ASSUME_NONNULL_END
