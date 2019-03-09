//
//  BaseTextField.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
