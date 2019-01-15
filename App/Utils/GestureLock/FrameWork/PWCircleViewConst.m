//
//  PWCircleViewConst.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWCircleViewConst.h"

@implementation PWCircleViewConst
+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getGestureWithKey:(NSString *)key
{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
@end
