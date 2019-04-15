//
//  IssueChatVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
@class IssueListViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface IssueChatVC : RootViewController
@property (nonatomic, strong) NSDictionary *infoDetailDict;
@property (nonatomic, strong) IssueListViewModel *model;

@end

NS_ASSUME_NONNULL_END
