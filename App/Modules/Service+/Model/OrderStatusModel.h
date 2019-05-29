//
//  OrderStatusModel.h
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderStatusModel : JSONModel
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *commodityPackageName;
@end

NS_ASSUME_NONNULL_END
