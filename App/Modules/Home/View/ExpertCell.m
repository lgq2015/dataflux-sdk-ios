//
//  ExpertCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ExpertCell.h"
@interface ExpertCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *myExpertLab;
@property (nonatomic, strong) UILabel *exclusiveLab;
@end
@implementation ExpertCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowOffset = CGSizeMake(0,4);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 4;
        self.layer.cornerRadius = 4;
        self.layer.shadowOpacity = 0.06;
    }
    
    return self;
}
-(void)setIsMore:(BOOL)isMore{
    _isMore = isMore;
    if (_isMore == YES) {
        self.nameLab.text = @"更多专家";
        self.nameLab.hidden = NO;
        self.myExpertLab.hidden = YES;
        self.exclusiveLab.hidden = YES;
    }
}
-(void)setData:(NSDictionary *)data{
    _data = data;
    self.myExpertLab.hidden = YES;
    self.exclusiveLab.hidden = YES;
    self.nameLab.hidden = NO;
    NSString *avatarName = _data[@"expertGroup"];
    NSURL *avatarUrl = [NSURL URLWithString:PW_ExpertAvatarSmall(avatarName)];
    [self.icon sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@""]];
    self.nameLab.text = _data[@"displayName"][@"zh_CN"];
    if ([avatarName isEqualToString:@"TAM"]) {
        self.nameLab.hidden = YES;
        self.exclusiveLab.hidden = NO;
        [self.myExpertLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.exclusiveLab.mas_bottom).offset(ZOOM_SCALE(1));
        }];
    }else{
        [self.myExpertLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLab.mas_bottom).offset(ZOOM_SCALE(1));
        }];
    }
    if (self.isInvite) {
        self.myExpertLab.hidden = NO;
        self.layer.shadowOffset = CGSizeMake(0,10);
        self.layer.shadowRadius = 4;
        
    }
}
    
-(void)layoutSubviews{
    self.backgroundColor = PWWhiteColor;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(ZOOM_SCALE(72));
        make.top.mas_equalTo(self).offset(ZOOM_SCALE(11));
        make.centerX.mas_equalTo(self);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(ZOOM_SCALE(6));
    }];
    [self.myExpertLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(ZOOM_SCALE(1));
        make.height.offset(ZOOM_SCALE(17));
    }];
    [self.exclusiveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(ZOOM_SCALE(6));
        make.height.offset(ZOOM_SCALE(24));
        make.width.offset(ZOOM_SCALE(94));
        make.centerX.mas_equalTo(self);
    }];
}
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.layer.masksToBounds = YES;
        _icon.contentMode =  UIViewContentModeScaleAspectFill;
        _icon.layer.cornerRadius = 36.0f;
        [self addSubview:_icon];
    }
    return _icon;
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWTextBlackColor text:@""];
        _nameLab.numberOfLines = 0;
        _nameLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLab];
    }
    return _nameLab;
}
-(UILabel *)myExpertLab{
    if (!_myExpertLab) {
        _myExpertLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(10) textColor:[UIColor colorWithHexString:@"#2A7AF7"] text:@"已邀请"];
        _myExpertLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_myExpertLab];
    }
    return _myExpertLab;
}
-(UILabel *)exclusiveLab{
    if (!_exclusiveLab) {
        _exclusiveLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:[UIColor colorWithHexString:@"#FFC163"] text:@"我的专属顾问"];
        _exclusiveLab.textAlignment = NSTextAlignmentCenter;
        _exclusiveLab.layer.borderWidth = 1;//边框宽度
        _exclusiveLab.layer.borderColor = [UIColor colorWithHexString:@"#FFC163"].CGColor;
        _exclusiveLab.layer.cornerRadius = 4.0f;
        [self addSubview:_exclusiveLab];
        
    }
    return _exclusiveLab;
}

@end
