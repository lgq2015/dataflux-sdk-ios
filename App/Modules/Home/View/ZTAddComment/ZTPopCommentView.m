//
//  ZTPopCommentView.m
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTPopCommentView.h"
#import "ZTPopCommentToolView.h"
#import "AtTeamMemberListVC.h"
#import "RootNavigationController.h"
#import "MemberInfoModel.h"
#import "ChooseChatStateView.h"
#import "ZhugeIOIssueHelper.h"
#import "iCloudManager.h"
#define PWChatTextMaxHeight     85
#define PWChatTextHeight        45
#define zt_topViewH 44.0
#define zt_toolViewH 44.0
#define zt_tabbarH   76
@interface ZTPopCommentView()<UITextViewDelegate,ChooseChatStateViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextView *mTextView;
@property (nonatomic, strong) UIWindow * window;
@property (nonatomic, strong) UIView *backgroundGrayView; //!<透明背景View
@property (nonatomic, strong) ZTPopCommentToolView *toolView;
@property (nonatomic, strong) ChatInputHeaderView *topView;
@property (nonatomic, strong) ChooseChatStateView *chooseStateView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect keyBoardFrame;
@property (nonatomic, assign) CGRect commentViewFrame;
@property (nonatomic, assign) CGFloat   textH;
@property (nonatomic, weak)   UIViewController  *viewController; //issueDetailsVC
@property (nonatomic, strong) NSMutableArray *choseMember;
@property (nonatomic, strong) NSMutableArray *rangeArray;

@end
@implementation ZTPopCommentView

- (instancetype)initWithFrame:(CGRect)frame WithController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewController = controller;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        self.backgroundColor = PWWhiteColor;
       
    }
    return self;
}

- (void)setOldData:(NSString *)oldData{
    _oldData = oldData;
   [self s_UI];
}
- (void)show{
    self.backgroundGrayView.hidden = NO;
    self.hidden = NO;
    [[[ZhugeIOIssueHelper new] eventJoinDiscuss] track];

}
- (void)s_UI{
    if(!_backgroundGrayView){
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self];
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
         tap.delegate = self;
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
    WeakSelf
    self.topView.changeChatStateClick = ^(){
        [weakSelf changeChatState];
    };
    [self textViewDidChange:self.mTextView];
    NSLog(@"zhangtao----%@",self);
}
- (void)viewTap{
    
}
- (void)changeChatState{
    if (self.topView.unfoldBtn.selected) {
        
    }else{
        [self zhankaiBtnClick:self.topView.unfoldBtn];
    }
    [self.chooseStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.width.offset(ZOOM_SCALE(180));
        make.left.mas_equalTo(self).offset(16);
        make.height.offset(3*ZOOM_SCALE(45));
    }];
//    self.backgroundGrayView.userInteractionEnabled = NO;
    [self.chooseStateView showWithState:(NSInteger)self.state];
}
-(void)dismiss{
    if (self.topView.unfoldBtn.selected) {
        [self zhankaiBtnClick:self.topView.unfoldBtn];
    }
    //将数据传出去
    NSDictionary *dic = @{@"content":self.mTextView.text,@"state":[NSNumber numberWithInteger:self.state]};
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
-(ChooseChatStateView *)chooseStateView{
    if (!_chooseStateView) {
        _chooseStateView= [[ChooseChatStateView alloc]init];
        _chooseStateView.delegate = self;
        [self addSubview:_chooseStateView];
    }
    return _chooseStateView;
}
-(NSMutableArray *)rangeArray{
    if (!_rangeArray) {
        _rangeArray = [NSMutableArray new];
    }
    return _rangeArray;
}
-(NSMutableArray *)choseMember{
    if (!_choseMember) {
        _choseMember = [NSMutableArray new];
    }
    return _choseMember;
}
-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,0, kWidth, kHeight);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [_backgroundGrayView addGestureRecognizer:tap];
    }
    return _backgroundGrayView;
}

- (UITextView *)mTextView{
    if (!_mTextView){
        _mTextView = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:NSLocalizedString(@"local.EnterYourContent", @"") font:RegularFONT(14)];
        _mTextView.delegate = self;
        _mTextView.text = _oldData;
        [self addSubview:_mTextView];
    }
    return _mTextView;
}
- (ZTPopCommentToolView *)toolView{
    if (!_toolView){
        _toolView = [[ZTPopCommentToolView alloc] initWithFrame:CGRectZero];
        [_toolView.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolView.photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolView.atBtn addTarget:self action:@selector(atBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_toolView.iCloudBtn addTarget:self action:@selector(presentDocumentPicker) forControlEvents:UIControlEventTouchUpInside];
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
        [self.chooseStateView disMissView];
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
#pragma mark ========== UITextViewDelegate ==========
//拦截发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    __block BOOL isAt = NO;
    if ([text isEqualToString:@""]) {
        
        [[self.rangeArray copy] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx1, BOOL * _Nonnull stop) {
            NSArray *rangeAry =[self rangeOfSubString:obj inString:self.oldData];
            [rangeAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSRange strrange = [obj rangeValue];
                if(strrange.location<=range.location&&range.location<(strrange.location+strrange.length)) {
                    NSMutableString *str = [NSMutableString stringWithString:self.oldData];
                    [str deleteCharactersInRange:strrange];
                    self.mTextView.text = str;
                    self.oldData = str;
                    DLog(@"self.mTextView.text ==%@;",self.mTextView.text)
                    isAt = YES;
                    [self.rangeArray removeObjectAtIndex:idx1];
                    *stop = YES;
                }
            }];
            if(isAt){
                *stop = YES;
            }
        }];
        if (isAt) {
            [self textViewDidChange:textView];
            return NO;
        }
    }
        //删除
    
    return YES;
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

- (void)sendBtnClick{
   [self.chooseStateView disMissView];
    __block NSString *message = [_mTextView.attributedText string];
    NSString *newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(newMessage.length==0){
        return;
    }
    __block NSMutableDictionary *accountIdMap = [NSMutableDictionary dictionary];
    __block NSMutableDictionary *serviceMap = [NSMutableDictionary dictionary];
    if (self.choseMember.count>0) {
        [[self.choseMember copy] enumerateObjectsUsingBlock:^(MemberInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *name = [NSString stringWithFormat:@"@%@",obj.name];
            if([message containsString:name]) {
                if (obj.isSpecialist) {
                    [serviceMap setObject:obj.name forKey:obj.ISP];
                    message = [message stringByReplacingOccurrencesOfString:name withString:[NSString stringWithFormat:@"@%@",obj.ISP]];
                }else{
                    [accountIdMap setObject:obj.name forKey:obj.memberID];
                    message = [message stringByReplacingOccurrencesOfString:name withString:[NSString stringWithFormat:@"@%@",obj.memberID]];
                    
                }
            }
        }];
        NSMutableDictionary *atInfoJSON = [NSMutableDictionary new];
        
        if (serviceMap.allKeys.count > 0) {
            [atInfoJSON setObject:serviceMap forKey:@"serviceMap"];
        }
        if (accountIdMap.allKeys.count>0) {
            [atInfoJSON setObject:accountIdMap forKey:@"accountIdMap"];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(IssueKeyBoardInputViewSendAtText:atInfoJSON:)]) {
            [self.delegate IssueKeyBoardInputViewSendAtText:message atInfoJSON:atInfoJSON];
        }
      
        [self.choseMember removeAllObjects];
        [self.rangeArray removeAllObjects];
    }else{
       NSString *newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(IssueKeyBoardInputViewSendText:)]) {
            [self.delegate IssueKeyBoardInputViewSendText:newMessage];
        }
    }
    _mTextView.text = @"";
    _oldData = _mTextView.text;
    _textH = PWChatTextHeight;
    [self dismiss];
    
}
- (void)photoBtnClick{
    [self.chooseStateView disMissView];
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(IssueKeyBoardInputViewChooeseImageClick)]) {
        [self.delegate IssueKeyBoardInputViewChooeseImageClick];
    }
}
- (void)atBtnClick{
    [self dismiss];
    WeakSelf
    AtTeamMemberListVC *setVC = [[AtTeamMemberListVC alloc] init];
    setVC.chooseMembers = ^(NSArray *chooseArr){
       [weakSelf dealAtMessageWithArray:chooseArr];
    };
    setVC.DisMissBlock = ^(){
       [weakSelf.mTextView becomeFirstResponder];
       [weakSelf show];
    };
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:setVC];
    [self.viewController presentViewController:nav animated:YES completion:nil];
}
- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for(int i =0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = {i,subStr.length};
            [rangeArray addObject: [NSValue valueWithRange:range]];
        }
    }
    return rangeArray;
}
- (void)dealAtMessageWithArray:(NSArray *)array{
    [self.mTextView becomeFirstResponder];
    NSMutableString *addStr = [NSMutableString stringWithString:self.mTextView.text];
    NSRange range = [self.mTextView selectedRange];
    if(array.count == 0){
        return;
    }
     __block  NSString *insertStr;
    [array enumerateObjectsUsingBlock:^(MemberInfoModel *newObj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block  BOOL isNew = YES;
        if (self.choseMember.count == 0) {
            [self.choseMember addObjectsFromArray:array];
        }else{
            [[self.choseMember copy] enumerateObjectsUsingBlock:^(MemberInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.memberID isEqualToString:newObj.memberID]) {
                    isNew = NO;
                    *stop = YES;
                }
            }];
            if(isNew){
                [self.choseMember addObject:newObj];
            }
        }
        [self.rangeArray addObject:[NSString stringWithFormat:@"@%@ ",newObj.name]];
        insertStr = [NSString stringWithFormat:@"@%@ ",newObj.name];
        [addStr insertString:insertStr atIndex:range.location];
    }];
    
    
    self.mTextView.text =addStr;
    [self textViewDidChange:self.mTextView];
    [self.mTextView setSelectedRange:NSMakeRange(range.location+insertStr.length, 0)];
}
- (void)ChooseChatStateViewCellIndex:(NSInteger)index{
    self.state = (IssueDealState)(index);
}
@end
