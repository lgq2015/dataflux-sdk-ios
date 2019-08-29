//
//  RuleModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RuleModel : JSONModel
@property (nonatomic, strong) NSArray *issueSource;
@property (nonatomic, strong) NSArray *level;
@property (nonatomic, strong) NSArray *type;
@property (nonatomic, strong) NSArray *origin;
@property (nonatomic, strong) NSDictionary *tags;
@end

NS_ASSUME_NONNULL_END
