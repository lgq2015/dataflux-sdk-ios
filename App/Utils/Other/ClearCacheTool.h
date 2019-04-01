//
//  ClearCacheTool.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClearCacheTool : NSObject
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;
+ (BOOL)clearCacheWithFilePath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
