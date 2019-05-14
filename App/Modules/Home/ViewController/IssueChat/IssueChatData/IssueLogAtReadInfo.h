//
//  IssueLogAtReadInfo.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BaseListReturnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueLogAtReadInfo : BaseListReturnModel
@property (nonatomic, strong) NSDictionary *lastReadSeqInfo;
@property (nonatomic, strong) NSDictionary *readInfo;
@end

NS_ASSUME_NONNULL_END