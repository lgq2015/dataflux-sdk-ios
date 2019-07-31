//
//  SourceModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SourceModel : JSONModel
@property (nonatomic, strong)NSString *provider;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *sourceID;

@end

NS_ASSUME_NONNULL_END
