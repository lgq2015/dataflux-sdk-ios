//
// Created by Brandon on 2019-03-26.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "NSString+ErrorCode.h"


@implementation NSString (ErrorCode)

- (NSString *)toErrString {
    NSString * mergeValue = @"";
    if (![self hasPrefix:@"local.err"]) {
        mergeValue = [@"server.err." stringByAppendingString:self];
    }

    return [NSLocalizedString(mergeValue, nil) isEqualToString:self]? NSLocalizedString(@"local.NetErr.TheServerIsBusyPleaseTryAgainLater", @""):NSLocalizedString(self, nil);
}

@end
