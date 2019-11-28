//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "BaseReturnModel.h"
#import "NSString+ErrorCode.h"


@implementation BaseReturnModel {

}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}


- (void)setValueWithDict:(NSDictionary *)dict {
    self.errorCode = [dict stringValueForKey:ERROR_CODE default:@""];
    self.errorMsg = [[self.errorCode toErrString] isEqualToString:self.errorCode]?[dict stringValueForKey:@"message" default:@""]:[self.errorCode toErrString];
    if ([dict[@"content"] isKindOfClass:NSDictionary.class]) {
        self.contentDict = dict[@"content"];
    }
}

- (BOOL)isSuccess {
    return self.errorCode.length == 0;
}


@end
