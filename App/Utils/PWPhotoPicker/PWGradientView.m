//
//  PWGradientView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWGradientView.h"

@implementation PWGradientView
+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setupCAGradientLayer:(NSArray *)colors locations:(NSArray *)locations {
    CAGradientLayer *gradient=(CAGradientLayer*)self.layer;
    gradient.colors = colors;
    gradient.locations = locations;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
