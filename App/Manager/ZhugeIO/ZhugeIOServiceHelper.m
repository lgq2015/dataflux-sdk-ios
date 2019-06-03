//
// Created by Brandon on 2019-06-03.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOBaseEventHelper.h"
#import "ZhugeIOServiceHelper.h"


@implementation ZhugeIOServiceHelper {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.category = @"服务";
    }

    return self;
}


- (ZhugeIOServiceHelper *)eventBottomTab {
    [self event:@"点击底部Tab"];
    return self;

}


- (ZhugeIOServiceHelper *)eventGoodPageStay {
    [self event:@"商品页面停留时长"];
    return self;

}


- (ZhugeIOServiceHelper *)attrTabName {
    self.data[@"目标位置"] = @"服务";
    return self;

}

- (ZhugeIOServiceHelper *)attrGoodName:(NSString *)name {
    self.data[@"商品名称"] = name;
    return self;

}

- (ZhugeIOServiceHelper *)attrStayTime:(NSString *)name {
    self.data[@"停留时长"] = @"秒";
    return self;

}

@end