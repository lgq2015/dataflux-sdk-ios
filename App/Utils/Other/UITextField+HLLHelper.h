//
//  UITextField+HLLHelper.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (HLLHelper)
//限制UITextField的输入字数.0表示无限制.
@property (nonatomic, assign) NSInteger hll_limitTextLength;
@end

NS_ASSUME_NONNULL_END
