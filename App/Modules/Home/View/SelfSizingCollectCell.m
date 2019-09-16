//
//  SelfSizingCollectCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/9/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelfSizingCollectCell.h"
#define itemHeight ZOOM_SCALE(32)

@implementation SelfSizingCollectCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = PWWhiteColor;
        // 用约束来初始化控件:
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment =NSTextAlignmentCenter;
        self.textLabel.font = RegularFONT(13);
        self.textLabel.textColor = PWTextBlackColor;
        self.textLabel.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
        self.textLabel.layer.cornerRadius = 5;
        self.textLabel.layer.masksToBounds  = YES;
        [self.contentView addSubview:self.textLabel];
#pragma mark — 如果使用CGRectMake来布局,是需要在preferredLayoutAttributesFittingAttributes方法中去修改textlabel的frame的
        // self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
#pragma mark — 如果使用约束来布局,则无需在preferredLayoutAttributesFittingAttributes方法中去修改cell上的子控件l的frame
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            make.height.equalTo(@(itemHeight));                // 高度
            make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        }];
    }
    return self;
}

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect rect = [self.textLabel.text boundingRectWithSize:CGSizeMake(kWidth-20, itemHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: RegularFONT(13)} context:nil];
    rect.size.width+=24;
    rect.size.height+=14;
    attributes.frame = rect;
    return attributes;
    
}

@end
