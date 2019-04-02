//
//  NetworkToolboxView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NetworkToolboxView.h"
@interface NetworkToolboxView()
@property (nonatomic, strong) UIView *contentView;
@end
@implementation NetworkToolboxView

-(instancetype)init{
    if (self) {
        self= [super init];
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(314))];
        _contentView.backgroundColor = PWWhiteColor;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, Interval(33), kWidth, ZOOM_SCALE(25))];
        title.text = @"网络工具箱";
        title.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = PWTextBlackColor;
        [self addSubview:_contentView];
        [_contentView addSubview:title];
        UIButton *cancle = [[UIButton alloc]init];
        [cancle setBackgroundImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
        [cancle addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancle];
        [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentView).offset(38);
            make.right.mas_equalTo(_contentView).offset(-16);
            make.width.height.offset(14);
        }];
        NSArray *iconAry = @[@"icon_ip",@"icon_inquiry",@"icon_dns",@"icon_whois",@"icon_nslook",@"icon_ping",@"icon_port",@"icon_routing"];
        NSArray *nameAry = @[@"IP 查询",@"备案查询",@"DNS 查询",@"whois 查询",@"nslook 查询",@"Ping 查询",@"端口检测",@"路由追踪"];
        for (NSInteger i=0; i<iconAry.count; i++) {
            UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconAry[i]]];
            CGFloat left = i%2==0?ZOOM_SCALE(41):ZOOM_SCALE(206);
            CGFloat top = (i/2)*ZOOM_SCALE(56)+ZOOM_SCALE(78);
            icon.frame = CGRectMake(left, top, ZOOM_SCALE(32), ZOOM_SCALE(32));
            icon.tag = i+1;
            icon.contentMode = UIViewContentModeScaleAspectFit;
            [_contentView addSubview:icon];
            UILabel *name = [[UILabel alloc]init];
            name.text = nameAry[i];
            name.font =  RegularFONT(16);
            name.textColor = PWTextBlackColor;
            name.tag = i+51;
            icon.userInteractionEnabled = YES;
            name.userInteractionEnabled = YES;
            [_contentView addSubview:name];
            [name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(icon.mas_right).offset(ZOOM_SCALE(14));
                make.centerY.mas_equalTo(icon);
                make.height.offset(ZOOM_SCALE(22));
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
            [icon addGestureRecognizer:tap];
            [name addGestureRecognizer:tap];
                                        
            
        }
    }
}

- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, -ZOOM_SCALE(314), kWidth, ZOOM_SCALE(314))];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, 0 , kWidth, ZOOM_SCALE(314))];
        
    } completion:nil];
    
}
- (void)disMissView{
    [_contentView setFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(314))];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                         [_contentView setFrame:CGRectMake(0, -ZOOM_SCALE(314), kWidth, ZOOM_SCALE(314))];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                     }];

}
- (void)itemClick:(UITapGestureRecognizer *)tap{
    [self disMissView];
    NSInteger i = tap.view.tag>50?tap.view.tag-50:tap.view.tag;
    PWToolType type = PWToolTypePing;
    switch (i) {
        case 1:
            type = PWToolTypeIP;
            break;
        case 2:
            type = PWToolTypeWebsiteRecord;
            break;
        case 3:
            type = PWToolTypeDNS;
            break;
        case 4:
            type = PWToolTypeWhois;
            break;
        case 5:
            type = PWToolTypeNslookup;
            break;
        case 6:
            type = PWToolTypePing;
            break;
        case 7:
            type = PWToolTypePortDetection;
            break;
        case 8:
            type = PWToolTypeTraceroute;
            break;
    }
    if (self.itemClick) {
        self.itemClick(type);
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
