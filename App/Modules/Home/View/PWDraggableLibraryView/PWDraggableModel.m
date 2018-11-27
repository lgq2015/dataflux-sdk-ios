//
//  PWDraggableModel.m
//  PWDraggableLibraryView
//
//  Created by 胡蕾蕾 on 2018/9/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWDraggableModel.h"
#import "NSDictionaryUtils.h"

@implementation PWDraggableModel
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithJson:dictionary];
    }
    return self;
}
- (void)setValueWithJson:(NSDictionary *)dict{
    self.image = [dict stringValueForKey:@"image" defaultValue:@""];
    self.title = [dict stringValueForKey:@"title" defaultValue:@""];
    self.subtitle = [dict stringValueForKey:@"subtitle" defaultValue:@""];
}
@end
