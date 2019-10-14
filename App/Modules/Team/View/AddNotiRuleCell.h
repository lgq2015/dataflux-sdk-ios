//
//  AddNotiRuleCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AddNotiRuleModel;
@interface AddNotiRuleCell : UITableViewCell
@property (nonatomic, strong) AddNotiRuleModel *model;
@property (nonatomic, copy) void (^ruleNameClick)(NSString *ruleName);
@property (nonatomic, strong) UITextField *subTf;
@property (nonatomic, assign) BOOL isTF;
-(void)hideArrow;
@end

NS_ASSUME_NONNULL_END
