//
//  PWChatKeyBordView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatKeyBordView.h"

@implementation PWChatKeyBordView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = PWChatCellColor;
    
        _functionView = [[PWChatKeyBordFunctionView alloc]initWithFrame:self.bounds];
        
        _functionView.delegate = self;
    
        [self addSubview:_functionView];
        _functionView.userInteractionEnabled = YES;
        
        _mCoverView = [[UIView alloc]initWithFrame:self.bounds];
        _mCoverView.backgroundColor = PWChatCellColor;
        [self addSubview:_mCoverView];
        _mCoverView.hidden = NO;
        
        UIView *topLine = [UIView new];
        topLine.frame = CGRectMake(0, 0, self.width, 0.5);
        topLine.backgroundColor = CellLineColor;
        [self addSubview:topLine];
        
      
    }
    return self;
}

#pragma PWChatKeyBordSymbolViewDelegate 发送200
-(void)PWChatKeyBordSymbolViewBtnClick:(NSInteger)index{
    [self PWChatKeyBordButtonPressed:index];
}



#pragma PWChatKeyBordFunctionDelegate  其他功能按钮点击回调 500+
-(void)PWChatKeyBordFunctionViewBtnClick:(NSInteger)index{
    [self PWChatKeyBordButtonPressed:index];
}

//发送200  多功能点击10+
-(void)PWChatKeyBordButtonPressed:(NSInteger)index{
    if(_delegate && [_delegate respondsToSelector:@selector(PWChatKeyBordViewBtnClick:)]){
        [_delegate PWChatKeyBordViewBtnClick:index];
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
