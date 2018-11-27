//
//  PWInfoInitialView.m
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/17.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWInfoInitialView.h"

@interface PWInfoInitialView ()
@property (nonatomic, strong) UILabel *tipsTitle;
@property (nonatomic, strong) UILabel *tipsContent;
@property (nonatomic, strong) UILabel *tipsSpecific;
@end
#define ZOOM_SCALE  (float)([[UIScreen mainScreen] bounds].size.width/360.0)
#define LOADIMAGE(file,ext) [[NSBundle mainBundle]pathForResource:file ofType:ext]

@implementation PWInfoInitialView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.06;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
}
- (void)setUpUI{
    
    if (!self.tipsTitle) {
        _tipsTitle = [[UILabel alloc]initWithFrame:CGRectMake(20*ZOOM_SCALE, 23*ZOOM_SCALE, 296*ZOOM_SCALE, 25*ZOOM_SCALE)];
        _tipsTitle.text = @"还在为无法发现 IT 问题而烦恼？";
        _tipsTitle.font = [UIFont systemFontOfSize:18];
        [self addSubview:_tipsTitle];
    }
    if (!self.tipsContent) {
        _tipsContent = [[UILabel alloc]initWithFrame:CGRectMake(20*ZOOM_SCALE, 64*ZOOM_SCALE, 300*ZOOM_SCALE, 40*ZOOM_SCALE)];
        _tipsContent.text = @"通过王教授连接您的云服务，即可获得专业的诊断与分析情报，为您及时发现问题，解决问题。";
        _tipsContent.numberOfLines = 2;
        _tipsContent.font = [UIFont systemFontOfSize:14];
        _tipsContent.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self addSubview:_tipsContent];
    }
    NSArray *btnImag = @[@"monitoring@2x",@"safe@2x",@"consume@2x",@"optimize@2x"];
    NSArray *iconNames = @[@"监控",@"安全",@"费用",@"优化"];
    for (int i=0; i<4; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((61+i*61)*ZOOM_SCALE, 133*ZOOM_SCALE, 30*ZOOM_SCALE, 30*ZOOM_SCALE)];
        imgView.tag = i+10;
        UILabel *iconName = [[UILabel alloc]initWithFrame:CGRectMake((61+i*61)*ZOOM_SCALE, 169*ZOOM_SCALE, 34*ZOOM_SCALE, 22*ZOOM_SCALE)];
        iconName.textAlignment  = NSTextAlignmentCenter;
        iconName.font = [UIFont systemFontOfSize:16];
        iconName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        iconName.text = iconNames[i];
        iconName.tag = i+60;
        NSString *name = [NSString stringWithFormat:@"res_PWInfoBoard/%@",btnImag[i]];
        CGPoint center = imgView.center;
        center.y = iconName.center.y;
        iconName.center = center;

        imgView.image = [UIImage imageWithContentsOfFile:LOADIMAGE(name, @"png")];
        imgView.contentMode = UIViewContentModeScaleAspectFit;

        [[self viewWithTag:i+10] removeFromSuperview];
        [[self viewWithTag:i+60] removeFromSuperview];
        [self addSubview:imgView];
        [self addSubview:iconName];


    }

    
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(20*ZOOM_SCALE, 213*ZOOM_SCALE, 296*ZOOM_SCALE, 1*ZOOM_SCALE)];
    lines.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    lines.tag = 20;
    [[self viewWithTag:20] removeFromSuperview];
    [self addSubview:lines];
    
    UIButton *serverConnectbtn = [[UIButton alloc]initWithFrame:CGRectMake(100*ZOOM_SCALE, 232*ZOOM_SCALE, 136*ZOOM_SCALE, 22*ZOOM_SCALE)];
    [serverConnectbtn setTitle:@"立即连接云服务" forState:UIControlStateNormal];
    [serverConnectbtn setTitleColor: [UIColor colorWithRed:255/255.0 green:78/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    serverConnectbtn.tag = 21;
    [[serverConnectbtn titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [serverConnectbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[self viewWithTag:21] removeFromSuperview];
    [self addSubview:serverConnectbtn];
}

#pragma mark --点击效果--
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowRadius = 1;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 5;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
