//
//  IssueSelectView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSelectHeaderView.h"
#import "AddIssueVC.h"
#import "ZTCreateTeamVC.h"
#import "TouchLargeButton.h"

@interface IssueSelectHeaderView()<SelectViewDelegate,SelectSortViewDelegate>
@property (nonatomic, strong) TouchLargeButton *typeBtn;
@property (nonatomic, strong) TouchLargeButton *timeTypeBtn;
@property (nonatomic, strong) TouchLargeButton *mineTypeBtn;
@property (nonatomic, strong) SelectObject *selObj;
@property (nonatomic, assign) BOOL isSave;
@end
@implementation IssueSelectHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isSave = YES;
        self.selObj = [[IssueListManger sharedIssueListManger] getCurrentSelectObject];
        [self createUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame selectObject:(SelectObject *)selObj{
    self = [super initWithFrame:frame];
    if (self) {
        self.isSave = NO;
        self.selObj = selObj;
        [self createUI];
    }
    return self;
}
- (void)createUI{
   
    self.backgroundColor = PWWhiteColor;
    CGFloat typeX = Interval(16);
    if (_isSave) {
        UIButton *addIssueBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:NSLocalizedString(@"local.issueCreateTypeTask", @"")];
        addIssueBtn.titleLabel.font = RegularFONT(13);
        
        [self addSubview:addIssueBtn];
        [addIssueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-Interval(16));
            make.height.top.bottom.mas_equalTo(self);
        }];
        [addIssueBtn addTarget:self action:@selector(addIssueBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.mineTypeBtn.frame = CGRectMake(Interval(16), (self.height-ZOOM_SCALE(18))/2.0, ZOOM_SCALE(70), ZOOM_SCALE(18));
                  UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.mineTypeBtn.frame)+Interval(9), 0, SINGLE_LINE_WIDTH, ZOOM_SCALE(20))];
                  line1.centerY = self.mineTypeBtn.centerY;
                  line1.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
                  [self addSubview:line1];
        typeX =CGRectGetMaxX(line1.frame)+Interval(12);
    }
    self.typeBtn.frame = CGRectMake(typeX, (self.height-ZOOM_SCALE(18))/2.0, ZOOM_SCALE(44), ZOOM_SCALE(18));
       UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.typeBtn.frame)+Interval(9), 0, SINGLE_LINE_WIDTH, ZOOM_SCALE(20))];
       line.centerY = self.typeBtn.centerY;
       line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
       [self addSubview:line];
       self.timeTypeBtn.frame = CGRectMake(CGRectGetMaxX(line.frame)+Interval(12), 0, ZOOM_SCALE(100), ZOOM_SCALE(18));
       self.timeTypeBtn.centerY = self.typeBtn.centerY;
    UIView *lineb =  [[UIView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(42)-1, kWidth, 0.5)];
    lineb.backgroundColor =[UIColor colorWithHexString:@"#E4E4E4"];
    [self addSubview:lineb];
}
-(TouchLargeButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn =[[TouchLargeButton alloc]init];
        _typeBtn.largeWidth = 20;
        _typeBtn.largeHeight = 14;
        [_typeBtn setTitle:NSLocalizedString(@"local.filtrate", @"") forState:UIControlStateNormal];
        [_typeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        [_typeBtn setTitleColor:PWBlueColor forState:UIControlStateSelected];
        _typeBtn.titleLabel.font = RegularFONT(13);
        [self addSubview:_typeBtn];
        [_typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_typeBtn setImage:[UIImage imageNamed:@"triangle_downg"] forState:UIControlStateNormal];
        [_typeBtn setImage:[UIImage imageNamed:@"triangle_upb"] forState:UIControlStateSelected];
        [_typeBtn sizeToFit];
        
        _typeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_typeBtn.imageView.frame.size.width - _typeBtn.frame.size.width + _typeBtn.titleLabel.frame.size.width, 0, 0);
        
        _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_typeBtn.titleLabel.frame.size.width - _typeBtn.frame.size.width + _typeBtn.imageView.frame.size.width);
        
    }
    return _typeBtn;
}
- (TouchLargeButton *)timeTypeBtn{
    if (!_timeTypeBtn) {
        _timeTypeBtn = [[TouchLargeButton alloc]init];
        _timeTypeBtn.largeWidth = 20;
        _timeTypeBtn.largeHeight = 14;
        [_timeTypeBtn setImage:[UIImage imageNamed:@"order_n"] forState:UIControlStateNormal];
        [_timeTypeBtn setImage:[UIImage imageNamed:@"order_highlight"] forState:UIControlStateSelected];
        _timeTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(ZOOM_SCALE(3), 0, ZOOM_SCALE(3), ZOOM_SCALE(75));
        _timeTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        NSString *title = self.selObj.issueSortType == IssueSortTypeCreate?NSLocalizedString(@"local.SortingByCreateDate", @""):NSLocalizedString(@"local.SortingByUpdateDate", @"");
        [_timeTypeBtn setTitle:title forState:UIControlStateNormal];
        [_timeTypeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        [_timeTypeBtn setTitleColor:PWBlueColor forState:UIControlStateSelected];
        _timeTypeBtn.titleLabel.font = RegularFONT(13);
        [_timeTypeBtn addTarget:self action:@selector(timeTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_timeTypeBtn];
    }
    return _timeTypeBtn;
}
-(TouchLargeButton *)mineTypeBtn{
    if (!_mineTypeBtn) {
        _mineTypeBtn = [[TouchLargeButton alloc]init];
        _mineTypeBtn.largeWidth = 20;
        _mineTypeBtn.largeHeight = 14;
        NSString *title = self.selObj.issueFrom == IssueFromMe?NSLocalizedString(@"local.MyIssue", @""):NSLocalizedString(@"local.AllIssue", @"");
        [_mineTypeBtn setTitle:title forState:UIControlStateNormal];
        [_mineTypeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        [_mineTypeBtn setTitleColor:PWBlueColor forState:UIControlStateSelected];
        _mineTypeBtn.titleLabel.font = RegularFONT(13);
        [_mineTypeBtn addTarget:self action:@selector(mineTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mineTypeBtn setImage:[UIImage imageNamed:@"triangle_downg"] forState:UIControlStateNormal];
        [_mineTypeBtn setImage:[UIImage imageNamed:@"triangle_upb"] forState:UIControlStateSelected];
        [_mineTypeBtn sizeToFit];
        _mineTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_mineTypeBtn.imageView.frame.size.width - _mineTypeBtn.frame.size.width + _mineTypeBtn.titleLabel.frame.size.width, 0, 0);
        _mineTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_mineTypeBtn.titleLabel.frame.size.width - _mineTypeBtn.frame.size.width + _mineTypeBtn.imageView.frame.size.width);
        [self addSubview:_mineTypeBtn];
    }
    return _mineTypeBtn;
}
-(IssueSelectView *)selView{
    if (!_selView) {
        _selView = [[IssueSelectView alloc]initWithTop:CGRectGetMaxY(self.frame)];
        WeakSelf
        _selView.disMissClick = ^(){
            weakSelf.typeBtn.selected = NO;
        };
        _selView.delegate = self;
    }
    return _selView;
}
-(IssueSelectSortTypeView *)sortByTimeView{
    if (!_sortByTimeView) {
        _sortByTimeView = [[IssueSelectSortTypeView alloc]initWithTop:CGRectGetMaxY(self.frame)AndSelectTypeIsTime:YES];
        _sortByTimeView.delegate = self;
        WeakSelf
        _sortByTimeView.disMissClick = ^(){
            weakSelf.timeTypeBtn.selected = NO;
        };
    }
    return _sortByTimeView;
}
-(IssueSelectSortTypeView *)isMineView{
    if (!_isMineView) {
        _isMineView = [[IssueSelectSortTypeView alloc]initWithTop:CGRectGetMaxY(self.frame)AndSelectTypeIsTime:NO];
        _isMineView.delegate = self;
        WeakSelf
        _isMineView.disMissClick = ^(){
            weakSelf.mineTypeBtn.selected = NO;
        };
    }
    return _isMineView;
}
- (void)mineTypeBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        if (self.sortByTimeView.isShow) {
            self.timeTypeBtn.selected = NO;
            [self.sortByTimeView disMissView];
        }else if(self.selView.isShow){
            self.typeBtn.selected = NO;
            [self.selView disMissView];
        }
        [self.isMineView showInView:[UIApplication sharedApplication].keyWindow selectObj:self.selObj];
    }else{
        [self.isMineView disMissView];
    }
}
- (void)typeBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        if (self.sortByTimeView.isShow) {
            self.timeTypeBtn.selected = NO;
            [self.sortByTimeView disMissView];
        }else if(self.isMineView.isShow){
            self.mineTypeBtn.selected = NO;
            [self.isMineView disMissView];
        }
        [self.selView showInView:self.superview selectObj:self.selObj];
       
    }else{
        [self.selView disMissView];
    }
}
- (void)timeTypeBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        if (self.selView.isShow) {
            self.typeBtn.selected = NO;
            [self.selView disMissView];
        }else if(self.isMineView.isShow){
            self.mineTypeBtn.selected = NO;
            [self.isMineView disMissView];
        }
         [self.sortByTimeView showInView:[UIApplication sharedApplication].keyWindow selectObj:self.selObj];
    }else{
        [self.sortByTimeView disMissView];
    }
}
- (void)addIssueBtnClick{
    if(self.selView.isShow){
        [self.selView disMissView];
    }else if (self.sortByTimeView.isShow) {
        [self.sortByTimeView disMissView];
    }
    
    if([getTeamState isEqualToString:PW_isTeam]){
        AddIssueVC *creatVC = [[AddIssueVC alloc]init];
        [self.viewController.navigationController pushViewController:creatVC animated:YES];
    }else if([getTeamState isEqualToString:PW_isPersonal]){        
        ZTCreateTeamVC *vc = [ZTCreateTeamVC new];
        vc.dowhat = supplementTeamInfo;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else{
        [userManager judgeIsHaveTeam:^(BOOL isSuccess, NSDictionary *content) {
            if (isSuccess) {
                if([getTeamState isEqualToString:PW_isTeam]){
                    AddIssueVC *creatVC = [[AddIssueVC alloc]init];
                    [self.viewController.navigationController pushViewController:creatVC animated:YES];
                }else if([getTeamState isEqualToString:PW_isPersonal]){
                    ZTCreateTeamVC *vc = [ZTCreateTeamVC new];
                    vc.dowhat = supplementTeamInfo;
                    [self.viewController.navigationController pushViewController:vc animated:YES];
                }
            }else{
                
            }
        }];
    }
}
#pragma mark ========== SelectViewDelegate ==========
-(void)selectIssueWithSelectObject:(SelectObject *)sel{
    self.selObj = sel;
    if (self.isSave) {
        [[IssueListManger sharedIssueListManger] setCurrentSelectObject:sel];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIssueSelectObject:)]) {
        [self.delegate selectIssueSelectObject:sel];
    }
}
#pragma mark ========== SelectSortViewDelegate ==========
-(void)selectSortWithSelectObject:(SelectObject *)sel{
    NSString *title = sel.issueSortType == IssueSortTypeCreate?NSLocalizedString(@"local.SortingByCreateDate", @""):NSLocalizedString(@"local.SortingByUpdateDate", @"");
    NSString *title2 = sel.issueFrom == IssueFromMe?NSLocalizedString(@"local.MyIssue", @""):NSLocalizedString(@"local.AllIssue", @"");
    [_mineTypeBtn setTitle:title2 forState:UIControlStateNormal];
    [_timeTypeBtn setTitle:title forState:UIControlStateNormal];
    self.selObj = sel;
    if (self.isSave) {
        [[IssueListManger sharedIssueListManger] setCurrentSelectObject:sel];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIssueSelectObject:)]) {
        [self.delegate selectIssueSelectObject:sel];
    }
}
- (void)teamSwitchChangeBtnTitle{
    SelectObject *selO =[[IssueListManger sharedIssueListManger] getCurrentSelectObject];
    self.selObj = selO;
    NSString *title = selO.issueSortType == IssueSortTypeCreate?NSLocalizedString(@"local.SortingByCreateDate", @""):NSLocalizedString(@"local.SortingByUpdateDate", @"");
    NSString *title2 = selO.issueFrom == IssueFromMe?NSLocalizedString(@"local.MyIssue", @""):NSLocalizedString(@"local.AllIssue", @"");
    [_mineTypeBtn setTitle:title2 forState:UIControlStateNormal];
    [_timeTypeBtn setTitle:title forState:UIControlStateNormal];
}
- (void)disMissView{
    if(_selView.isShow){
        [self.selView disMissView];
    }else if(_sortByTimeView.isShow){
        [self.sortByTimeView disMissView];
    }else if(_isMineView.isShow){
        [self.isMineView disMissView];
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
