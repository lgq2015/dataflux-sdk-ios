//
// Created by Brandon on 2019-03-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "BaseSqlHelper.h"


@interface BaseSqlHelper ()

@property(nonatomic, strong) PWFMDB *fmdbHelper;
@property (nonatomic, strong) NSObject *lock;

@end

@implementation BaseSqlHelper {

}

-(NSString *)getDBName{
    return @"PWFMDB.sqlite";
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSObject alloc] init];
    }

    return self;
}


- (PWFMDB *)getHelper {
    @synchronized (self.lock) {
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
    @synchronized (self.lock) {
        [_fmdbHelper pw_inDatabase:^{
            [_fmdbHelper close];
            _fmdbHelper = nil;
        }];
    }
}
@end
