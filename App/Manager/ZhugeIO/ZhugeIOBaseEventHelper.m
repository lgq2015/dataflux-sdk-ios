//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Zhugeio/Zhuge.h>
#import "ZhugeIOBaseEventHelper.h"

@interface ZhugeIOBaseEventHelper ()

@property(strong, nonatomic) NSString *event;

@end


@implementation ZhugeIOBaseEventHelper {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableDictionary new];
    }

    return self;
}

- (ZhugeIOBaseEventHelper*)event:(NSString *)event {
    _event = event;
    return self;
}

- (ZhugeIOBaseEventHelper*)scence:(NSString *)scence {
    _data[@"场景"]=scence;
    return self;
}

- (void)track {
    NSString *eventString = [NSString stringWithFormat:@"%@-%@", _category, _event];

    if (_data.allKeys.count > 0) {
        [[Zhuge sharedInstance] track:eventString properties:_data];

    } else {
        [[Zhuge sharedInstance] track:eventString];

    }
}

-(void)startTrack{
    NSString *eventString = [NSString stringWithFormat:@"%@-%@", _category, _event];

    [[Zhuge sharedInstance] startTrack:eventString];

}

-(void)endTrack{
    NSString *eventString = [NSString stringWithFormat:@"%@-%@", _category, _event];

    [[Zhuge sharedInstance] endTrack:eventString properties:_data];
}







@end