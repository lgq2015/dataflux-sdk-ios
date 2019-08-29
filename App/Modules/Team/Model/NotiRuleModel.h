//
//  NotiRuleModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
#import "RuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotiRuleModel : JSONModel
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *createAccountId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, assign) BOOL appNotification;
@property (nonatomic, assign) BOOL smsNotification;
@property (nonatomic, assign) BOOL voiceNotification;
@property (nonatomic, assign) BOOL emailNotification;

@property (nonatomic, assign) BOOL customNotification;
@property (nonatomic, assign) BOOL dingtalkNotification;

@property (nonatomic, assign) BOOL subscribed;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSArray *dingtalkAddress;
@property (nonatomic, strong) NSArray *customAddress;
@property (nonatomic, strong) NSString *ruleId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *weekday;
@property (nonatomic, strong) RuleModel *rule;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat titleHeight;


@end

NS_ASSUME_NONNULL_END
