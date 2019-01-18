//
//  SourceVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSUInteger, SourceType) {
    SourceTypeAli = 0,
};

@interface SourceVC : RootViewController
@property (nonatomic, assign) SourceType type;
@end


