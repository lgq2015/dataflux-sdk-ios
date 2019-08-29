//
//  NotiRuleCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
NS_ASSUME_NONNULL_BEGIN
@class NotiRuleModel;
@interface NotiRuleCell : MGSwipeTableCell
@property (nonatomic, assign) NotiRuleStyle ruleStyle;

@property (nonatomic, strong) NotiRuleModel *model;
@end

NS_ASSUME_NONNULL_END
