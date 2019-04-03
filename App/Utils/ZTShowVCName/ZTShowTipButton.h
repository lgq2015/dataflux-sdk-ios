//
//  ZTShowTipButton.h
//  123
//
//  Created by tao on 2019/4/2.
//  Copyright © 2019 shitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTShowTipButton : NSObject
+ (instancetype)shareInstance;
@property (nonatomic,strong)UIButton *tipBtn;
@end

NS_ASSUME_NONNULL_END
