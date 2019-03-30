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
@property (nonatomic, strong) UILabel *sourceLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *noImgLab; //图片加载不出来时 提示label
@property (nonatomic, strong) UILabel *topStateLab;
@end

@implementation PWNewsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    frame.origin.y += Interval(4);
    frame.size.height -= Interval(4);
    [super setFrame:frame];
}

#pragma mark ========== 有图 有标题 ==========
- (void)createSingleImgUI{
    [self.iconImgVie mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.width.height.offset(ZOOM_SCALE(90));
    }];
    
    self.titleLab.preferredMaxLayoutWidth = 20;
    self.titleLab.numberOfLines = 3;
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconImgVie.mas_left).offset(-Interval(20));
        make.top.mas_equalTo(self.contentView).offset(Interval(11));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
    }];
    self.titleLab.numberOfLines = 3;
    self.iconImgVie.hidden = NO;
   
    [self.iconImgVie sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    if (self.model.isStarred) {
        self.timeLab.hidden = YES;
        self.topStateLab.hidden =NO;
        [self.topStateLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.top.mas_equalTo(self.iconImgVie.mas_bottom);
            make.width.offset(ZOOM_SCALE(40));
            make.height.offset(ZOOM_SCALE(22));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }else{
        self.timeLab.hidden = NO;
        self.topStateLab.hidden = YES;
        [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.right.mas_equalTo(self.contentView).offset(-Interval(16));
            make.height.offset(ZOOM_SCALE(17));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }
    
    
}

- (void)createTextUI{
    self.iconImgVie.hidden = YES;
    self.timeLab.hidden = NO;
    self.titleLab.numberOfLines = 2;
    self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(32);
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.top.mas_equalTo(self.contentView).offset(Interval(11));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
    }];
    
    if (self.model.isStarred) {
        self.timeLab.hidden = YES;
        self.topStateLab.hidden =NO;
        [self.topStateLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(28));
            make.width.offset(ZOOM_SCALE(40));
            make.height.offset(ZOOM_SCALE(22));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }else{
        self.timeLab.hidden = NO;
        self.topStateLab.hidden = YES;
        [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.model.type ==NewListCellTypText) {
                make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(28));
            }
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.right.mas_equalTo(self.contentView).offset(-Interval(16));
            make.height.offset(ZOOM_SCALE(17));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }
}


-(void)setModel:(NewsListModel *)model{
    _model = model;
    if (_model.isStarred) {
        self.timeLab.hidden = YES;
        self.topStateLab.hidden = NO;
    }else{
        self.timeLab.hidden = NO;
        self.topStateLab.hidden = YES;
    }
    self.iconImgVie.hidden = _model.type == NewListCellTypeSingleImg?NO:YES;
    self.titleLab.numberOfLines = _model.type == NewListCellTypeSingleImg?3:2;
    self.timeLab.text = _model.topic;
   
    self.titleLab.text = _model.title;
    self.titleLab.textColor = _model.read?PWReadColor:PWBlackColor;
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
    switch (_model.type) {
        case NewListCellTypeSingleImg:{
            [self createSingleImgUI];
            self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(50)-ZOOM_SCALE(90);
            [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.iconImgVie.mas_left).offset(-20);
            }];
        }
            break;
        case NewListCellTypText:
            [self createTextUI];
            break;
        default:
            break;
    }
    
}
-(void)layoutSubviews{
    self.backgroundColor = [UIColor whiteColor];
    self.noImgLab.hidden = YES;
    self.iconImgVie.backgroundColor = PWBackgroundColor;
   
}
-(UILabel *)topStateLab{
    if (!_topStateLab) {
        _topStateLab = [[UILabel alloc]init];
        _topStateLab.text = @"置顶";
        _topStateLab.backgroundColor = PWWhiteColor;
        _topStateLab.textColor = [UIColor colorWithHexString:@"6F85FF"];
        _topStateLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
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
        _titleLab.font = MediumFONT(18);
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
- (CGFloat)heightForModel:(NewsListModel *)model{
    [self setModel:model];
    [self layoutIfNeeded];
    CGFloat cellHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+Interval(4);
    return cellHeight;
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
