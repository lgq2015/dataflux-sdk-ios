//
//  IssueListVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "SelectObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueListVC : RootViewController
- (void)reloadDataWithSelectObject:(nullable SelectObject *)sel refresh:(BOOL)refresh;
@end

NS_ASSUME_NONNULL_END
