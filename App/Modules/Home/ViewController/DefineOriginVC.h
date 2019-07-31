//
//  DefineOriginVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefineOriginVC : RootViewController
@property (nonatomic, copy) void(^navBtnClick)(NSString *origin);

@end

NS_ASSUME_NONNULL_END
