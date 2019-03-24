//
// Created by Brandon on 2019-03-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "BaseSqlHelper.h"


@interface BaseSqlHelper ()

@property(nonatomic, strong) PWFMDB *fmdbHelper;
@property(nonatomic, strong) NSString *dbName;

@end

@implementation BaseSqlHelper {

}


- (instancetype)initWithDBName:(NSString *)dbName {
    _dbName = dbName;
    return self;
}

- (PWFMDB *)getHelper {
    if (!_fmdbHelper) {
        _fmdbHelper = [[PWFMDB alloc] initWithDBName:_dbName];
    }
    return _fmdbHelper;
}


- (void)shutDown {
    _fmdbHelper = nil;
}
@end