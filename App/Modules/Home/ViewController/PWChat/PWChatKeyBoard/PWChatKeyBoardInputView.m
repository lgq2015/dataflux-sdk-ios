//
//  PWChatKeyBoardInputView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatKeyBoardInputView.h"
#import "PWChatKeyBordView.h"
@implementation PWChatKeyBoardInputView

-(instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        DLog(@"SafeAreaBottom_Height = %f",kHeight);
        self.frame = CGRectMake(0, kHeight-PWChatKeyBoardInputViewH-SafeAreaBottom_Height-kTopHeight, kWidth, PWChatKeyBoardInputViewH);
        _keyBoardStatus = PWChatKeyBoardStatusDefault;
        _keyBoardHieght = 0;
        _changeTime = 0.25;
        _textH = PWChatTextHeight;
        
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        _topLine.backgroundColor = CellLineColor;
        [self addSubview:_topLine];
        
        //添加按钮
        _mAddBtn = [[UIButton alloc]init];
        _mAddBtn.tag  = 12;
        _mAddBtn.selected = NO;
        [self addSubview:_mAddBtn];
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateNormal];
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateSelected];
        _mAddBtn.selected = NO;
        [_mAddBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.mAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-16);
            make.centerY.mas_equalTo(self);
            make.width.height.offset(30);
        }];
       
        // 语音按钮   输入框
        _mTextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _mTextBtn.bounds = CGRectMake(0, 0, PWChatTextWidth, PWChatTextHeight);
        _mTextBtn.left = 16;
        _mTextBtn.bottom = self.height - PWChatTBottomDistence;
        _mTextBtn.backgroundColor = [UIColor whiteColor];
        _mTextBtn.layer.borderWidth = 0.5;
        _mTextBtn.layer.borderColor = CellLineColor.CGColor;
        _mTextBtn.clipsToBounds = YES;
        _mTextBtn.layer.cornerRadius = 3;
        [self addSubview:_mTextBtn];
        _mTextBtn.userInteractionEnabled = YES;
        _mTextView = [[UITextView alloc]init];
        _mTextView.frame = _mTextBtn.bounds;
        _mTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _mTextView.delegate = self;
        [_mTextBtn addSubview:_mTextView];
   
        _mTextView.backgroundColor = [UIColor whiteColor];
        _mTextView.returnKeyType = UIReturnKeySend;
        _mTextView.font = MediumFONT(17);
        _mTextView.textColor = PWTextBlackColor;
        _mTextView.showsHorizontalScrollIndicator = NO;
        _mTextView.showsVerticalScrollIndicator = NO;
        _mTextView.enablesReturnKeyAutomatically = YES;
        _mTextView.scrollEnabled = NO;
    
        
        _mKeyBordView = [[PWChatKeyBordView alloc]initWithFrame:CGRectMake(0, self.height, kWidth, PWChatKeyBordHeight)];
        _mKeyBordView.delegate = self;
        [self addSubview:_mKeyBordView];
        
        
        //键盘显示 回收的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}


//开始布局就把底部的表情和多功能放在输入框底部了 这里需要对点击界外事件做处理
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if(point.y>PWChatKeyBoardInputViewH){
        UIView *hitView = [super hitTest:point withEvent:event];
        
        NSMutableArray *array = [NSMutableArray new];
        
        
            for(UIView * view in _mKeyBordView.functionView.mScrollView.subviews){
                [array addObjectsFromArray:view.subviews];
            }
    
         for(UIView *subView in array) {
            
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if(CGRectContainsPoint(subView.bounds, myPoint)) {
                hitView = subView;
                break;
            }
        }
        
        return hitView;
    }
    else{
        return [super hitTest:point withEvent:event];
    }
}

//键盘显示监听事件
- (void)keyboardWillChange:(NSNotification *)noti{
    
    _changeTime  = [[noti userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if(noti.name == UIKeyboardWillHideNotification){
        height = SafeAreaBottom_Height;
        if(_keyBoardStatus == PWChatKeyBoardStatusAdd){
            height = SafeAreaBottom_Height+PWChatKeyBordHeight;
        }
    }else{
        
        self.keyBoardStatus = PWChatKeyBoardStatusEdit;
        self.currentBtn.selected = NO;
        
        if(height==SafeAreaBottom_Height || height==0) height = _keyBoardHieght;
    }
    
    self.keyBoardHieght = height;
}

//弹起的高度
-(void)setKeyBoardHieght:(CGFloat)keyBoardHieght{
    
    if(keyBoardHieght == _keyBoardHieght)return;
    
    _keyBoardHieght = keyBoardHieght;
    [self setNewSizeWithController];
    
    [UIView animateWithDuration:_changeTime animations:^{
        if(self.keyBoardStatus == PWChatKeyBoardStatusDefault){
            self.bottom = kHeight-SafeAreaBottom_Height-kTopHeight;
        }else{
            self.bottom = kHeight-self.keyBoardHieght-kTopHeight;
        }
    } completion:nil];
    
}


//设置默认状态
-(void)setKeyBoardStatus:(PWChatKeyBoardStatus)keyBoardStatus{
    _keyBoardStatus = keyBoardStatus;
    
    if(_keyBoardStatus == PWChatKeyBoardStatusDefault){
        self.currentBtn.selected = NO;
        self.mTextView.hidden = NO;
        self.mKeyBordView.mCoverView.hidden = NO;
    }
}


//视图归位 设置默认状态 设置弹起的高度
-(void)SetPWChatKeyBoardInputViewEndEditing{
        self.keyBoardStatus = PWChatKeyBoardStatusDefault;
        [self endEditing:YES];
        self.keyBoardHieght = 0.0;
}


//语音10  表情11  其他功能12
-(void)btnPressed:(UIButton *)sender{
    
   
    switch (self.keyBoardStatus) {
            
            //默认在底部状态
        case PWChatKeyBoardStatusDefault:{

                self.keyBoardStatus = PWChatKeyBoardStatusAdd;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                self.keyBoardHieght = SafeAreaBottom_Height+PWChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            
        }
            break;
            
            //在编辑文本的状态
        case PWChatKeyBoardStatusEdit:{

                self.keyBoardStatus = PWChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                [self.mTextView endEditing:YES];
        }
            break;
    
            //在选择其他功能的状态
        case PWChatKeyBoardStatusAdd:{
            [self.mTextView becomeFirstResponder];
            _mKeyBordView.mCoverView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
}

//设置所有控件新的尺寸位置
-(void)setNewSizeWithBootm:(CGFloat)height{
    [self setNewSizeWithController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mTextView.height = height;
        self.height = 8 + 8 + self.mTextView.height;
        
        self.mTextBtn.height = self.mTextView.height;
        self.mTextBtn.bottom = self.height-PWChatTBottomDistence;
        self.mTextView.top = 0;
        self.mAddBtn.bottom = self.height-PWChatBBottomDistence;
        self.mKeyBordView.top = self.height;
        
        if(self.keyBoardStatus == PWChatKeyBoardStatusDefault){
            self.bottom = kHeight-SafeAreaBottom_Height-kTopHeight;
        }else{
            self.bottom = kHeight-kTopHeight-self.keyBoardHieght;
        }
        
    } completion:^(BOOL finished) {
        [self.mTextView.superview layoutIfNeeded];
    }];
}

//设置键盘和表单位置
-(void)setNewSizeWithController{
    
    CGFloat changeTextViewH = fabs(_textH - PWChatTextHeight);
    if(self.mTextView.hidden == YES) changeTextViewH = 0;
    CGFloat changeH = _keyBoardHieght + changeTextViewH;
    
   
    if(SafeAreaBottom_Height==0 && _keyBoardHieght!=0){
        changeH -= SafeAreaBottom_Height;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(PWChatKeyBoardInputViewHeight:changeTime:)]){
        [_delegate PWChatKeyBoardInputViewHeight:changeH changeTime:_changeTime];
    }
}

//拦截发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self startSendMessage];
        return NO;
    }
    
    return YES;
}

//开始发送消息
-(void)startSendMessage{
    NSString *message = [_mTextView.attributedText string];
    NSString *newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(message.length==0){
        
    }
    else if(_delegate && [_delegate respondsToSelector:@selector(PWChatKeyBoardInputViewBtnClick:)]){
        [_delegate PWChatKeyBoardInputViewBtnClick:newMessage];
    }
    
    _mTextView.text = @"";
    _textString = _mTextView.text;
    _mTextView.contentSize = CGSizeMake(_mTextView.contentSize.width, 30);
    [_mTextView setContentOffset:CGPointZero animated:YES];
    [_mTextView scrollRangeToVisible:_mTextView.selectedRange];
    _textH = PWChatTextHeight;
    [self setNewSizeWithBootm:_textH];
}


//监听输入框的操作 输入框高度动态变化
- (void)textViewDidChange:(UITextView *)textView{
    
    _textString = textView.text;
    
    //获取到textView的最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height);
    
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


#pragma SSChatKeyBordSymbolViewDelegate 底部视图按钮点击回调
//发送200  多功能点击10+
-(void)PWChatKeyBordViewBtnClick:(NSInteger)index{
    if(index==200){
        [self startSendMessage];
    }
    else if(index<200){
        if(_delegate && [_delegate respondsToSelector:@selector(PWChatKeyBoardInputViewBtnClickFunction:)]){
            [_delegate PWChatKeyBoardInputViewBtnClickFunction:index];
        }
    }
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end