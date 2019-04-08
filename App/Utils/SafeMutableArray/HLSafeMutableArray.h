//
//  HLSafeMutableArray.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSafeMutableArray : NSMutableArray
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
