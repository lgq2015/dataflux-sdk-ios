//
//  DistrictCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "DistrictCell.h"
@interface DistrictCell()
@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation DistrictCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setTitle:(NSString *)title{
    self.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
    self.titleLab.text = title;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, ZOOM_SCALE(88), self.height) font:MediumFONT(16) textColor:PWRedColor text:@""];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLab.textColor = [UIColor colorWithHexString:@"#2A7AF7"];
        self.backgroundColor = PWWhiteColor;
    }else{
        self.titleLab.textColor = PWTitleColor;
        self.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
    }
    // Configure the view for the selected state
}

@end
