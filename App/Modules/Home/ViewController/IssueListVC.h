//
//  IssueListVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface IssueListVC : RootViewController
- (void)reloadDataWithIssueType:(NSInteger)index viewType:(NSInteger)index refresh:(BOOL)refresh;
@end

NS_ASSUME_NONNULL_END
