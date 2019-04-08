//
//  NSError+CommonToast.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NSError+CommonToast.h"

@implementation NSError (CommonToast)
- (void)errorToast{
   if ([self.domain isEqualToString:@"com.hyq.YQNetworking.ErrorDomain"]) {
       [iToast alertWithTitleCenter:NSLocalizedString(ERROR_CODE_LOCAL_ERROR_NETWORK_NOT_AVAILABLE, @"")];
    } else {
       [iToast alertWithTitleCenter:NSLocalizedString(ERROR_CODE_LOCAL_ERROR_NETWORK_ERROR, @"")];
    }
}
@end
