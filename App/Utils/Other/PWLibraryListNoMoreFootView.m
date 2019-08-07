//
//  PWLibraryListNoMoreFootView.m
//  PWLibraryListView
//
//  Created by gokuai on 2018/4/25.
//  Copyright © 2018年 MYT. All rights reserved.
//

#import "PWLibraryListNoMoreFootView.h"

static CGFloat   const   kContentW             = 90;
static CGFloat   const   kContentH             = 20;


@implementation PWLibraryListNoMoreFootView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
    
}


-(void)setup{
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake((kWidth - kContentW)/2, (CGRectGetHeight(self.frame)-kContentH)/2, kContentW, kContentH)];
    text.text = NSLocalizedString(@"local.tip.NoMoreFooter", @"");
    text.textColor = [UIColor colorWithHexString:@"#D2D2D2"];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:14];
    text.textAlignment = NSTextAlignmentCenter;
    [self addSubview:text];
    
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(72,(CGRectGetHeight(self.frame) - 1)/2 , CGRectGetMinX(text.frame) - 72, 1)];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#DFE4E6"];
    [self addSubview:leftView];
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(text.frame),(CGRectGetHeight(self.frame) - 1)/2 , CGRectGetMinX(text.frame) - 72, 1)];
    rightView.backgroundColor = [UIColor colorWithHexString:@"#DFE4E6"];
    [self addSubview:rightView];
    
    
}


@end
