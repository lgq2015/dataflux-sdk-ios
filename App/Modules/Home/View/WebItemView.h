//
//  WebItemView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WebItemViewStyle){
    WebItemViewStyleNormal,
    WebItemViewStyleNoShare
};

NS_ASSUME_NONNULL_BEGIN

@interface WebItemView : UIView
@property (nonatomic, copy) void(^itemClick)(NSInteger tag);
-(instancetype)initWithStyle:(WebItemViewStyle)style;
- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
