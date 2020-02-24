//
//  ZYUploadTool.h
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2019/12/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FTMobileConfig;
NS_ASSUME_NONNULL_BEGIN

@interface FTUploadTool : NSObject
-(instancetype)initWithConfig:(FTMobileConfig *)config;
-(void)upload;
@end

NS_ASSUME_NONNULL_END