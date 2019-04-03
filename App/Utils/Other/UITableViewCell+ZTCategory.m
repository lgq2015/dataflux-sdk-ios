//
//  UITableViewCell+ZTCategory.m
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UITableViewCell+ZTCategory.h"
#import "NSObject+ZTUtil.h"

@implementation UITableViewCell (ZTCategory)
+ (NSString *)cellReuseIdentifier{
    return [self classString];
}

+ (UINib *)cellWithNib{
    return [UINib nibWithNibName:[self classString] bundle:nil];
}
@end
