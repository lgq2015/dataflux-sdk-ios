//
// Created by Brandon on 2019-06-03.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZhugeIOBaseEventHelper;


@interface ZhugeIOServiceHelper : ZhugeIOBaseEventHelper
- (ZhugeIOBaseEventHelper *)eventBottomTab;

- (ZhugeIOServiceHelper *)eventGoodPageStay;

- (ZhugeIOServiceHelper *)attrTabName;

- (ZhugeIOServiceHelper *)attrGoodName:(NSString *)name;

- (ZhugeIOServiceHelper *)attrStayTime:(NSString *)name;
@end