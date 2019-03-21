//
//  TriangleLeft.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/21.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TriangleLeft.h"

@implementation TriangleLeft

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
    
    CGContextMoveToPoint(context, self.bounds.size.width, 0);//设置起点
    
    CGContextAddLineToPoint(context, 0, self.bounds.size.height/2.0);
    
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor colorWithHexString:@"#5090F5"] setFill]; //设置填充色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
}

@end
