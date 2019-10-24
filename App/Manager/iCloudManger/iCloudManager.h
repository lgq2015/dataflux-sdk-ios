//
//  iCloudManager.h
//  App
//
//  Created by 胡蕾蕾 on 2019/10/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^downloadBlock)(id _Nullable obj);

NS_ASSUME_NONNULL_BEGIN

@interface iCloudManager : NSObject
+ (BOOL)iCloudEnable;

+ (void)downloadWithDocumentURL:(NSURL*)url callBack:(downloadBlock)block;
@end

NS_ASSUME_NONNULL_END
