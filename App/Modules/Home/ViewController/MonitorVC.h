//
//  MonitorVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

typedef  NS_ENUM(NSUInteger,IssueType){
    IssueTypeAlarm,
    IssueTypeSecurity,
    IssueTypeExpense,
    IssueTypeOptimization,
    IssueTypeMisc,
};
NS_ASSUME_NONNULL_BEGIN

@interface MonitorVC : RootViewController
@property (nonatomic, strong) NSArray *dataSource;
- (id)initWithTitle:(NSString *)title andIssueType:(IssueType )type;

@end

NS_ASSUME_NONNULL_END
