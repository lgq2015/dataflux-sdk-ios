//
//  IssueSelectView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSelectView.h"
#import "TouchLargeButton.h"

#define LevelTag  200
#define TypeTag   300
@interface IssueSelectView()
@property (nonatomic, assign) CGFloat topCons;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) IssueLevel currSelLevel;
@property (nonatomic, assign) IssueType currSelType;
@property (nonatomic, assign) IssueViewType selViewType;
@property (nonatomic, strong) TouchLargeButton *selViewBtn;
@end
@implementation IssueSelectView
-(instancetype)initWithTop:(CGFloat)top{
    if (self) {
        self= [super init];
        _topCons = top;
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, self.topCons, kWidth, kHeight-self.topCons);
    self.hidden = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    UILabel *levelName = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(16), ZOOM_SCALE(35), ZOOM_SCALE(21)) font:RegularFONT(15) textColor:PWTextBlackColor text:@"等级"];
    [self.contentView addSubview:levelName];
   
    NSArray *levelNameAry = @[@"全部",@"严重",@"警告",@"提示"];
    CGFloat space = (kWidth-ZOOM_SCALE(76)*4-Interval(16)*2)/3.0;
    for (NSInteger i=0; i<levelNameAry.count; i++) {
        UIButton *button = [self selButton];
        [button setTitle:levelNameAry[i] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(Interval(16)+(ZOOM_SCALE(76)+space)*i, CGRectGetMaxY(levelName.frame)+Interval(10), ZOOM_SCALE(76), ZOOM_SCALE(38));
        button.tag = LevelTag+i;
        
        [button addTarget:self action:@selector(levelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *typeLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(113), ZOOM_SCALE(35), ZOOM_SCALE(21)) font:RegularFONT(15) textColor:PWTextBlackColor text:@"类型"];
    [self.contentView addSubview:typeLab];
    NSArray *typeNameAry = @[@"全部",@"监控",@"安全",@"费用",@"优化",@"提醒"];
    for (NSInteger i=0; i<typeNameAry.count; i++) {
        UIButton *button = [self selButton];
        [button setTitle:typeNameAry[i] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(Interval(16)+(ZOOM_SCALE(76)+space)*(i%4), CGRectGetMaxY(typeLab.frame)+Interval(10)+i/4*ZOOM_SCALE(51), ZOOM_SCALE(76), ZOOM_SCALE(38));
        button.tag = TypeTag+i;
        
        [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.selViewBtn = [[TouchLargeButton alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(265), ZOOM_SCALE(13), ZOOM_SCALE(13))];
    [self.selViewBtn setImage:[UIImage imageNamed:@"icon_noSelect"] forState:UIControlStateNormal];
    [self.selViewBtn setImage:[UIImage imageNamed:@"icon_succeed"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selViewBtn];
    [self.selViewBtn addTarget:self action:@selector(selViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *viewTypeTip = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(23)+ZOOM_SCALE(13), 0, ZOOM_SCALE(100), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTextBlackColor text:@"开启智能推荐"];
    viewTypeTip.centerY = self.selViewBtn.centerY;
    [self.contentView addSubview:viewTypeTip];
    UILabel *subTip = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(23)+ZOOM_SCALE(13), CGRectGetMaxY(viewTypeTip.frame)+2, ZOOM_SCALE(323), ZOOM_SCALE(32)) font:RegularFONT(11) textColor:PWSubTitleColor text:@"智能推荐功能为您过滤了一些不太影响您的应用或系统的情报，便于您能更有针对性地处理问题"];
    subTip.numberOfLines = 2;
    [self.contentView addSubview:subTip];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subTip.frame)+ZOOM_SCALE(16), kWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self.contentView addSubview:line];
    
    UIButton *cancle = [PWCommonCtrl buttonWithFrame:CGRectMake(Interval(16), CGRectGetMaxY(line.frame)+ZOOM_SCALE(14), ZOOM_SCALE(163), ZOOM_SCALE(40)) type:PWButtonTypeSummarize text:@"取消"];
    [cancle setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    cancle.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    UIButton *commit = [PWCommonCtrl buttonWithFrame:CGRectMake(CGRectGetMaxX(cancle.frame)+ZOOM_SCALE(17), CGRectGetMaxY(line.frame)+ZOOM_SCALE(14), ZOOM_SCALE(163), ZOOM_SCALE(40)) type:PWButtonTypeContain text:@"确定"];
    [commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancle];
    [self.contentView addSubview:commit];
}
-(UIButton *)selButton{
    UIButton *button = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeSummarize text:@""];
    button.titleLabel.font = RegularFONT(14);
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F0F9FF"]] forState:UIControlStateSelected];
    //设置边框的颜色
    [button setTitleColor:PWBlueColor forState:UIControlStateSelected];
    [button.layer setBorderColor:[UIColor colorWithHexString:@"#E4E4E4"].CGColor];
    return button;
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    self.isShow = YES;
    [view addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    SelectObject *sel = [[IssueListManger sharedIssueListManger] getCurrentSelectObject];
    self.currSelType = sel.issueType;
    self.currSelLevel = sel.issueLevel;
    self.selViewType = sel.issueViewType;
    UIButton *typeBtn = [self.contentView viewWithTag:(int)sel.issueType+TypeTag-1];
    typeBtn.selected = YES;
    [typeBtn.layer setBorderColor:PWBlueColor.CGColor];
    UIButton *levelBtn = [self.contentView viewWithTag:(int)sel.issueLevel+LevelTag-1];
    levelBtn.selected = YES;
    [levelBtn.layer setBorderColor:PWBlueColor.CGColor];
    self.selViewBtn.selected = self.selViewType == IssueViewTypeNormal;

    [_contentView setFrame:CGRectMake(0, -ZOOM_SCALE(400), kWidth,ZOOM_SCALE(400))];
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = NO;
        self.alpha = 1.0;
        _contentView.alpha =1.0;
        [_contentView setFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(400))];
        
    } completion:nil];
    
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(400))];
        _contentView.backgroundColor = PWWhiteColor;
        _contentView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTap)];
        [_contentView addGestureRecognizer:tap];
        [self addSubview:_contentView];
    }
    return _contentView;
}
- (void)levelButtonClick:(UIButton *)button{
    if ((NSInteger)self.currSelLevel == button.tag+1-LevelTag) {
        return;
    }else{
        UIButton *lastBtn = [self.contentView viewWithTag:LevelTag+(int)self.currSelLevel-1];
        lastBtn.selected = NO;
        [lastBtn.layer setBorderColor:[UIColor colorWithHexString:@"#E4E4E4"].CGColor];
        button.selected = YES;
        [button.layer setBorderColor:PWBlueColor.CGColor];
        self.currSelLevel = (IssueLevel)button.tag-LevelTag+1;
    }
    
}
- (void)typeButtonClick:(UIButton *)button{
    if ((NSInteger)self.currSelType == button.tag+1-TypeTag) {
        return;
    }else{
        UIButton *lastBtn = [self.contentView viewWithTag:TypeTag+(int)self.currSelType-1];
        lastBtn.selected = NO;
        [lastBtn.layer setBorderColor:[UIColor colorWithHexString:@"#E4E4E4"].CGColor];
        button.selected = YES;
        [button.layer setBorderColor:PWBlueColor.CGColor];
        self.currSelType = (IssueType)button.tag-TypeTag+1;
    }
}
- (void)contentTap{}

- (void)selViewBtnClick:(UIButton *)button{
    button.selected = !button.selected;
}
- (void)disMissView{
    if (self.disMissClick) {
        self.disMissClick();
    }
    self.isShow = NO;
    UIButton *typeBtn = [self.contentView viewWithTag:(int)self.currSelType+TypeTag-1];
    typeBtn.selected = NO;
    [typeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#E4E4E4"].CGColor];   UIButton *levelBtn = [self.contentView viewWithTag:(int)self.currSelLevel+LevelTag-1];
    levelBtn.selected = NO;
    [levelBtn.layer setBorderColor:[UIColor colorWithHexString:@"#E4E4E4"].CGColor];    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0;
        self.contentView.frame = CGRectMake(0, -ZOOM_SCALE(400), kWidth, ZOOM_SCALE(400));
         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [UIView commitAnimations];
}
- (void)commitClick{
    SelectObject *sel = [[IssueListManger sharedIssueListManger] getCurrentSelectObject];
    sel.issueLevel = self.currSelLevel;
    sel.issueType = self.currSelType;
    sel.issueViewType = self.selViewBtn.selected == YES?IssueViewTypeNormal:IssueViewTypeAll;
    [[IssueListManger sharedIssueListManger] setCurrentSelectObject:sel];
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectIssueWithSelectObject:)]){
        [self.delegate selectIssueWithSelectObject:sel];
    }
    [self disMissView];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
