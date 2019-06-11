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

@interface IssueSelectHeaderView()<SelectViewDelegate>
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *timeTypeBtn;
@end
@implementation IssueSelectHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
   
    self.backgroundColor = PWWhiteColor;
    self.typeBtn =[[UIButton alloc]initWithFrame:CGRectMake(Interval(16), (self.height-ZOOM_SCALE(22))/2.0, ZOOM_SCALE(32), ZOOM_SCALE(22))];
    //[ buttonWithFrame: type:PWButtonTypeWord text:@"筛选"];
    [self.typeBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [self.typeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
    [self.typeBtn setTitleColor:PWBlueColor forState:UIControlStateSelected];
    self.typeBtn.titleLabel.font = RegularFONT(16);
    [self addSubview:self.typeBtn];
    [self.typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.typeBtn.frame)+Interval(16), 0, 1, ZOOM_SCALE(20))];
    line.centerY = self.typeBtn.centerY;
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self addSubview:line];
    self.timeTypeBtn.frame = CGRectMake(CGRectGetMaxX(line.frame)+Interval(16), 0, ZOOM_SCALE(120), ZOOM_SCALE(22));
    self.timeTypeBtn.centerY = self.typeBtn.centerY;
    UIButton *addIssueBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"创建情报"];
    addIssueBtn.titleLabel.font = RegularFONT(13);
    
    [self addSubview:addIssueBtn];
    [addIssueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-Interval(16));
        make.height.mas_equalTo(self);
    }];
    [addIssueBtn addTarget:self action:@selector(addIssueBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineb =  [[UIView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(42)-1, kWidth, 0.5)];
    lineb.backgroundColor =[UIColor colorWithHexString:@"#E4E4E4"];
    [self addSubview:lineb];
}

- (UIButton *)timeTypeBtn{
    if (!_timeTypeBtn) {
        _timeTypeBtn = [[UIButton alloc]init];
        [_timeTypeBtn setImage:[UIImage imageNamed:@"order_n"] forState:UIControlStateNormal];
        [_timeTypeBtn setImage:[UIImage imageNamed:@"order_highlight"] forState:UIControlStateSelected];
        [_timeTypeBtn addTarget:self action:@selector(timeTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_timeTypeBtn];
    }
    return _timeTypeBtn;
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
- (void)typeBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.selView showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        [self.selView disMissView];
    }
}
- (void)timeTypeBtnClick:(UIButton *)button{
    button.selected = !button.selected;
}
- (void)addIssueBtnClick{
    if(self.selView.isShow){
        [self.selView disMissView];
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
-(void)selectIssueWithSelectObject:(SelectObject *)sel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIssueSelectObject:)]) {
        [self.delegate selectIssueSelectObject:sel];
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
