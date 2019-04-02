//
//  IssueChatKeyBoardInputView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueChatKeyBordView.h"
NS_ASSUME_NONNULL_BEGIN
@class IssueChatKeyBoardInputView;


/**
 聊天界面底部的输入框视图
 */

#define PWChatKeyBoardInputViewH      67     //输入部分的高度
#define PWChatKeyBordBottomHeight     258    //底部视图的高度

//键盘总高度
#define PWChatKeyBordHeight   PWChatKeyBoardInputViewH + PWChatKeyBordBottomHeight


#define PWChatLineHeight        0.5          //线条高度
#define PWChatBotomTop          kHeight- PWChatBotomHeight-SafeAreaBottom_Height                    //底部视图的顶部
#define PWChatBtnSize           30           //按钮的大小
#define PWChatLeftDistence      5            //左边间隙
#define PWChatRightDistence     5            //左边间隙
#define PWChatBtnDistence       10           //控件之间的间隙
#define PWChatTextHeight        45           //输入框的高度
#define PWChatTextMaxHeight     85           //输入框的最大高度
#define PWChatTextWidth      kWidth - (16 + 59)                       //输入框的宽度

#define PWChatTBottomDistence   11            //输入框上下间隙
#define PWChatBBottomDistence   18          //按钮上下间隙
@protocol PWChatKeyBoardInputViewDelegate <NSObject>

//改变输入框的高度 并让控制器弹出键盘
-(void)PWChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime;

//发送文本信息
-(void)PWChatKeyBoardInputViewBtnClick:(NSString *)string;

//多功能视图按钮点击回调
-(void)PWChatKeyBoardInputViewBtnClickFunction:(NSInteger)index;

@end
@interface IssueChatKeyBoardInputView : UIView<UITextViewDelegate,PWChatKeyBordViewDelegate>
@property(nonatomic,assign)id<PWChatKeyBoardInputViewDelegate>delegate;

//当前的编辑状态（默认 语音 编辑文本 发送表情 其他功能）
@property(nonatomic,assign)PWChatKeyBoardStatus keyBoardStatus;
//键盘或者 表情视图 功能视图的高度
@property(nonatomic,assign)CGFloat changeTime;
@property(nonatomic,assign)CGFloat keyBoardHieght;

//传入底部视图进行frame布局
@property (strong, nonatomic) IssueChatKeyBordView   *mKeyBordView;

//顶部线条
@property(nonatomic,strong) UIView   *topLine;

//当前点击的按钮  左侧按钮   表情按钮  添加按钮
@property(nonatomic,strong) UIButton *currentBtn;
@property(nonatomic,strong) UIButton *mAddBtn;

//输入框背景 输入框 缓存输入的文字
@property(nonatomic,strong) UIButton     *mTextBtn;
@property(nonatomic,strong) UITextView   *mTextView;
@property(nonatomic,strong) NSString     *textString;
//输入框的高度
@property(nonatomic,assign) CGFloat   textH;

//键盘归位
-(void)SetPWChatKeyBoardInputViewEndEditing;
@end

NS_ASSUME_NONNULL_END
