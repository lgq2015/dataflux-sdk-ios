//
//  ZTHandBookNoPicCell.m
//  App
//
//  Created by tao on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//
#import "ZTHandBookNoPicCell.h"
#define zt_sourceLabBottom 8.0
#define zt_titleLabBottom 11.0
#define seperatorLineH 4.0
@interface ZTHandBookNoPicCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@end

@implementation ZTHandBookNoPicCell
//用于设置分割线的高度
- (void)setFrame:(CGRect)frame {
    frame.size.height -= seperatorLineH;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLab.font =  RegularFONT(18);
    _sourceLab.font = RegularFONT(12);
}

- (void)setModel:(HandbookModel *)model{
    _model = model;
    _titleLab.text = model.title;
    _sourceLab.text = model.handbookName;
}
//区分是否是搜索中的cell
- (void)setIsSearch:(BOOL)isSearch{
    _isSearch = isSearch;
    _sourceLab.hidden = isSearch ? NO : YES;
}
//计算cell内容的总高度
- (CGFloat)caculateRowHeight:(HandbookModel *)model{
    self.model = model;
    [self layoutIfNeeded];
    CGFloat heigth = 0.0;
    if (_isSearch){
        heigth = CGRectGetMaxY(_sourceLab.frame) + zt_sourceLabBottom;
    }else{
        heigth = CGRectGetMaxY(_titleLab.frame) + zt_titleLabBottom;
    }
    return heigth ;
}

@end
