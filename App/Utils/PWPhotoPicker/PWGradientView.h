//
//  PWGradientView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWGradientView : UIView
- (void)setupCAGradientLayer:(NSArray *)colors locations:(NSArray *)locations;

@end

NS_ASSUME_NONNULL_END
