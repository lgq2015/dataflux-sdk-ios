//
//  ExpertsSuggestVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpertsSuggestVC : RootViewController
@property (nonatomic, copy) NSString *issueid;
@property (nonatomic, strong) NSMutableArray *expertGroups;

@end

NS_ASSUME_NONNULL_END
