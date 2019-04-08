//
//  FounctionIntroductionModel.m
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "FounctionIntroductionModel.h"

@implementation FounctionIntroductionModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"des"}];
}
@end
