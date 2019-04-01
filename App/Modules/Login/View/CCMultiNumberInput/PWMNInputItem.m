//
//  PWMNInputItem.m
//  PWMutiNumberInput
//
//  Created by 胡蕾蕾 on 2018/11/5.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWMNInputItem.h"

@interface PWMNInputItem()
@property (nonatomic, strong) UIView *line;
@end
@implementation PWMNInputItem
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PWBackgroundColor;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
}
- (void)setUpUI{
    self.inputView.backgroundColor = [UIColor clearColor];
    self.line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    
}
-(void)warning{
    self.line.backgroundColor = [UIColor colorWithHexString:@"D50000"];
}
- (void)setNormalState{
    self.line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
}
-(UIView *)line{
    if(!_line){
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 31*self.zoom, 30*self.zoom, 1)];
        _line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
        [self addSubview:_line];
    }
    return _line;
}
-(UILabel *)inputView{
    if(!_inputView){
        _inputView = [[UILabel alloc]initWithFrame:CGRectMake(5*self.zoom, 2*self.zoom, 20*self.zoom, 28*self.zoom)];
        _inputView.font = [UIFont systemFontOfSize:20];
        _inputView.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _inputView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_inputView];
    }
    return _inputView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
