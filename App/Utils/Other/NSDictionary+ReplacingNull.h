//
//  NSDictionary+ReplacingNull.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ReplacingNull)
- (NSDictionary *)dictionaryByReplacingNullsWithStrings;
@end

NS_ASSUME_NONNULL_END
