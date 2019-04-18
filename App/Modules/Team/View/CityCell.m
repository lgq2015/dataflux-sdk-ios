//
//  CityCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CityCell.h"
@interface CityCell()
@end
@implementation CityCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        // 用约束来初始化控件:
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment =NSTextAlignmentCenter;
        self.titleLab.backgroundColor = PWWhiteColor;
        self.layer.cornerRadius = 4.0f;//边框圆角大小
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;//边框宽度
        self.layer.borderColor = [UIColor colorWithHexString:@"#C7C7CC"].CGColor;
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            make.height.offset(ZOOM_SCALE(40));                // 高度
            make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        }];
    }
    return self;
}
-(void)setCityTitle:(NSString *)cityTitle{
    self.titleLab.text = cityTitle;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.titleLab.backgroundColor = PWGrayColor;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.titleLab.backgroundColor = PWWhiteColor;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.titleLab.backgroundColor = PWWhiteColor;
}
- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.titleLab.textColor = [UIColor colorWithHexString:@"#2A7AF7"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#2A7AF7"].CGColor;
    }else{
        self.titleLab.textColor = PWTitleColor;
        self.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#C7C7CC"].CGColor;
    }
}

@end
