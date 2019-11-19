//
//  AlarmItemModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/11/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BaseReturnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlarmItemModel : BaseReturnModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *count;
@end

NS_ASSUME_NONNULL_END
