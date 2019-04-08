//
//  UIViewController+ZTSwizzling.m
//  123
//
//  Created by tao on 2019/4/2.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "UIViewController+ZTSwizzling.h"
#import <objc/runtime.h>
#import "ZTShowTipButton.h"

@implementation UIViewController (ZTSwizzling)
#ifdef DEV //开发环境
+ (void)load{
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(viewDidAppear:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(swiz_viewDidAppear:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        
    });
}
#endif

- (void)swiz_viewDidAppear:(BOOL)animated{
    //这时候调用自己，看起来像是死循环
    //但是其实自己的实现已经被替换了
    [self swiz_viewDidAppear:animated];
    UIButton *tipBtn = [ZTShowTipButton shareInstance].tipBtn;
    UIViewController *vc = [self getTopMostController];
    NSString *vcName = NSStringFromClass([vc class]);
    NSString *tipBtnText =tipBtn.titleLabel.text;
    //判断是否开启了显示控制器名称的开关
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"zt_showvcname"]){
        return;
    }
    if (![vcName isEqualToString:tipBtnText]){
        [tipBtn removeFromSuperview];
        [[UIApplication sharedApplication].delegate.window addSubview:tipBtn];
        [tipBtn setTitle:NSStringFromClass([vc class]) forState:UIControlStateNormal];
        [tipBtn sizeToFit];
    }
}

//获取当前最上层的控制器
- (UIViewController *)getTopMostController{
    
    UIViewController* currentViewController = [self zt_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}
- (UIViewController *)zt_getRootViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}
@end
