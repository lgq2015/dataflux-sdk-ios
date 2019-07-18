//
// Created by Brandon on 2019-03-26.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "NSString+ErrorCode.h"


@implementation NSString (ErrorCode)

- (NSString *)toErrString {
    return [NSLocalizedString(self, nil) isEqualToString:self]?@"服务器正忙，请稍后重试":NSLocalizedString(self, nil);
}

@end
