//
//  ChangeCardItem.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeCardItem : UIView
@property (nonatomic, copy) void(^itemClick)(void);

-(instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
