//
// Created by Brandon on 2019-07-08.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOCalendarHelper.h"


@implementation ZhugeIOCalendarHelper {

}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.category = @"日历";
    }
    return self;
}


- (ZhugeIOCalendarHelper *)eventClickBottomTab {
    [self event:@"点击底部Tab"];
    return self;
}

- (ZhugeIOCalendarHelper *)attrTabName {
    self.data[@"目标位置"] = @"日历";
    return self;

}


@end