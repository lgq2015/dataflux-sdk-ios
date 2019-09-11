//
//  AddNotiRuleVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger, AddNotiRuleViewStyle){
    AddNotiRuleAdd,
    AddNotiRuleEdit,
    AddNotiRuleLookOver,
};

NS_ASSUME_NONNULL_BEGIN
@class NotiRuleModel;
@interface AddNotiRuleVC : RootViewController
@property (nonatomic, strong) NotiRuleModel *sendModel;
@property (nonatomic, copy) void(^refreshList)(void);
-(instancetype)initWithStyle:(AddNotiRuleViewStyle)style ruleStyle:(NotiRuleStyle)ruleStyle;
@end

NS_ASSUME_NONNULL_END
