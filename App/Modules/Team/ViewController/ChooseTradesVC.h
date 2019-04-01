//
//  ChooseTradesVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseTradesVC : RootViewController
@property (nonatomic, copy) void(^itemClick)(NSString *trades);
@property (nonatomic, copy) NSString *trades;
@end

NS_ASSUME_NONNULL_END
