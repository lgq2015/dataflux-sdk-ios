//
//  SelectVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger, SelectStyle){
    SelectWeek,
    SelectIssueLevel,
    SelectIssueType,
    SelectIssueSource,
    SelectNotificationWay,
    SelectIssueOrigin,
};
NS_ASSUME_NONNULL_BEGIN
@class RuleModel;
@class NotiRuleModel;
@interface SelectVC : RootViewController
@property (nonatomic, copy) void (^selectBlock)(RuleModel *ruleModel);
@property (nonatomic, copy) void (^selectRuleBlock)(NotiRuleModel *ruleModel);

@property (nonatomic, strong) RuleModel *model;
@property (nonatomic, strong) NotiRuleModel *sendModel;

-(instancetype)initWithStyle:(SelectStyle)style;

@end

NS_ASSUME_NONNULL_END
