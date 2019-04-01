//
//  PWMNInputItem.h
//  PWMutiNumberInput
//
//  Created by 胡蕾蕾 on 2018/11/5.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWMNInputItem : UIView
@property (nonatomic, strong) UILabel *inputView;
@property (nonatomic, assign) CGFloat zoom;
-(void)warning;
-(void)setNormalState;
@end
