//
//  AddIssueVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
@class IssueListViewModel;
@interface AddIssueVC : RootViewController
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) IssueListViewModel *parentModel;
@property (nonatomic, copy) void(^refresh)(void);

@end


