//
//  RightTriangleView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RightTriangleView.h"

@implementation RightTriangleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect

{
    //设置背景颜色
    [[UIColor whiteColor]  set];
    UIRectFill([self bounds]);
    //拿到当前视图准备好的画板
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context, 0, 0);//设置起点
    
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
        
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    
    
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor redColor] setFill]; //设置填充色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
}

@end
