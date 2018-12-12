//
//  MonitorListCell.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/26.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "MonitorListCell.h"
@interface MonitorListCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *attrsLab;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *descsLab;
@property (nonatomic, strong) UILabel *suggestionLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *imgBackView;
@end
@implementation MonitorListCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += ZOOM_SCALE(12);
    frame.origin.y += ZOOM_SCALE(15);
    frame.size.height -= ZOOM_SCALE(15);
    frame.size.width -= ZOOM_SCALE(24);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    [super setFrame:frame];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 创建UI
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

-(void)setModel:(MonitorListModel *)model{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView).with.offset(ZOOM_SCALE(18));
        make.left.mas_equalTo(ZOOM_SCALE(12));
        make.right.mas_equalTo(ZOOM_SCALE(12));
    }];
    self.titleLab.text = model.title;
    //情报摘要分为三种状态情况（无摘要，云账号，云账号+其他）
    id top = self.titleLab;
    if (model.icon.length>0) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab).with.offset(ZOOM_SCALE(20));
            make.left.mas_equalTo(ZOOM_SCALE(18));
            make.width.mas_equalTo(ZOOM_SCALE(53));
            make.height.mas_equalTo(ZOOM_SCALE(34));
        }];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@""]];
        [self.attrsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView).with.offset(ZOOM_SCALE(20));
            make.top.equalTo(self.titleLab).with.offset(ZOOM_SCALE(20));
            make.right.mas_equalTo(ZOOM_SCALE(12));
        }];
        self.attrsLab.text = model.attrs;
        CGPoint center = self.iconImgView.center;
        if (CGRectGetMaxY(self.imageView.frame)>CGRectGetMaxY(self.attrsLab.frame)) {
            center.x = self.attrsLab.center.x;
            self.attrsLab.center = center;
            top = self.iconImgView;
        }else{
            center.y = self.iconImgView.center.y;
            self.iconImgView.center = center;
            top = self.attrsLab;
        }
    }
    if (model.descs.length>0) {
        [self.descsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top).with.offset(ZOOM_SCALE(10));
            make.left.mas_equalTo(ZOOM_SCALE(17));
            make.right.mas_equalTo(ZOOM_SCALE(17));
        }];
        self.descsLab.text = model.descs;
        top = self.descsLab;
    }
    if (model.suggestion.length>0) {
        [self.suggestionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top).with.offset(ZOOM_SCALE(15));
            make.left.mas_equalTo(ZOOM_SCALE(17));
            make.right.mas_equalTo(ZOOM_SCALE(17));
        }];
        self.suggestionLab.text = model.suggestion;
        top = self.suggestionLab;
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top).with.offset(ZOOM_SCALE(10));
        make.left.mas_equalTo(ZOOM_SCALE(17));
        make.right.mas_equalTo(ZOOM_SCALE(17));
        make.bottom.mas_equalTo(ZOOM_SCALE(25));
    }];
    self.timeLab.text = model.time;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZOOM_SCALE(336), ZOOM_SCALE(8))];
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_lineView.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer * maskLayer = [CAShapeLayer new];
        maskLayer.frame = _lineView.layer.bounds;
        maskLayer.path = maskPath.CGPath;
        _lineView.layer.mask = maskLayer;
        [self addSubview:_lineView];
    }
    return _lineView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _titleLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _titleLab.numberOfLines = 0;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImgView];
    }
    return _iconImgView;
}

-(UILabel *)attrsLab{
    if (!_attrsLab){
        _attrsLab = [[UILabel alloc]init];
        _attrsLab.font = [UIFont systemFontOfSize:14];
        _attrsLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _attrsLab.numberOfLines = 0;
        [self addSubview:_attrsLab];
    }
    return _attrsLab;
}
-(UILabel *)descsLab{
    if (!_descsLab) {
        _descsLab = [[UILabel alloc]init];
        _descsLab.font = [UIFont systemFontOfSize:14];
        _descsLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _descsLab.textAlignment = NSTextAlignmentLeft;
        _descsLab.numberOfLines = 0;
        [self addSubview:_descsLab];
    }
    return _descsLab;
}
-(UILabel *)suggestionLab{
    if (!_suggestionLab) {
        _suggestionLab = [[UILabel alloc]init];
        _suggestionLab.font = [UIFont systemFontOfSize:14];
        _suggestionLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _suggestionLab.textAlignment = NSTextAlignmentLeft;
        _suggestionLab.numberOfLines = 0;
        [self addSubview:_suggestionLab];
    }
    return _suggestionLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.numberOfLines = 0;
        [self addSubview:_timeLab];
    }
    return _timeLab;
}
// 根绝数据计算cell的高度
- (CGFloat)heightForModel:(MonitorListModel *)model{
    [self setModel:model];
    [self layoutIfNeeded];
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+30;
    return cellHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
