//
//  IssueExtraModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueExtraModel : NSObject
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileIcon;
@property (nonatomic, strong) NSString *fileSize;
@property (nonatomic, strong) NSString *expireTime;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
