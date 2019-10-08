//
//  PopItemView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/9/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PopItemViewDelegate <NSObject>
- (void)itemClick:(NSInteger)index;
@end
@interface PopItemView : UIView
@property (nonatomic, assign) id <PopItemViewDelegate> delegate;
@property (nonatomic, strong) NSArray *itemDatas;
- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
