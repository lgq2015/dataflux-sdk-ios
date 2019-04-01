//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "BaseReturnModel.h"
#import "NSString+ErrorCode.h"


@implementation BaseReturnModel {

}

- (void)setValueWithDict:(NSDictionary *)dict {
    self.errorCode = [dict stringValueForKey:ERROR_CODE default:@""];
    self.errorMsg = [self.errorCode toErrString];
}

- (BOOL)isSuccess {
    return self.errorCode.length == 0;
}


@end