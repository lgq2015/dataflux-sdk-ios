//
//  PWInfoInitialView.h
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/17.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PWInfoInitialViewDelegate <NSObject>
- (void)serverConnectClick;
@end
@interface PWInfoInitialView : UIView
/**
 *  代理方法
 */
@property (nonatomic, weak) id<PWInfoInitialViewDelegate> delegate;

@end
