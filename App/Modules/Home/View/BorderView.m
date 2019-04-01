//
//  BorderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BorderView.h"
@interface BorderView(){
UIBezierPath *path;
}
@end
@implementation BorderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIColor *color = [UIColor colorWithHexString:@"#DDE0E9"];
        [color set];
    //创建path
        path = [UIBezierPath bezierPath];
    //设置线宽
        path.lineWidth = 2;
    //线条拐角
        path.lineCapStyle = kCGLineCapRound;
    //终点处理
        path.lineJoinStyle = kCGLineJoinRound;

        [path moveToPoint:(CGPoint){Interval(16),1}];
        [path addLineToPoint:(CGPoint){ZOOM_SCALE(77)+Interval(16),1}];
        [path addLineToPoint:(CGPoint){ZOOM_SCALE(77)+Interval(31),ZOOM_SCALE(20)}];
        [path addLineToPoint:(CGPoint){ZOOM_SCALE(77)+Interval(16),ZOOM_SCALE(40)}];
        [path addLineToPoint:(CGPoint){Interval(16),ZOOM_SCALE(40)}];
        [path closePath];
         //根据坐标点连线
    
        [path stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2.lineWidth = 2;
    //线条拐角
    path2.lineCapStyle = kCGLineCapRound;
    //终点处理
    path2.lineJoinStyle = kCGLineJoinRound;
    [path2 moveToPoint:(CGPoint){ZOOM_SCALE(77)+Interval(16),1}];
    [path2 addLineToPoint:(CGPoint){ZOOM_SCALE(183)+Interval(16),1}];
    [path2 addLineToPoint:(CGPoint){ZOOM_SCALE(183)+Interval(31),ZOOM_SCALE(20)}];
    [path2 addLineToPoint:(CGPoint){ZOOM_SCALE(183)+Interval(16),ZOOM_SCALE(40)}];
    [path2 addLineToPoint:(CGPoint){ZOOM_SCALE(77)+Interval(16),ZOOM_SCALE(40)}];
    [path2 addLineToPoint:(CGPoint){ZOOM_SCALE(77)+Interval(31),ZOOM_SCALE(20)}];
    [path2 moveToPoint:(CGPoint){ZOOM_SCALE(77)+Interval(16),1}];
    [path2 closePath];
    [path2 stroke];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    path3.lineWidth = 2;
    //线条拐角
    path3.lineCapStyle = kCGLineCapRound;
    //终点处理
    path3.lineJoinStyle = kCGLineJoinRound;
    [path3 moveToPoint:(CGPoint){ZOOM_SCALE(183)+Interval(16),1}];
    [path3 addLineToPoint:(CGPoint){ZOOM_SCALE(277)+Interval(16),1}];
    [path3 addLineToPoint:(CGPoint){ZOOM_SCALE(277)+Interval(31),ZOOM_SCALE(20)}];
    [path3 addLineToPoint:(CGPoint){ZOOM_SCALE(277)+Interval(16),ZOOM_SCALE(40)}];
    [path3 addLineToPoint:(CGPoint){ZOOM_SCALE(183)+Interval(16),ZOOM_SCALE(40)}];
    [path3 addLineToPoint:(CGPoint){ZOOM_SCALE(183)+Interval(31),ZOOM_SCALE(20)}];
    [path3 moveToPoint:(CGPoint){ZOOM_SCALE(183)+Interval(16),1}];
    [path3 closePath];
    [path3 stroke];
    
    UIBezierPath *path4 = [UIBezierPath bezierPath];
    path4.lineWidth = 2;
    //线条拐角
    path4.lineCapStyle = kCGLineCapRound;
    //终点处理
    path4.lineJoinStyle = kCGLineJoinRound;
    [path4 moveToPoint:(CGPoint){ZOOM_SCALE(277)+Interval(16),1}];
    [path4 addLineToPoint:(CGPoint){kWidth-Interval(31),1}];
    [path4 addLineToPoint:(CGPoint){kWidth-Interval(16),ZOOM_SCALE(20)}];
    [path4 addLineToPoint:(CGPoint){kWidth-Interval(31),ZOOM_SCALE(40)}];
    [path4 addLineToPoint:(CGPoint){ZOOM_SCALE(277)+Interval(16),ZOOM_SCALE(40)}];
    [path4 addLineToPoint:(CGPoint){ZOOM_SCALE(277)+Interval(31),ZOOM_SCALE(20)}];
    [path4 moveToPoint:(CGPoint){ZOOM_SCALE(277)+Interval(16),1}];
    [path4 closePath];
    [path4 stroke];
}

@end
