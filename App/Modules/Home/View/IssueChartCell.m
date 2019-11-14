//
//  IssueChartCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartCell.h"
#import "ClassifyModel.h"
#import "TouchLargeButton.h"
#import "IssueListManger.h"
@interface IssueChartCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) TouchLargeButton *arrowBtn;
@end
@implementation IssueChartCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += Interval(16);
    frame.size.width -= Interval(32);
    frame.size.height -= Interval(10);
    [super setFrame:frame];
}
-(void)setModel:(ClassifyModel *)model{
    _model = model;
    self.titleLab.text = model.title;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(Interval(12), ZOOM_SCALE(46), kWidth-Interval(56), SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self addSubview:line];
    self.layer.cornerRadius = 4;
    [self initCardItem];
}
- (void)initCardItem{
    self.arrowBtn.hidden = NO;
    NSArray *level = @[[NSString stringWithFormat:@"%lu",(unsigned long)self.model.dangerAry.count],[NSString stringWithFormat:@"%lu",(unsigned long)self.model.warningAry.count],[NSString stringWithFormat:@"%lu",(unsigned long)self.model.commonAry.count]];
    NSArray *title = @[NSLocalizedString(@"local.danger", @""),NSLocalizedString(@"local.warning", @""),NSLocalizedString(@"local.info", @"")];
    NSArray *color = @[PWDangerColor,PWWarningColor,PWCommonColor];
    CGFloat itemSpacing = ZOOM_SCALE(85);
    CGFloat left = (kWidth-Interval(32)-itemSpacing*2-ZOOM_SCALE(30)*3)/2.00;
    for(NSInteger i=0; i<title.count; i++) {
        TouchLargeButton *countLab = [[TouchLargeButton alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(58), ZOOM_SCALE(50), ZOOM_SCALE(33))];
        [countLab setTitle:level[i] forState:UIControlStateNormal];
        countLab.titleLabel.font = BOLDFONT(24);
        [countLab setTitleColor:color[i] forState:UIControlStateNormal];
        countLab.tag = i+100;
        [[self viewWithTag:i+100] removeFromSuperview];
        [self addSubview:countLab];
        UILabel *nameLab = [PWCommonCtrl lableWithFrame:CGRectMake(left+i*(ZOOM_SCALE(30)+itemSpacing), ZOOM_SCALE(94), ZOOM_SCALE(30), ZOOM_SCALE(18)) font:RegularFONT(13) textColor:PWTextBlackColor text:title[i]];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.tag = i+200;
        [[self viewWithTag:i+200] removeFromSuperview];
        [self addSubview:nameLab];
        [countLab sizeToFit];
        countLab.centerX = nameLab.centerX;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTap:)];
        [countLab addGestureRecognizer:tap];
        [nameLab addGestureRecognizer:tap];
        countLab.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        [countLab addTarget:self action:@selector(itemTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
-(void)itemTap:(UIButton *)button{
    
    if (button.tag == 100 || button.tag == 200) {
        if (self.block) {
            self.block(IssueLevelDanger);
        }
    }else if(button.tag == 101 || button.tag ==201){
        if (self.block) {
            self.block(IssueLevelWarning);
        }
    }else{
        if (self.block) {
            self.block(IssueLevelCommon);
        }
    }
}
-(void)arrowBtnClick{
    if (self.block) {
        self.block(IssueLevelAll);
    }
}
-(TouchLargeButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [[TouchLargeButton alloc]initWithFrame:CGRectMake(kWidth-Interval(80)-ZOOM_SCALE(22), ZOOM_SCALE(12), ZOOM_SCALE(100), ZOOM_SCALE(22))];
        _arrowBtn.largeWidth = kWidth*2-Interval(64);
        [_arrowBtn setImage:[UIImage imageNamed:@"icon_nextgray"] forState:UIControlStateNormal];
        [_arrowBtn addTarget:self action:@selector(arrowBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_arrowBtn];
    }
    return _arrowBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(12), ZOOM_SCALE(12), ZOOM_SCALE(100), ZOOM_SCALE(22)) font:BOLDFONT(16) textColor:PWTextBlackColor text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
