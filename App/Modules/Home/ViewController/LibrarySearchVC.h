//
//  LibrarySearchVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LibrarySearchVC : RootViewController
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) NSArray *totalData;
@property (nonatomic, assign) BOOL isLocal;
@end

NS_ASSUME_NONNULL_END