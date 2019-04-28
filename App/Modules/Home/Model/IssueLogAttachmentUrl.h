//
//  IssueLogAttachmentUrl.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BaseReturnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueLogAttachmentUrl : BaseReturnModel

@property (nonatomic, strong) NSDictionary *externalDownloadURL;
//[0]    (null)    @"expireTime" : @"2019-04-24T03:33:51.000Z"
//[1]    (null)    @"url" : @"https://zhuyun-cloudcare-basis-testing.oss-cn-hangzhou.aliyuncs.com/cloudcare-core/issueAttachments/team-vyqXb6Y5AbLdALbTPjqyHZ/issu-hiMwM4KkPbTFJ9ZT4mFRzt/issa-9ErjycwZmjCCAxcBFQF8ek?OSSAccessKeyId=LTAIJhKRGfri4CEh&Expires=1556076831&Signature=%2FzTxGBCFsg5qqE3Kt3daOTz4iok%3D&response-content-disposition=attachment%3B%20filename%3DPPT%E6%96%87%E4%BB%B6.ppt"
@end

NS_ASSUME_NONNULL_END
