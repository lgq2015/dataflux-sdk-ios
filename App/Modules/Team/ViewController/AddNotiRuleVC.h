//
//  AddNotiRuleVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger, AddNotiRuleStyle){
    AddNotiRuleAdd,
    AddNotiRuleEdit,
    AddNotiRuleLookOver,
};
NS_ASSUME_NONNULL_BEGIN
@class NotiRuleModel;
@interface AddNotiRuleVC : RootViewController
@property (nonatomic, strong) NotiRuleModel *sendModel;
-(instancetype)initWithStyle:(AddNotiRuleStyle)style;
@end

NS_ASSUME_NONNULL_END
