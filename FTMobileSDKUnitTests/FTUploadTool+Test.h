//
//  FTUploadTool+Test.h
//  ft-sdk-iosTestUnitTests
//
//  Created by 胡蕾蕾 on 2020/8/24.
//  Copyright © 2020 hll. All rights reserved.
//

#import <FTMobileAgent/Network/FTUploadTool.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTUploadTool (Test)
// isUploading = YES 时限制上传 
@property (nonatomic, assign) BOOL isUploading;
- (NSString *)getRequestDataWithEventArray:(NSArray *)events type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
