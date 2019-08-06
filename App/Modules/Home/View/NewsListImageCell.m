//
//  NewsListImageCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NewsListImageCell.h"
#import "NewsListModel.h"
@interface NewsListImageCell ()
@property (nonatomic, strong) UIImageView *iconImgVie;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *sourceLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *topStateLab;
@end
@implementation NewsListImageCell
-(void)setFrame:(CGRect)frame{
    frame.origin.y += Interval(4);
    frame.size.height -= Interval(4);
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(NewsListModel *)model{
    _model = model;
    _model = model;
    if (_model.isStarred) {
        self.timeLab.hidden = YES;
        self.topStateLab.hidden = NO;
    }else{
        self.timeLab.hidden = NO;
        self.topStateLab.hidden = YES;
    }
    self.iconImgVie.hidden = _model.type == NewListCellTypeSingleImg?NO:YES;
    self.timeLab.text = _model.topic;
    
    self.titleLab.text = _model.title;
    self.titleLab.textColor = _model.read?PWReadColor:PWBlackColor;
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                 forHTTPHeaderField:@"Accept"];
    self.model.imageUrl = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self.model.imageUrl,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,kCFStringEncodingUTF8));
    [self.iconImgVie sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageWithColor:PWBackgroundColor]];
}


-(void)layoutSubviews{
    self.backgroundColor = [UIColor whiteColor];
    self.iconImgVie.backgroundColor = PWBackgroundColor;
    self.titleLab.numberOfLines = 3;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconImgVie.mas_left).offset(-Interval(20));
        make.top.mas_equalTo(self.contentView).offset(Interval(15));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
    }];
    self.iconImgVie.hidden = NO;
    [self.iconImgVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.width.height.offset(ZOOM_SCALE(90));
    }];
    
    if (self.model.isStarred) {
        self.timeLab.hidden = YES;
        self.topStateLab.hidden =NO;
        [self.topStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.top.mas_equalTo(self.iconImgVie.mas_bottom);
            make.width.offset(ZOOM_SCALE(40));
            make.height.offset(ZOOM_SCALE(22));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }else{
        self.timeLab.hidden = NO;
        self.topStateLab.hidden = YES;
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.right.mas_equalTo(self.contentView).offset(-Interval(16));
            make.height.offset(ZOOM_SCALE(17));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }
}
-(UILabel *)topStateLab{
    if (!_topStateLab) {
        _topStateLab = [[UILabel alloc]init];
        _topStateLab.text = NSLocalizedString(@"local.Stick", @"");
        _topStateLab.backgroundColor = PWWhiteColor;
        _topStateLab.textColor = [UIColor colorWithHexString:@"6F85FF"];
        _topStateLab.font =   RegularFONT(14);
        _topStateLab.textAlignment = NSTextAlignmentCenter;
        _topStateLab.layer.cornerRadius = 4.0f;
        _topStateLab.layer.masksToBounds = YES;
        _topStateLab.layer.borderWidth = 1;//边框宽度
        _topStateLab.layer.borderColor = [UIColor colorWithHexString:@"6F85FF"].CGColor;
        [self.contentView addSubview:_topStateLab];
    }
    return _topStateLab;
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
        _timeLab.textColor = [UIColor colorWithHexString:@"C7C7CC"];
        _timeLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.textColor = PWTextBlackColor;
        _titleLab.numberOfLines = 2;
        _titleLab.font = RegularFONT(18);
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent: event];
    self.backgroundColor = PWWhiteColor;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = PWWhiteColor;
}

@end
