//
//  MineMessageCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MineMessageCell.h"
#import "RightTriangleView.h"
#import "MineMessageModel.h"

@interface MineMessageCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *sourceLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) RightTriangleView *triangleView;

@end
@implementation MineMessageCell
-(void)setFrame:(CGRect)frame{
   
    frame.origin.y += Interval(2);
    frame.size.height -= Interval(2);
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(16));
        make.top.mas_equalTo(self).offset(Interval(13));
        make.height.offset(ZOOM_SCALE(25));
    }];
    [self.sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(16));
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(6));
        make.width.offset(ZOOM_SCALE(54));
        make.height.offset(ZOOM_SCALE(24));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourceLab.mas_right).offset(Interval(15));
        make.centerY.mas_equalTo(self.sourceLab);
        make.height.offset(ZOOM_SCALE(17));
    }];
}
-(void)setModel:(MineMessageModel *)model{
    _model = model;
    self.titleLab.text = _model.title;
    UIColor *color;
    NSString *type;
    if ([_model.messageType isEqualToString:@"team"]) {
        color = [UIColor colorWithHexString:@"#2EB5F3"];
        type = @"团队";
    }else if([_model.messageType isEqualToString:@"account"]){
        color = [UIColor colorWithHexString:@"#936AF2"];
        type = @"账号";
    }else if([_model.messageType isEqualToString:@"issue_source"]){
        color = [UIColor colorWithHexString:@"#3B85F8"];
        type = @"情报源";
    }else if([_model.messageType isEqualToString:@"service_package"]){
        color = [UIColor colorWithHexString:@"#3B85F8"];
        type = @"服务";
    }else{
        color = [UIColor colorWithHexString:@"#3B85F8"];
        type = @"不详";
    }
    [self.sourceLab setTextColor:color];
    self.sourceLab.text = type;
    self.sourceLab.layer.borderColor = color.CGColor;
    self.triangleView.hidden = _model.isReaded;
    self.timeLab.text = [NSString getLocalDateFormateUTCDate:_model.updateTime formatter:@"yyyy-MM-dd'T'HH:mm:ssZ"];
}
- (RightTriangleView *)triangleView{
    if (!_triangleView) {
        _triangleView = [[RightTriangleView alloc]initWithFrame:CGRectMake(kWidth-8, 0, 8, 8)];
        [self addSubview:_triangleView];
    }
    return _triangleView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)sourceLab{
    if (!_sourceLab) {
        _sourceLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:[UIColor colorWithHexString:@"#2EB5F3"] text:@""];
        _sourceLab.layer.cornerRadius = 4.;//边框圆角大小
        _sourceLab.layer.masksToBounds = YES;
        _sourceLab.layer.borderWidth = 1;//边框宽度
        _sourceLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_sourceLab];
    }
    return _sourceLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:[UIColor colorWithHexString:@"#C7C7CC"] text:@""];
        [self addSubview:_timeLab];
    }
    return _timeLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
