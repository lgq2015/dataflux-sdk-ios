//
//  ChatInputHeaderView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,IssueDealState){
    IssueDealStateChat = 1,     //回复图标
    IssueDealStateDeal = 2,     //处理图标
    IssueDealStateSolve =3,     //解决图标
};
NS_ASSUME_NONNULL_BEGIN

@interface ChatInputHeaderView : UIView
@property (nonatomic, strong) UIButton *unfoldBtn; 
@property (nonatomic, assign) IssueDealState state;
@end

NS_ASSUME_NONNULL_END
