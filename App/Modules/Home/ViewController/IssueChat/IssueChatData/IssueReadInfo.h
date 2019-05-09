//
//  IssueReadInfo.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
#import "IssueLastReadInfoData.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueReadInfo : JSONModel
@property (nonatomic, assign) long long seq;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, strong) NSString *teamId;
@end

NS_ASSUME_NONNULL_END
