//
//  ChooseAddressVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAddressVC : RootViewController
@property (nonatomic, copy) void(^itemClick)(NSString *text);
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentProvince;
@end

NS_ASSUME_NONNULL_END
