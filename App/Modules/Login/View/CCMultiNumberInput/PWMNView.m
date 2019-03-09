//
//  PWMNView.m
//  PWMultiNumberInput
//
//  Created by 胡蕾蕾 on 2018/11/8.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWMNView.h"
#import "PWMNInputItem.h"
@interface PWMNView()<UITextFieldDelegate>
//记录当前选中的tag值
@property (nonatomic, assign) NSInteger seletTag;
@property (nonatomic, assign) NSInteger flogIndex;//记录是否跳转到其他的编辑文本上面
@property (nonatomic, assign) CGFloat keyboardheight;
@property (nonatomic, strong) UITextField *inputTf;
@property (nonatomic, strong) NSMutableArray<PWMNInputItem*> *itemAry;
@property (nonatomic, assign) BOOL isWarning;
@end

#define DELETEBUTTONTAG 20000
@implementation PWMNView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.codeView_IsFirstResponder) {
        PWMNInputItem *item = [self viewWithTag:self.seletTag];
        item.inputView.text = @"";
        self.inputTf.enabled = YES;
        [self.inputTf becomeFirstResponder];
        [self codeViewBecomeFirstResponderWithTag:self.seletTag];
        if (self.seletTag== self.count) {
            NSString *str = [self.codeString substringToIndex:self.seletTag-1];
            self.codeString = str;
            if(self.deleteBlock){
                self.deleteBlock();
            }
        }
        if (self.seletTag == 1 && self.isWarning) {
            [self.itemAry enumerateObjectsUsingBlock:^(PWMNInputItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setNormalState];
            }];
            self.isWarning = NO;
        }
    }else{
        [self.inputTf resignFirstResponder];
    }
}
-(void)codeView_showWarnState{
    [self.itemAry enumerateObjectsUsingBlock:^(PWMNInputItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj warning];
    }];
    self.seletTag = 1;
    self.isWarning = YES;
    [self codeView_BecomeFirstResponder];
}
#pragma mark ========== private method ==========
- (void)createItem{
    self.seletTag = 1;
    self.isCodeViewStatus = YES;
    self.codeString = @"";
    CGFloat width = self.frame.size.width;
    CGFloat zoom = width/(self.count*30+14*(self.count-1))*1.0;
    CGFloat spacing = 14*zoom;
    CGFloat itemW = 30*zoom;
    CGPoint center = self.center;
    center.y -= self.frame.origin.y;
    CGFloat left = (width-itemW*self.count-spacing*(self.count-1))/2.0;
    self.itemAry = [NSMutableArray new];
    for (NSInteger i=0; i<self.count; i++) {
        PWMNInputItem *item = [[PWMNInputItem alloc]initWithFrame:CGRectMake(left+i*(itemW+spacing), 5, itemW, 30*zoom)];
        item.zoom = zoom;
        center.x = item.center.x;
        item.center = center;
        item.tag = i+1;
        [self.itemAry addObject:item];
        [self addSubview:item];
    }
     [self codeView_BecomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField{
    PWMNInputItem *item = [self viewWithTag:self.seletTag];
    if (textField.text.length == 2) {
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *str2 = [self.codeString stringByAppendingString:str];
        self.codeString = str2;
        item.inputView.text = str;
        if (self.seletTag == self.count) {
            self.inputTf.frame = CGRectZero;
            if (self.completeBlock) {
                self.completeBlock(self.codeString);
            }
            self.seletTag +=1;
           self.inputTf.text = @" ";
        }else{
            self.seletTag += 1;
            [self codeViewBecomeFirstResponderWithTag:self.seletTag];
        }
    }else if(textField.text.length == self.count){
        NSString *text = textField.text;
        __weak typeof(self) weakSelf = self;
        [self setValueWithString:textField.text completed:^(BOOL is) {
            if (weakSelf.completeBlock) {
                weakSelf.completeBlock(text);
            }
        }];
//        [self codeView_ResignFirstResponder];
    }else if(textField.text.length == 1 || textField.text.length == 0){
        if(self.seletTag>1){
        NSString *str = [self.codeString substringToIndex:self.seletTag-2];
        self.codeString = str;
        self.seletTag -= 1;
        item.inputView.text = @"";
        [self codeViewBecomeFirstResponderWithTag:self.seletTag];
        }else{
            textField.text = @" ";
        }
    }else {
        
        NSString *text = [[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] substringToIndex:self.count];
        
        __weak typeof(self) weakSelf = self;
        [self setValueWithString:text completed:^(BOOL is) {
            if (weakSelf.completeBlock) {
                weakSelf.completeBlock(text);
            }
        }];
    }
}
//整个控件成为第一响应
-(void)codeView_BecomeFirstResponder
{   [self.inputTf becomeFirstResponder];
    [self codeViewBecomeFirstResponderWithTag:self.seletTag];
}

//整个控件辞去第一响应
-(void)codeView_ResignFirstResponder
{
    self.inputTf.text = @"";
    [self.inputTf resignFirstResponder];
    self.codeView_IsFirstResponder = NO;
}


- (void)codeViewBecomeFirstResponderWithTag:(NSInteger)tag{
    self.seletTag = tag;
    PWMNInputItem *item = [self viewWithTag:self.seletTag];
    CGRect textFrame = [self convertRect:item.inputView.frame fromView:item];
    item.inputView.text = @"";
    self.inputTf.frame = textFrame;
    self.inputTf.text = @" ";
}

#pragma mark =========UITextField代理=================

//如果从本控件直接辞去第一响应.转到别的控件上时.无法获取.
//通过查找规律正常点击该控件辞去的响应会调两次
//通过点击其他控件辞去响应的方式调用一次
//所以在这里使用标记的方式
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.flogIndex ++;
    return YES;
}


- (void)setItemEmpty{
    self.seletTag = 1;
    self.codeString = @"";
    for (PWMNInputItem *item in self.subviews) {
        item.inputView.text = @" ";
    }
}

-(void)setValueWithString:(NSString *)value completed:(completedBlock)completedBlock{
    if ([value isEqualToString:@""]) {
        [self setItemEmpty];
    }else if(value.length>self.count){
        for (NSInteger i=0; i<self.count; i++) {
            PWMNInputItem *item = [self viewWithTag:i+1];
            NSString *str =[value substringWithRange:NSMakeRange(i,1)];
            item.inputView.text = str;
        }
        self.codeString = value;
        [self codeView_ResignFirstResponder];
        self.seletTag = self.count;
    }else{
        for (NSInteger i=0; i<value.length; i++) {
            PWMNInputItem *item = [self viewWithTag:i+1];
            NSString *str =[value substringWithRange:NSMakeRange(i,1)];
            item.inputView.text = str;
        }
        if (value.length<self.count) {
            for (NSInteger i=value.length; i<=self.count; i++) {
                PWMNInputItem *item = [self viewWithTag:i+1];
                item.inputView.text = @"";
            }
        }
        self.seletTag = value.length+1;
        self.codeString = value;
        [self codeView_ResignFirstResponder];
    }
    
    if (completedBlock) {
        completedBlock(YES);
    }
}

-(UITextField *)inputTf{
    if (!_inputTf) {
        _inputTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ZOOM_SCALE(20), ZOOM_SCALE(28))];
        _inputTf.keyboardType = UIKeyboardTypeNumberPad;
        [_inputTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _inputTf.tintColor =  [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
        [self addSubview:_inputTf];
    }
    return _inputTf;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
