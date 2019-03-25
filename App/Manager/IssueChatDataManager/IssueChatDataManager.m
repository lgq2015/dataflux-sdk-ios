//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueChatDataManager.h"
#import "IssueLogModel.h"

@interface IssueChatDataManager ()

@property(nonatomic) BOOL isFetching;

@end

@implementation IssueChatDataManager {

}


+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {


    }

    return self;
}

- (NSString *)getDBName {
    return NSStringFormat(@"%@/%@", getPWUserID, PW_DBNAME_INFORMATION);

}

- (void)fetchAllChatIssueLog:(NSString *)issueId pageKMarker:(long long)pageKMarker callBack:(IssueLogModel *(^)(void))callback {

    @synchronized (self) {

    }

}


@end
