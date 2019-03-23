//
//  PWChatKeyBordFunctionView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PWChatKeyBordFunctionViewDelegate <NSObject>

-(void)PWChatKeyBordFunctionViewBtnClick:(NSInteger)index;
@end

@interface PWChatKeyBordFunctionView : UIView<UIScrollViewDelegate>
@property(nonatomic,weak) id<PWChatKeyBordFunctionViewDelegate> delegate;

@property(nonatomic,strong)UIScrollView  *mScrollView;
@property(nonatomic,strong)UIPageControl *pageControll;
@end


