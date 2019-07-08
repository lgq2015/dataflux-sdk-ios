//
//  ChooseAssignVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/6/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "MemberInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
@class IssueListViewModel;
@interface ChooseAssignVC : RootViewController
@property (nonatomic, copy) void(^MemberInfo)(MemberInfoModel *model);

@property (nonatomic, assign) NSString *assignID;
@property (nonatomic, strong) IssueListViewModel *model;
@end

NS_ASSUME_NONNULL_END
