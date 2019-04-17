//
//  ZTHandBookHasPicCell.m
//  App
//
//  Created by tao on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTHandBookHasPicCell.h"
#define zt_sourceLabBottom 8
#define zt_imgViewBottom 16
#define seperatorLineH 4.0
@interface ZTHandBookHasPicCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImgViewHeightCons;
@end
@implementation ZTHandBookHasPicCell

//用于设置分割线的高度
- (void)setFrame:(CGRect)frame {
    frame.size.height -= seperatorLineH;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _imgViewWidthCons.constant = ZOOM_SCALE(90);
    _ImgViewHeightCons.constant = ZOOM_SCALE(90);
    _titleLab.font =  RegularFONT(18);
    _sourceLab.font = RegularFONT(12);
}

- (void)setModel:(HandbookModel *)model{
    _model = model;
    _titleLab.text = model.title;
    _sourceLab.text = model.handbookName;
    _model.imageUrl = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)_model.imageUrl,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,kCFStringEncodingUTF8));
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:nil];
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
        heigth = CGRectGetMaxY(_imgView.frame) + zt_imgViewBottom;
    }
    return heigth ;
}

@end
