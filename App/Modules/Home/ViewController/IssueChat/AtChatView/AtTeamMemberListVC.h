//
//  AtTeamMemberListVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AtTeamMemberListVC : RootViewController
@property (nonatomic, copy) void(^chooseMembers)(NSArray *members);

@end

NS_ASSUME_NONNULL_END
