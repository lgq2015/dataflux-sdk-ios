//
//  UIViewController+ZYRootVC.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2019/12/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UIViewController+FT_RootVC.h"
@implementation UIViewController (FT_RootVC)
+ (NSString *)ft_getRootViewController{
    UIWindow* window = nil;
       if (@available(iOS 13.0, *)) {
           for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
           {
              if (windowScene.activationState == UISceneActivationStateForegroundActive)
              {
                   window = windowScene.windows.firstObject;
                   break;
              }
           }
       }else{
           #pragma clang diagnostic push
           #pragma clang diagnostic ignored "-Wdeprecated-declarations"
               // 这部分使用到的过期api
            window = [UIApplication sharedApplication].keyWindow;
           #pragma clang diagnostic pop
       }
    NSString *name = NSStringFromClass([window.rootViewController class]);
    
    if( [name isKindOfClass:NSNull.class]
       ||name==nil){
        return @"null";
    }else{
        return  name;
    }
}

@end
