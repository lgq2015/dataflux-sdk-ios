//
//  CopyLable.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CopyLable.h"
@interface CopyLable()
@property (nonatomic, strong) UIPasteboard *pasteboard;

@end
@implementation CopyLable
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
        self.pasteboard = [UIPasteboard generalPasteboard];
        [self attachLongTapHandle];
    }
    return self;
}
- (void)attachLongTapHandle {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self becomeFirstResponder]; //UILabel默认是不能响应事件的，所以要让它成为第一响应者
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    [menuVC setTargetRect:self.frame inView:self.superview]; //定位Menu
    [menuVC setMenuVisible:YES animated:YES]; //展示Menu
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    if (action == @selector(paste:)) {
        return NO;
    }
    if (action == @selector(delete:)) {
        return NO;
    }
    if (action == @selector(selectAll:)) {
        return NO;
    }
    if (action == @selector(cut:)) {
        return NO;
    }
    return NO;
}

- (void)copy:(id)sender {
    NSLog(@"copy");
    self.pasteboard.string = self.text;
}

- (void)paste:(id)sender {
    NSLog(@"paste");
}

- (void)delete:(id)sender {
    NSLog(@"delete");
}

- (void)selectAll:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
}


- (void)cut:(id)sender {
    NSLog(@"cut");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
