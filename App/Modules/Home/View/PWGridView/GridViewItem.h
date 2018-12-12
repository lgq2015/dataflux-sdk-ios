//
//  GridViewItem.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/4.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewModel.h"

@interface GridViewItem : UIView
@property (nonatomic, strong) GridViewModel* model;
@property (nonatomic, copy) void(^itemClick)(NSInteger index);
@end
