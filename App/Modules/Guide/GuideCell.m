//
//  GuideCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "GuideCell.h"
#import "UIColor+Gradual.h"
@interface GuideCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIButton *beginBtn;


@end
@implementation GuideCell
-(void)setIndex:(NSInteger)index{
    _index = index;
    self.beginBtn.hidden = YES;
    if (_index == 0) {
      
        self.titleLab.text = NSLocalizedString(@"local.guide.Title1", @"");
        self.subTitleLab.text = NSLocalizedString(@"local.guide.SubTitle1", @"");
        self.backImgView.image = [UIImage imageNamed:@"page1"];
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.subTitleLab.mas_bottom).offset(ZOOM_SCALE(47));
            make.left.mas_equalTo(self.contentView.mas_left).offset(ZOOM_SCALE(7));
            make.width.offset(ZOOM_SCALE(362));
            make.height.offset(ZOOM_SCALE(350));
        }];
    }else if(_index == 1){
        
        self.titleLab.text = NSLocalizedString(@"local.guide.Title2", @"");
        self.subTitleLab.text = NSLocalizedString(@"local.guide.SubTitle2", @"");
        self.backImgView.image = [UIImage imageNamed:@"page2"];
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.subTitleLab.mas_bottom).offset(ZOOM_SCALE(38));
            make.left.mas_equalTo(self.contentView.mas_left).offset(ZOOM_SCALE(19));
            make.width.offset(ZOOM_SCALE(346));
            make.height.offset(ZOOM_SCALE(383));
        }];
    }else{
        
        self.titleLab.text = NSLocalizedString(@"local.guide.Title3", @"");
        self.subTitleLab.text = NSLocalizedString(@"local.guide.SubTitle3", @"");
        self.backImgView.image = [UIImage imageNamed:@"page3"];
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.subTitleLab.mas_bottom).offset(ZOOM_SCALE(14));
            make.left.mas_equalTo(self.contentView.mas_left).offset(ZOOM_SCALE(12));
            make.width.offset(ZOOM_SCALE(317));
            make.height.offset(ZOOM_SCALE(357));
        }];
        self.beginBtn.hidden = NO;
    }
}
-(void)layoutSubviews{
   
    [self.layer insertSublayer:[UIColor setGradualChangingColor:self.contentView fromColor:@"#6BAEF9" toColor:@"#427BF6"] atIndex:0];
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, ZOOM_SCALE(63)+kTopHeight-64, kWidth, ZOOM_SCALE(42)) font:MediumFONT(30) textColor:PWWhiteColor text:@""];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, ZOOM_SCALE(115)+kTopHeight-64, kWidth, ZOOM_SCALE(28)) font:RegularFONT(20) textColor:PWWhiteColor text:@""];
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subTitleLab];
    }
    return _subTitleLab;
}
-(UIButton *)beginBtn{
    if (!_beginBtn) {
        _beginBtn = [PWCommonCtrl buttonWithFrame:CGRectMake(0, kHeight-ZOOM_SCALE(63)-SafeAreaBottom_Height, kWidth, ZOOM_SCALE(25)) type:PWButtonTypeWord text:NSLocalizedString(@"local.ImmediatelyOpen", @"")];
        _beginBtn.titleLabel.font = MediumFONT(18);
        [_beginBtn setTitleColor:PWWhiteColor forState:UIControlStateNormal];
        [_beginBtn setTitleColor:PWWhiteColor forState:UIControlStateSelected];
        [_beginBtn addTarget:self action:@selector(beginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_beginBtn];
        _beginBtn.tag = 4;
        [self.contentView bringSubviewToFront:_beginBtn];
    }
    return _beginBtn;
}

-(UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_backImgView];
    }
    return _backImgView;
}
- (void)beginBtnClick:(UIButton *)button{
    if (self.itemClick) {
        self.itemClick(button.tag);
    }
}
@end
