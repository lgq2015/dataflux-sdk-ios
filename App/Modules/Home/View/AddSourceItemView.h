//
//  AddSourceItemView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddSourceItemView : UIView
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) void(^itemClick)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
