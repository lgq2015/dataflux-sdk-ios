//
//  GridViewItem.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/4.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "GridViewItem.h"
#import "GridViewModel.h"
@interface GridViewItem()
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UILabel *itemTitle;
@end
@implementation GridViewItem
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
}
- (void)setUpUI{
    [self.itemImg sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:[UIImage imageNamed:@""]];
    CGSize maximumLabelSize = CGSizeMake(ZOOM_SCALE(75), 34);//labelsize的最大值
    CGSize expectSize = [_itemTitle sizeThatFits:maximumLabelSize];

    self.itemTitle.frame = CGRectMake(ZOOM_SCALE(13), ZOOM_SCALE(66), expectSize.width, expectSize.height);
    CGFloat centerx = self.itemImg.center.x;
    _itemTitle.center = CGPointMake(centerx, _itemTitle.center.y);
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTp)];
    [self addGestureRecognizer:tp];
}
- (void)itemTp{
    if (self.itemClick) {
       self.itemClick(self.model.itemIndex);
    }
}
-(UIImageView *)itemImg{
    if (!_itemImg) {
        _itemImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(13), ZOOM_SCALE(8), ZOOM_SCALE(51.5), ZOOM_SCALE(51.5))];
        _itemImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_itemImg];
    }
    return _itemImg;
}
-(UILabel *)itemTitle{
    if (!_itemTitle) {
        _itemTitle = [[UILabel alloc]initWithFrame:CGRectMake(ZOOM_SCALE(1), ZOOM_SCALE(66), 75.5, ZOOM_SCALE(34))];
        _itemTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _itemTitle.font = [UIFont systemFontOfSize:12];
        _itemTitle.numberOfLines = 2;
        _itemTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_itemTitle];
    }
    return _itemTitle;
}
#pragma mark ========== 点击效果 ==========
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 8;
    self.layer.shadowOpacity = 0.07;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.shadowRadius = 0;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.shadowRadius = 0;
}


@end
