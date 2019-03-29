//
//  WebItemView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "WebItemView.h"
#define CollectionImgTag 200
@interface WebItemView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) WebItemViewStyle style;
@property (nonatomic, assign) CGFloat itemHeight;
@end
@implementation WebItemView
-(instancetype)initWithStyle:(WebItemViewStyle)style{
    if (self) {
        self= [super init];
        self.style = style;
        [self setupContent];
    }
    return self;
}
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
    if (self.style == WebItemViewStyleNoShare) {
        self.itemHeight = 38;
    }else{
        self.itemHeight = 76;
    }
    self.contentView.frame = CGRectMake(kWidth-166, -self.itemHeight, 150, self.itemHeight);
   
        self.contentView.frame = CGRectMake(kWidth-166, -self.itemHeight, 150, self.itemHeight);
    
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-166, -self.itemHeight, 150, self.itemHeight)];
        _contentView.backgroundColor = PWWhiteColor;
        _contentView.layer.cornerRadius = 8;
        UIView *share = [self dropItemWithData:@{@"icon":@"web_share",@"title":@"分享"}];
        share.frame = CGRectMake(0, 0, 150, 38);
        share.tag = 10;
        [_contentView addSubview:share];
        if (self.style == WebItemViewStyleNormal) {
            UIView *collect = [self dropItemWithData:@{@"icon":@"icon_collection",@"title":@"收藏"}];
            collect.frame = CGRectMake(0, 39, 150, 38);
            collect.tag = 20;
            [_contentView addSubview:collect];
        }
        if (self.style == WebItemViewStyleCollect) {
            UIView *collect = [self dropItemWithData:@{@"icon":@"icon_canclecollect",@"title":@"取消收藏"}];
            collect.frame = CGRectMake(0, 39, 150, 38);
            collect.tag = 20;
            [_contentView addSubview:collect];
        }
        _contentView.layer.shadowOffset = CGSizeMake(0,2);
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.shadowRadius = 8;
        _contentView.layer.shadowOpacity = 0.06;
        [self addSubview:_contentView];
    }
    return _contentView;
}
-(UIView *)dropItemWithData:(NSDictionary *)data{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 38)];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:data[@"icon"]]];
    icon.frame = CGRectMake(19, 9, 20, 20);
    [view addSubview:icon];
    UILabel *title =[PWCommonCtrl lableWithFrame:CGRectMake(55, 8, 80, 22) font:[UIFont systemFontOfSize:16] textColor:PWBlackColor text:data[@"title"]];
    [view addSubview:title];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
    [view addGestureRecognizer:tap];
    return view;
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(kWidth-166,12+kTopHeight, 150, self.itemHeight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(kWidth-166, 12+kTopHeight, 150, self.itemHeight)];
        
    } completion:nil];
    
}

- (void)disMissView{
    [_contentView setFrame:CGRectMake(kWidth-166, 12+kTopHeight, 150, self.itemHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                     }];
    
}
- (void)itemClick:(UITapGestureRecognizer *)tap{
    [self disMissView];
    if (self.itemClick) {
        self.itemClick(tap.view.tag);
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
