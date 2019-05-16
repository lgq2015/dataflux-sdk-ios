//
//  ZTPopCommentView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTPopCommentView.h"
#import <Masonry.h>
#import "ZTPopCommentToolView.h"
#import "ZTPopCommentTopView.h"
#import "ZTPlaceHolderTextView.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define zt_topViewH 44.0
#define zt_toolViewH 44.0
#define zt_tabbarH 44.0
@interface ZTPopCommentView()<ZTPlaceHolderTextViewDelegate,UITextViewDelegate>
@property (nonatomic, strong)ZTPlaceHolderTextView *textView;
@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View
@property (nonatomic,strong) ZTPopCommentToolView *toolView;
@property (nonatomic,strong) ZTPopCommentTopView *topView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect keyBoardFrame;
@property (nonatomic, assign) CGRect commentViewFrame;
@end
@implementation ZTPopCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        self.backgroundColor = [UIColor purpleColor];

    }
    return self;
}

- (void)setOldData:(NSString *)oldData{
    _oldData = oldData;
    [self s_UI];
}

- (void)s_UI{
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self];
    [self addSubview:self.topView];
    [self addSubview:self.textView];
    [self addSubview:self.toolView];
//    [self addSubview:self.imageView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@zt_topViewH);
    }];
    //获取textview的内容高度
    CGFloat contentH = self.textView.height;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-16);
        make.height.offset(contentH);
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@zt_toolViewH);
        make.top.equalTo(self.textView.mas_bottom);
    }];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.top.equalTo(self.textView.mas_bottom);
//        make.width.height.offset(64);
//    }];
    if ([self.textView canBecomeFirstResponder]){
        [self.textView becomeFirstResponder];

    }

    NSLog(@"zhangtao----%@",self);
}
-(void)dismiss{
    //将数据传出去
    NSDictionary *dic = @{@"content":self.textView.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zt_add_comment" object:nil userInfo:dic];
    [self.textView resignFirstResponder];
    
}

#pragma mark --初始化--
-(UIWindow *)window{
    if (!_window) {
        NSLog(@"keywindow----%@----%@",[UIApplication sharedApplication].delegate.window,[UIApplication sharedApplication].keyWindow);
        _window = [UIApplication sharedApplication].delegate.window;
    }
    return _window;
}
-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,0, kWidth, kHeight);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_backgroundGrayView addGestureRecognizer:tap];
    }
    return _backgroundGrayView;
}

- (UITextView *)textView{
    if (!_textView){
        _textView = [[ZTPlaceHolderTextView alloc] init];
        _textView.zt_delegate = self;
        _textView.delegate = self;
        _textView.oldCommentData = _oldData;
    }
    return _textView;
}
- (ZTPopCommentToolView *)toolView{
    if (!_toolView){
        _toolView = [[ZTPopCommentToolView alloc] initWithFrame:CGRectZero];
        
    }
    return _toolView;
}
- (ZTPopCommentTopView *)topView{
    if (!_topView){
        _topView = [[ZTPopCommentTopView alloc] initWithFrame:CGRectZero];
        [_topView.zhankaiBtn addTarget:self action:@selector(zhankaiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}
- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.hidden = YES;
    }
    return _imageView;
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    //计算内容总高度
    CGFloat height = self.textView.height + zt_topViewH + zt_toolViewH;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyBoardFrame = keyboardFrame;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:duration animations:^{
        self.backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        self.frame = CGRectMake(0, keyboardFrame.origin.y - height, kWidth, keyboardFrame.origin.y + height);
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    [UIView commitAnimations];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:duration animations:^{
        self.backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        self.frame = CGRectMake(0, kHeight, kWidth, 200);
    } completion:^(BOOL finished) {
        [self.backgroundGrayView removeFromSuperview];
        [self.textView removeFromSuperview];
        [self removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    [UIView commitAnimations];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

#pragma mark ---用户交互行为---
//点击了展开
- (void)zhankaiBtnClick:(UIButton *)sender{

    sender.selected = !sender.selected;
    if (sender.selected){//展开
        _commentViewFrame = self.frame;
        
        CGFloat newTextViewH = kHeight - zt_tabbarH - _keyBoardFrame.size.height - zt_toolViewH - zt_topViewH ;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(newTextViewH);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, zt_tabbarH, kWidth, kHeight - zt_tabbarH);
            [self layoutIfNeeded];

        } completion:^(BOOL finished) {
            
        }];
    }else{
        CGFloat textviewH = self.textView.height;
        CGFloat commentH = textviewH + zt_topViewH + zt_toolViewH;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textviewH);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, self->_keyBoardFrame.origin.y - commentH, kWidth, self->_keyBoardFrame.origin.y + commentH);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark --ZTPlaceHolderTextViewDelegate--
- (void)textViewHeigthChange:(ZTPlaceHolderTextView *)view{
    CGFloat textviewH = view.height;
    CGFloat commentH = textviewH + zt_topViewH + zt_toolViewH;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(textviewH);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self->_keyBoardFrame.origin.y - commentH, kWidth, self->_keyBoardFrame.origin.y + commentH);
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}



@end
