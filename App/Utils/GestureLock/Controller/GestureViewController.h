//
//  GestureViewController.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger,GestureViewControllerType){
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin,
};
typedef NS_ENUM(NSUInteger,buttonTag) {
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
};
@interface GestureViewController : RootViewController
/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;
@end


