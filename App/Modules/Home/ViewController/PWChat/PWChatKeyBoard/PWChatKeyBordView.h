//
//  PWChatKeyBordView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWChatKeyBordFunctionView.h"

/**
 底部按钮点击的五种状态
 
 - SSChatBottomTypeDefault: 默认在底部的状态
 - SSChatBottomTypeVoice: 准备发语音的状态
 - SSChatBottomTypeEdit: 准备编辑文本的状态
 - SSChatBottomTypeSymbol: 准备发送表情的状态
 - SSChatBottomTypeAdd: 准备发送其他功能的状态
 */
typedef NS_ENUM(NSInteger,PWChatKeyBoardStatus) {
    PWChatKeyBoardStatusDefault=1,
    PWChatKeyBoardStatusEdit,
    PWChatKeyBoardStatusAdd,
};


/**
 多功能界面+表情视图的承载视图
 */

@protocol PWChatKeyBordViewDelegate <NSObject>

//点击(+)其他按钮
-(void)PWChatKeyBordViewBtnClick:(NSInteger)index;
@end

@interface PWChatKeyBordView : UIView<UIScrollViewDelegate>
@property(nonatomic,weak)id<PWChatKeyBordViewDelegate,PWChatKeyBordFunctionViewDelegate>delegate;

//多功能视图
@property(nonatomic,strong)PWChatKeyBordFunctionView *functionView;
//覆盖视图
@property(nonatomic,strong)UIView *mCoverView;
@end


