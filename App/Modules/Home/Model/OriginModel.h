//
//  OriginModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OriginModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *origin;
@end

NS_ASSUME_NONNULL_END
