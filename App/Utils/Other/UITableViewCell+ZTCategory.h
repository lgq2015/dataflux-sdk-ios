//
//  UITableViewCell+ZTCategory.h
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (ZTCategory)
+ (NSString *)cellReuseIdentifier;

+ (UINib *)cellWithNib;
@end

NS_ASSUME_NONNULL_END
