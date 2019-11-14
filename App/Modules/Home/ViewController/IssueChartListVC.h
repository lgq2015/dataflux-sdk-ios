//
//  IssueChartListVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/11/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "IssueListManger.h"

@class ClassifyModel;
NS_ASSUME_NONNULL_BEGIN

@interface IssueChartListVC : RootViewController
@property (nonatomic, strong) ClassifyModel *model;
@property (nonatomic, assign) IssueLevel level;
@end

NS_ASSUME_NONNULL_END
