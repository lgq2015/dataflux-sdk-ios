//
// Created by Brandon on 2019-03-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "BaseSqlHelper.h"


@interface BaseSqlHelper ()

@property(nonatomic, strong) PWFMDB *fmdbHelper;

@end

@implementation BaseSqlHelper {

}

-(NSString *)getDBName{
    return @"";
}

- (PWFMDB *)getHelper {
    if (!_fmdbHelper) {
        _fmdbHelper = [[PWFMDB alloc] initWithDBName:[self getDBName]];
    }
    return _fmdbHelper;
}


- (void)shutDown {
    _fmdbHelper = nil;
}
@end