//
//  ZTSearchBar.h
//  123
//
//  Created by tao on 2019/4/21.
//  Copyright © 2019 shitu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTSearchBar : UIView
@property (nonatomic, strong)UITextField *tf;
@property (nonatomic, copy) void(^cancleClick)(void);

@end

NS_ASSUME_NONNULL_END
