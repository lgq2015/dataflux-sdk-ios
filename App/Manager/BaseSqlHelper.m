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
    return @"PWFMDB.sqlite";
}

- (PWFMDB *)getHelper {
    @synchronized (self) {
        if (!_fmdbHelper) {
            _fmdbHelper = [[PWFMDB alloc] initWithDBName:[self getDBName]];
            [self onDBInit];
        }
        return _fmdbHelper;
    }
}

-(void)onDBInit{
}


- (void)shutDown {
    @synchronized (self) {
        [_fmdbHelper close];
        _fmdbHelper = nil;
    }
}
@end
