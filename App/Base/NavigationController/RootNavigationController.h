//
//  RootNavigationController.h
//  App
//
//  Created by 胡蕾蕾 on 2018/11/29.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 导航控制器基类
 */
@interface RootNavigationController : UINavigationController
/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
-(BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;
@end
