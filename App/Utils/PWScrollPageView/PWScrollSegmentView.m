//
//  PWScrollSegmentView.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/16.
//  Copyright © 2018 hll. All rights reserved.
//

#import "PWScrollSegmentView.h"
#import "PWCustomLabel.h"
#import "UIView+PWFrame.h"

@interface PWScrollSegmentView(){
    CGFloat _currentWidth;
    NSUInteger _currentIndex;
    NSUInteger _oldIndex;
}
// 滚动条
@property (weak, nonatomic) UIView *scrollLine;

// 附加的按钮
@property (weak, nonatomic) UIButton *extraBtn;
// 所有标题的设置
@property (strong, nonatomic) PWSegmentStyle *segmentStyle;
// 所有的标题
@property (strong, nonatomic) NSArray *titles;
/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray *titleLabels;
// 缓存计算出来的每个标题的宽度
@property (nonatomic, strong) NSMutableArray *titleWidths;
// 响应标题点击
@property (copy, nonatomic) TitleBtnOnClickBlock titleBtnOnClick;
@property (strong, nonatomic) NSArray *selectedColorRgb;
@property (strong, nonatomic) NSArray *normalColorRgb;
@end
@implementation PWScrollSegmentView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect )frame segmentStyle:(PWSegmentStyle *)segmentStyle titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick {
    if (self = [super initWithFrame:frame]) {
        self.segmentStyle = segmentStyle;
        self.titles = titles;
        self.titleBtnOnClick = titleDidClick;
        _currentIndex = 0;
        _oldIndex = 0;
        _currentWidth = self.segmentStyle.showExtraButton? self.frame.size.width - (CGRectGetMaxX(self.segmentStyle.extraBtnFrame)+self.segmentStyle.extraBtnMarginTitle): self.frame.size.width;
        
        // 设置了frame之后可以直接设置其他的控件的frame了, 不需要在layoutsubView()里面设置
        [self setupTitles];
        [self setupUI];
        
    }
    
    return self;
}
#pragma mark - private helper

- (void)setupTitles {
    
    self.backgroundColor = [UIColor greenColor];
    NSInteger index = 0;
    for (NSString *title in self.titles) {
        
        PWCustomLabel *label = [[PWCustomLabel alloc] initWithFrame:CGRectZero];
        label.tag = index;
        label.text = title;
        label.textColor = self.segmentStyle.normalTitleColor;
        label.font = self.segmentStyle.titleFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelOnClick:)];
        [label addGestureRecognizer:tapGes];
        CGRect bounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil];
        [self.titleWidths addObject:@(bounds.size.width)];
        [self.titleLabels addObject:label];
        [self addSubview:label];
        
        index++;
        
    }
}
- (void)setupUI{
    [self setupExtraBtn];
    [self setUpLabelsPosition];
    [self setupScrollLineAndCover];
}
- (void)setupExtraBtn{
    for (NSInteger i=0; i<self.segmentStyle.extraBtnImageNames.count; i++) {
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(extraBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName = self.segmentStyle.extraBtnImageNames[i];
//        btn.frame = CGRectMake(15, 200+i*50, 24, 24);
       
        btn.tag = i+10;
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        //        // 设置边缘的阴影效果
        //        btn.layer.shadowColor = [UIColor whiteColor].CGColor;
        //        btn.layer.shadowOffset = CGSizeMake(-5, 0);
        //        btn.layer.shadowOpacity = 1;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-14);
            make.right.mas_equalTo(self).offset(-20-i*40);
            make.height.width.offset(28);
        }];
    }
    UIView *temp = nil;
    for(NSInteger i=0; i<self.segmentStyle.leftExtraBtnImageNames.count;i++){
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(extraBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName = self.segmentStyle.leftExtraBtnImageNames[i];
        button.tag = i+20;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        CGFloat width = [self.segmentStyle.leftExtraBtnFrames[i] CGRectValue].size.width;
        CGFloat height = [self.segmentStyle.leftExtraBtnFrames[i] CGRectValue].size.height;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp) {
                make.left.mas_equalTo(temp.mas_right).offset(6);
                make.centerY.mas_equalTo(temp);
            }else{
                make.left.mas_equalTo(self).offset(16);
                make.bottom.mas_equalTo(self).offset(-14);
            }
            make.width.offset(width);
            make.height.offset(height);
        }];
        temp = button;
    }
    
}
- (void)setUpLabelsPosition{
    CGFloat titleX = 0.0;
    CGFloat titleY = 9+kStatusBarHeight;
    CGFloat titleW = 0.0;
    CGFloat titleH = 37;
    __block CGFloat titleL = 26;
    [self.segmentStyle.leftExtraBtnFrames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        titleL += [obj CGRectValue].size.width;
    }];
    titleL += (self.segmentStyle.leftExtraBtnFrames.count-1)*6;
    titleW = ZOOM_SCALE(48);
    
    NSInteger index = 0;
    for (PWCustomLabel *label in self.titleLabels) {
        
        titleX = index * (titleW+self.segmentStyle.titleMargin)+titleL;
        label.frame = CGRectMake(titleX, titleY, titleW, titleH);
        index++;
        
    }
    PWCustomLabel *firstLabel = (PWCustomLabel *)self.titleLabels[0];
    
    if (firstLabel) {
        // 设置初始状态文字的颜色
        firstLabel.textColor = self.segmentStyle.selectedTitleColor;
        firstLabel.font = self.segmentStyle.selectTitleFont;
    }
}
- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex{

        NSInteger index = 0;
        for (PWCustomLabel *label in self.titleLabels) {
            if (index == currentIndex) {
                label.textColor = self.segmentStyle.selectedTitleColor;
                label.font = self.segmentStyle.selectTitleFont;
            } else {
                label.textColor = self.segmentStyle.normalTitleColor;
                label.font = self.segmentStyle.titleFont;
            }
            index++;
        }
    
}
- (void)setupScrollLineAndCover{
    PWCustomLabel *firstLabel = (PWCustomLabel *)self.titleLabels[0];
    if (self.scrollLine) {
        [self.scrollLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstLabel.mas_bottom);
            make.left.equalTo(firstLabel.mas_left);
            make.right.equalTo(firstLabel.mas_right);
            make.height.offset(2);
        }];
    }
    

}
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    _oldIndex = currentIndex;
    PWCustomLabel *oldLabel = (PWCustomLabel *)self.titleLabels[oldIndex];
    PWCustomLabel *currentLabel = (PWCustomLabel *)self.titleLabels[currentIndex];
    
    CGFloat xDistance = currentLabel.pw_x - oldLabel.pw_x;
    CGFloat wDistance = currentLabel.pw_width - oldLabel.pw_width;
    
    if (self.scrollLine) {
        self.scrollLine.pw_x = oldLabel.pw_x + xDistance * progress;
        self.scrollLine.pw_width = oldLabel.pw_width + wDistance * progress;
    }
    if (self.scrollLine) {
        self.scrollLine.pw_x = oldLabel.pw_x + xDistance * progress;
        self.scrollLine.pw_width = oldLabel.pw_width + wDistance * progress;
    }
}

#pragma mark - public helper

- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated {
    if (_currentIndex == _oldIndex) { return; }
    
    PWCustomLabel *oldLabel = (PWCustomLabel *)self.titleLabels[_oldIndex];
    PWCustomLabel *currentLabel = (PWCustomLabel *)self.titleLabels[_currentIndex];
    
    
    CGFloat animatedTime = animated ? 0.3 : 0.0;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animatedTime animations:^{
        oldLabel.textColor = weakSelf.segmentStyle.normalTitleColor;
        oldLabel.font = weakSelf.segmentStyle.titleFont;
        currentLabel.textColor = weakSelf.segmentStyle.selectedTitleColor;
        currentLabel.font = weakSelf.segmentStyle.selectTitleFont;
    
        if (weakSelf.scrollLine) {
            weakSelf.scrollLine.pw_x = currentLabel.pw_x;
            weakSelf.scrollLine.pw_width = currentLabel.pw_width;
        }
    }];
    
    _oldIndex = _currentIndex;
    if (self.titleBtnOnClick) {
        self.titleBtnOnClick(currentLabel, _currentIndex);
    }
    
    
}
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    NSAssert(index >= 0 && index < self.titles.count, @"设置的下标不合法!!");
    
    if (index < 0 || index >= self.titles.count) {
        return;
    }
    
    _currentIndex = index;
    [self adjustUIWhenBtnOnClickWithAnimate:animated];
}

- (void)reloadTitlesWithNewTitles:(NSArray *)titles {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 将子控件置为nil 否则懒加载会不正常
    _scrollLine = nil;
    
    self.titleWidths = nil;
    self.titleLabels = nil;
    self.titles = nil;
    self.titles = titles;
    
    [self setupTitles];
    [self setupUI];
    [self setSelectedIndex:0 animated:YES];
    
}
#pragma mark - getter --- setter

- (UIView *)scrollLine {
  
    if (!_scrollLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = self.segmentStyle.scrollLineColor;
        [self addSubview:lineView];
        _scrollLine = lineView;
        
    }
    
    return _scrollLine;
}
- (UIButton *)extraBtn {
    
    if (!_extraBtn) {
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(extraBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName = self.segmentStyle.extraBtnImageNames ? self.segmentStyle.extraBtnImageNames[0] : @"";
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
//        // 设置边缘的阴影效果
//        btn.layer.shadowColor = [UIColor whiteColor].CGColor;
//        btn.layer.shadowOffset = CGSizeMake(-5, 0);
//        btn.layer.shadowOpacity = 1;
        [self addSubview:btn];
        _extraBtn = btn;
    }
    return _extraBtn;
}



- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}
- (NSArray *)normalColorRgb {
    if (!_normalColorRgb) {
        NSArray *normalColorRgb = [self getColorRgb:self.segmentStyle.normalTitleColor];
        NSAssert(normalColorRgb, @"设置普通状态的文字颜色时 请使用RGB空间的颜色值");
        _normalColorRgb = normalColorRgb;
        
    }
    return  _normalColorRgb;
}

- (NSArray *)selectedColorRgb {
    if (!_selectedColorRgb) {
        NSArray *selectedColorRgb = [self getColorRgb:self.segmentStyle.selectedTitleColor];
        NSAssert(selectedColorRgb, @"设置选中状态的文字颜色时 请使用RGB空间的颜色值");
        _selectedColorRgb = selectedColorRgb;
        
    }
    return  _selectedColorRgb;
}
- (NSArray *)getColorRgb:(UIColor *)color {
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
    }
    return rgbComponents;
    
}

#pragma mark - button action

- (void)titleLabelOnClick:(UITapGestureRecognizer *)tapGes {
    
    PWCustomLabel *currentLabel = (PWCustomLabel *)tapGes.view;
    
    if (!currentLabel) {
        return;
    }
    
    _currentIndex = currentLabel.tag;
    
    [self adjustUIWhenBtnOnClickWithAnimate:true];
}

- (void)extraBtnOnClick:(UIButton *)extraBtn {
    
    if (self.extraBtnOnClick) {
        self.extraBtnOnClick(extraBtn);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
