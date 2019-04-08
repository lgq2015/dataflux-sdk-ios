//
//  FounctionIntroCell.m
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//
#define zt_margin 13.0
#define zt_right_margin 20.0
#define zt_maxDesH 150.0
#import "FounctionIntroCell.h"
#import "NSString+Regex.h"
@interface FounctionIntroCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidthCons;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@end
@implementation FounctionIntroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _contentLabelWidthCons.constant = kWidth - zt_margin - zt_right_margin;
}

- (void)setModel:(FounctionIntroductionModel *)model{
    _model = model;
    _versionLab.text = model.version;
    _timeLab.text = [[NSString getLocalDateFormateUTCDate:model.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ssZ"] accurateTimeStr];
    _descLab.text = model.des;
    CGFloat desH = [self getHeightFromString:model.des];
    //isShowMoreButton 标识是否点击过moreBtn
    if (desH > zt_maxDesH && !_model.isShowMoreButton){
        _moreBtn.hidden = NO;
        _descLab.numberOfLines = 3;
    }else{
        _moreBtn.hidden = YES;
        _descLab.numberOfLines = 0;
    }
}
//计算cell内容的总高度
- (CGFloat)caculateRowHeight:(FounctionIntroductionModel *)model{
    self.model = model;
    [self layoutIfNeeded];
    CGFloat heigth = CGRectGetMaxY(_descLab.frame) + zt_margin;
    return heigth ;
}

//获取描述文本高度
- (CGFloat)getHeightFromString:(NSString *)string{
    return [string zt_getHeight:_descLab.font width:kWidth - zt_margin - zt_right_margin];
}

- (IBAction)moreClick:(UIButton *)sender {
    _model.isShowMoreButton = @"false";
    if(_delegate && [_delegate respondsToSelector:@selector(didClickMoreBtn:)]){
        [_delegate didClickMoreBtn:self];
    }
}


@end
