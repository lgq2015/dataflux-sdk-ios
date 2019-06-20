//
//  CalendarArrowView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarArrowView.h"
#import "LTSCalendarAppearance.h"
@interface CalendarArrowView()
@property (nonatomic, strong) TouchLargeButton *arrowBtn;
@end
@implementation CalendarArrowView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.backgroundColor = PWBackgroundColor;
    UIView *arrowContent = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(6)+16)];
    arrowContent.backgroundColor = PWWhiteColor;
    [self addSubview:arrowContent];
    [arrowContent addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(arrowContent);
        make.width.height.offset(ZOOM_SCALE(18));
    }];
    UIView *dateContent = [[UIView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(6)+Interval(24), kWidth, ZOOM_SCALE(33))];
    dateContent.backgroundColor = PWWhiteColor;
    [self addSubview:dateContent];
    [dateContent addSubview:self.selDateLab];
    [self.selDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(dateContent);
        make.height.offset(ZOOM_SCALE(22));
    }];
//    dateContent.layer.shadowOffset = CGSizeMake(0,2);
//    dateContent.layer.shadowColor = [UIColor colorWithHexString:@"#627084"].CGColor;
//    dateContent.layer.shadowRadius = 5;
//    dateContent.layer.shadowOpacity = 0.2;
//    dateContent.clipsToBounds = NO;
    [dateContent addSubview:self.backTodayBtn];
//    dateContent.layer.shadowOffset = CGSizeMake(0,8);
//    dateContent.layer.shadowColor = [UIColor blackColor].CGColor;
//    dateContent.layer.shadowOpacity = 0.06;
//    dateContent.clipsToBounds = NO;
    [self.backTodayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(dateContent).offset(-16);
        make.centerY.mas_equalTo(dateContent);
        make.width.offset(ZOOM_SCALE(60));
        make.height.offset(ZOOM_SCALE(21));
    }];
    
}
-(TouchLargeButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [[TouchLargeButton alloc]init];
        [_arrowBtn setImage:[UIImage imageNamed:@"arrow_downs"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"arrow_ups"] forState:UIControlStateSelected];
        [_arrowBtn addTarget:self action:@selector(arrowBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _arrowBtn.largeHeight = 10;
    }
    return _arrowBtn;
}
-(UILabel *)selDateLab{
    if (!_selDateLab) {
        _selDateLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(15) textColor:PWTextBlackColor text:@""];
        _selDateLab.textAlignment = NSTextAlignmentCenter;
    }
    return _selDateLab;
}
-(TouchLargeButton *)backTodayBtn{
    if (!_backTodayBtn) {
        _backTodayBtn = [[TouchLargeButton alloc]init];
        _backTodayBtn.largeHeight = 10;
        _backTodayBtn.layer.borderWidth = 1;
        _backTodayBtn.layer.borderColor = PWSubTitleColor.CGColor;
        _backTodayBtn.layer.cornerRadius = 4;
        [_backTodayBtn setTitle:@"回到今天" forState:UIControlStateNormal];
        _backTodayBtn.titleLabel.font = RegularFONT(13);
        [_backTodayBtn setTitleColor:PWSubTitleColor forState:UIControlStateNormal];
        [_backTodayBtn addTarget:self action:@selector(backTodayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTodayBtn;
}
- (void)arrowBtnClick{
    self.arrowBtn.selected = !self.arrowBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(arrowClickWithUnfold:)]) {
        [self.delegate arrowClickWithUnfold:self.arrowBtn.selected];
    }
}
-(void)backTodayBtnClick{
    if(self.delegate && [self.delegate respondsToSelector:@selector(backToday)]){
        [self.delegate backToday];
    }
    
}
-(void)setArrowUp:(BOOL)arrowUp{
    _arrowUp = arrowUp;
    self.arrowBtn.selected = arrowUp;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
