//
//  IssueDetailsVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
@class IssueListViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface IssueDetailsVC : RootViewController
@property (nonatomic, strong) IssueListViewModel *model;
@property (nonatomic, copy) void(^updateAllClick)(void);
@property (nonatomic, copy) void(^calendarRefresh)(void);
@property (nonatomic, copy) void(^calendarLogRefresh)(void);

@end

NS_ASSUME_NONNULL_END
