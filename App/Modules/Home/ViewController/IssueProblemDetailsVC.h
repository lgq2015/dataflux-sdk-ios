//
//  IssueProblemDetailsVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueDetailRootVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueProblemDetailsVC : IssueDetailRootVC
@property (nonatomic, copy) void(^refreshClick)(void);

@end

NS_ASSUME_NONNULL_END
