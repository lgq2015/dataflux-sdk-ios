//
//  iCloudManager.m
//  App
//
//  Created by 胡蕾蕾 on 2019/10/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "iCloudManager.h"
#import "PWDocument.h"
@implementation iCloudManager
+ (BOOL)iCloudEnable {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];

    if (url != nil) {
        return YES;
    }
    
    DLog(@"iCloud 不可用");
    return NO;
}
+ (void)downloadWithDocumentURL:(NSURL*)url callBack:(downloadBlock)block {
    
    PWDocument *iCloudDoc = [[PWDocument alloc]initWithFileURL:url];

    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {

            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
                DLog(@"关闭成功");
            }];

            if (block) {
                block(iCloudDoc.data);
            }

        }
    }];
}
@end
