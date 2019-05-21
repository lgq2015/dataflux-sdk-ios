//
//  ChooseChatStateView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol ChooseChatStateViewDelegate <NSObject>
// index :1 图片 2.@
- (void)ChooseChatStateViewCellIndex:(NSInteger)index;
@end
@interface ChooseChatStateView : UIView
@property (nonatomic, assign) id<ChooseChatStateViewDelegate> delegate;
@property (nonatomic, strong) UITableView *mTableView;

- (void)showWithState:(NSInteger)state;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
