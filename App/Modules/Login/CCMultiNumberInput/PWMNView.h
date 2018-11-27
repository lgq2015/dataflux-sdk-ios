//
//  PWMNView.h
//  PWMultiNumberInput
//
//  Created by 胡蕾蕾 on 2018/11/8.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^completedBlock)(BOOL is);
@interface PWMNView : UIView
//多少位验证码
@property (nonatomic, assign) NSInteger count;
//选中的line的颜色
@property (nonatomic, strong) UIColor *selectColor;
//正常的line的颜色
@property (nonatomic, strong) UIColor *normolColor;
//光标的颜色
@property (nonatomic, strong) UIColor *tinColor;
//字体字号
@property (nonatomic, strong) UIFont *textFont;
//当前是否选中
@property (nonatomic, assign) BOOL codeView_IsFirstResponder;
//输入完成又删除一个的回调
@property (nonatomic, copy) void(^deleteBlock)(void);
//输入完成的block
@property (nonatomic, copy) void(^completeBlock)(NSString *completeStr);
//是否需要验证码样式
@property (nonatomic, assign) BOOL isCodeViewStatus;
@property (nonatomic, copy) NSString *codeString;

- (void)createItem;
- (void)setItemEmpty;
- (void)codeView_ResignFirstResponder;
- (void)setValueWithString:(NSString *)value completed:(completedBlock)completedBlock;
@end
