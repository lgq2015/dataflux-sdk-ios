//
//  ZTPopCommentView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTPopCommentView.h"
#import "ZTPopCommentToolView.h"

#define PWChatTextMaxHeight     85
#define PWChatTextHeight        45
#define zt_topViewH 44.0
#define zt_toolViewH 44.0
#define zt_tabbarH 44.0
@interface ZTPopCommentView()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *mTextView;
@property (nonatomic, strong) UIWindow * window;
@property (nonatomic, strong) UIView *backgroundGrayView; //!<透明背景View
@property (nonatomic, strong) ZTPopCommentToolView *toolView;
@property (nonatomic, strong) ChatInputHeaderView *topView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect keyBoardFrame;
@property (nonatomic, assign) CGRect commentViewFrame;
@property (nonatomic, assign) CGFloat   textH;
@end
@implementation ZTPopCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        self.backgroundColor = PWWhiteColor;
       
    }
    return self;
}

- (void)setOldData:(NSString *)oldData{
    _oldData = oldData;
    self.topView.state = self.state;
   [self s_UI];
}
- (void)show{
   
}
- (void)s_UI{
    if(!_backgroundGrayView){
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
    [self addGestureRecognizer:tap];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@zt_topViewH);
    }];
    //获取textview的内容高度
     _textH = PWChatTextHeight;
    [self.mTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-16);
        make.height.offset(_textH);
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@zt_toolViewH);
        make.top.equalTo(self.mTextView.mas_bottom);
    }];
    }else{
        self.backgroundGrayView.hidden = NO;
        self.hidden = NO;
    }
    if ([self.mTextView canBecomeFirstResponder]){
        [self.mTextView becomeFirstResponder];

    }
    [self textViewDidChange:self.mTextView];
    NSLog(@"zhangtao----%@",self);
}
- (void)viewTap{
    
}
-(void)dismiss{
    //将数据传出去
    NSDictionary *dic = @{@"content":self.mTextView.text,@"state":[NSNumber numberWithInteger:self.topView.state]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zt_add_comment" object:nil userInfo:dic];
    [self.mTextView resignFirstResponder];
    
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

- (UITextView *)mTextView{
    if (!_mTextView){
        _mTextView = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:@"输入您的内容" font:RegularFONT(14)];
        _mTextView.delegate = self;
        _mTextView.text = _oldData;
        [self addSubview:_mTextView];
    }
    return _mTextView;
}
- (ZTPopCommentToolView *)toolView{
    if (!_toolView){
        _toolView = [[ZTPopCommentToolView alloc] initWithFrame:CGRectZero];
      [self addSubview:_toolView];
    }
    return _toolView;
}
- (ChatInputHeaderView *)topView{
    if (!_topView){
        _topView = [[ChatInputHeaderView alloc] initWithFrame:CGRectZero];
        [_topView.unfoldBtn addTarget:self action:@selector(zhankaiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topView];
    }
    return _topView;
}


#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    //计算内容总高度
    CGFloat height = _textH + zt_topViewH + zt_toolViewH;
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
        self.backgroundGrayView.hidden =YES;
        self.hidden = YES;
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
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, zt_tabbarH, kWidth, kHeight - zt_tabbarH);
            [self.mTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(newTextViewH);
            }];

            [self layoutIfNeeded];

        } completion:^(BOOL finished) {
            
        }];
    }else{
        CGFloat textviewH = _textH;
        CGFloat commentH = textviewH + zt_topViewH + zt_toolViewH;
        [self.mTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textviewH);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, self->_keyBoardFrame.origin.y - commentH, kWidth, self->_keyBoardFrame.origin.y + commentH);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self textViewDidChange:self.mTextView];
        }];
    }
}
//监听输入框的操作 输入框高度动态变化
- (void)textViewDidChange:(UITextView *)textView{
    
    _oldData = textView.text;
    CGFloat width = textView.width;
    //获取到textView的最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(width, MAXFLOAT)].height);
    if(self.topView.unfoldBtn.selected){
        return;
    }
    if(height>PWChatTextMaxHeight){
        height = PWChatTextMaxHeight;
        textView.scrollEnabled = YES;
    }
    else if(height<PWChatTextHeight){
        height = PWChatTextHeight;
        textView.scrollEnabled = NO;
    }
    else{
        textView.scrollEnabled = NO;
    }
    
    if(_textH != height){
        _textH = height;
        [self setNewSizeWithBootm:height];
    }
    else{
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 2)];
    }
}
//设置所有控件新的尺寸位置
-(void)setNewSizeWithBootm:(CGFloat)height{
  
    
    [UIView animateWithDuration:0.25 animations:^{
        self.height = 8 + 8 + self.mTextView.height;
        [self.mTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        CGFloat height = _textH + zt_topViewH + zt_toolViewH;
        
        self.frame = CGRectMake(0, _keyBoardFrame.origin.y - height, kWidth, _keyBoardFrame.origin.y + height);
    } completion:^(BOOL finished) {
        [self.mTextView.superview layoutIfNeeded];
    }];
}



@end
