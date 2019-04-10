//
//  QLPreviewController+title.m
//  App
//
//  Created by tao on 2019/4/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "QLPreviewController+title.h"
#import <objc/runtime.h>
@implementation QLPreviewController (title)
- (void)setQltitle:(NSString *)qltitle{
    objc_setAssociatedObject(self, @"qltitle", qltitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)qltitle{
    return objc_getAssociatedObject(self, @"qltitle");
}
- (void)setTitle:(NSString *)title{
    if (self.qltitle){
        self.navigationItem.title = self.qltitle;
    }else{
        self.navigationItem.title = title;
    }
}
@end
