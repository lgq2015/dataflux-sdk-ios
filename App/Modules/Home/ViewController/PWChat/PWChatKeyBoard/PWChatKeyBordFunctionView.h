//
//  PWChatKeyBordFunctionView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PWChatKeyBordFunctionViewDelegate <NSObject>

-(void)PWChatKeyBordFunctionViewBtnClick:(NSInteger)index;

@end
@interface PWChatKeyBordFunctionView : UIView<UIScrollViewDelegate>
@property(nonatomic,assign)id<PWChatKeyBordFunctionViewDelegate>delegate;

@property(nonatomic,strong)UIScrollView  *mScrollView;
@property(nonatomic,strong)UIPageControl *pageControll;
@end

NS_ASSUME_NONNULL_END
