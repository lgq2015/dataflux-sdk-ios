//
//  PWNewsListCell.m
//  PWNewsList
//
//  Created by 胡蕾蕾 on 2018/8/24.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWNewsListCell.h"

static NSString *const NoImgTips =@"该图片无法显示";
@interface PWNewsListCell()
@property (nonatomic, strong) UIImageView *iconImgVie;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UILabel *sourceLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *noImgLab; //图片加载不出来时 提示label

@end

@implementation PWNewsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -= ZOOM_SCALE(4);
    [super setFrame:frame];
}

- (void)createSingleImgUI{
    self.backgroundColor = [UIColor whiteColor];
    self.iconImgVie.hidden = NO;
    self.timeLab.hidden = NO;
    self.titleLab.hidden = NO;
    self.subtitleLab.hidden = NO;
    self.sourceLab.hidden = NO;
    self.iconImgVie.frame = CGRectMake(ZOOM_SCALE(240), ZOOM_SCALE(20), ZOOM_SCALE(100), ZOOM_SCALE(86));
    [self.iconImgVie sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
//    self.titleLab.frame = CGRectMake(ZOOM_SCALE(20), ZOOM_SCALE(20), ZOOM_SCALE(220), 23);
    self.subtitleLab.frame = CGRectMake(ZOOM_SCALE(20), ZOOM_SCALE(48), ZOOM_SCALE(200), ZOOM_SCALE(40));
    self.titleLab.text = self.model.title;
    
    self.subtitleLab.text = self.model.subtitle;
    float top = ZOOM_SCALE(96);
    if (self.model.source != nil && self.model.source.length>0) {
        self.sourceLab.text = self.model.source;
        [self.sourceLab sizeToFit];
         self.sourceLab.hidden = NO;
    }else{
         self.sourceLab.hidden = YES;
    }
    if (![self.model.time isEqualToString:@""]) {
        self.timeLab.hidden = NO;
        self.timeLab.text = self.model.time;
    }else{
        self.timeLab.hidden = YES;
    }
    
    if (self.model.showFlag == YES) {
        self.tipView.hidden =NO;
    }else{
        _tipView.hidden = YES;
    }
}
- (void)createFillImgUI{
    self.iconImgVie.hidden = NO;
    self.iconImgVie.frame = self.contentView.bounds;
    if([self.model.imageUrl isEqualToString:@""]){
        self.iconImgVie.frame = CGRectMake(ZOOM_SCALE(155), ZOOM_SCALE(28), ZOOM_SCALE(205), ZOOM_SCALE(90));
        self.iconImgVie.image = [UIImage imageNamed:@"loadingImgError"];
        self.noImgLab.hidden = NO;
    }
    [self.iconImgVie sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageNamed:@"loadingImgError"]];
    self.timeLab.hidden = YES;
    self.tipView.hidden = YES;
    self.titleLab.hidden = YES;
    self.subtitleLab.hidden = YES;
    self.sourceLab.hidden = YES;
}
- (void)createTextUI{
    self.iconImgVie.hidden = YES;
    self.timeLab.hidden = NO;
    self.titleLab.hidden = NO;
    self.subtitleLab.hidden = NO;
    self.sourceLab.hidden = NO;
    self.titleLab.frame = CGRectMake(ZOOM_SCALE(20), ZOOM_SCALE(20), ZOOM_SCALE(320), ZOOM_SCALE(22));
    self.titleLab.text = self.model.title;
    self.subtitleLab.frame = CGRectMake(ZOOM_SCALE(20), ZOOM_SCALE(48), ZOOM_SCALE(320), ZOOM_SCALE(40));
    self.subtitleLab.text = self.model.subtitle;
    if (self.model.showFlag == YES) {
        self.tipView.hidden =NO;
    }else{
        _tipView.hidden = YES;
    }

    if (self.model.source != nil && self.model.source.length>0) {
        self.sourceLab.text = self.model.source;
        [self.sourceLab sizeToFit];
        self.sourceLab.hidden = NO;
    }else{
        self.sourceLab.hidden = YES;
    }
    if (![self.model.time isEqualToString:@""]) {
        self.timeLab.hidden = NO;
        self.timeLab.text = self.model.time;
        [self.timeLab sizeToFit];
    }else{
         self.timeLab.hidden = YES;
    }

}

-(void)layoutSubviews{
    self.backgroundColor = [UIColor whiteColor];
    self.noImgLab.hidden = YES;
    self.iconImgVie.backgroundColor = [UIColor whiteColor];
    switch (self.model.type) {
            case NewListCellTypeSingleImg:
            [self createSingleImgUI];
            break;
            case NewListCellTypeFillImg:
            [self createFillImgUI];
            break;
            case NewListCellTypText:
            [self createTextUI];
            break;
    }
}

-(UIImageView *)iconImgVie{
    if (!_iconImgVie) {
        _iconImgVie = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImgVie.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgVie.backgroundColor = [UIColor whiteColor];
        _iconImgVie.clipsToBounds = YES;
        [self.contentView addSubview:_iconImgVie];
    }
    return _iconImgVie;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1/1.0];
        _timeLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)subtitleLab{
    if (!_subtitleLab){
        _subtitleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _subtitleLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        _subtitleLab.font = [UIFont systemFontOfSize:14.0f];
        _subtitleLab.numberOfLines = 2;
        [self.contentView addSubview:_subtitleLab];
    }
    return _subtitleLab;
}
-(UILabel *)sourceLab{
    if (!_sourceLab) {
        _sourceLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _sourceLab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1/1.0];
        _sourceLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_sourceLab];
    }
    return _sourceLab;
}
-(UIView *)tipView{
    if (!_tipView) {
        _tipView = [[UIView alloc]initWithFrame:CGRectZero];
        _tipView.backgroundColor = [UIColor colorWithRed:255/255.0 green:78/255.0 blue:0/255.0 alpha:1/1.0];
        _tipView.layer.cornerRadius = ZOOM_SCALE(4);
        [self.contentView addSubview:_tipView];
    }
    return _tipView;
}

-(UILabel *)noImgLab{
    if (!_noImgLab) {
        _noImgLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _noImgLab.textColor =  [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        _noImgLab.font = [UIFont systemFontOfSize:16];
        _noImgLab.text = NoImgTips;
        [self.contentView addSubview:_noImgLab];
    }
    return _noImgLab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
