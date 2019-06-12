//
//  IssueListHeaderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueListHeaderView.h"
#import "SelectIssueTypeView.h"
#import "IssueListManger.h"
#import "AddIssueVC.h"
#import "ZTCreateTeamVC.h"
#define IssueTypeBtnTag   55
#define IssueViewBtnTag   66
@interface IssueListHeaderView()<SelectIssueViewDelegate>
@property (nonatomic, strong) SelectIssueTypeView *issueSV;
@property (nonatomic, strong) SelectIssueTypeView *viewSV;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *viewTypeBtn;

@end
@implementation IssueListHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    IssueType issueType =[[IssueListManger sharedIssueListManger] getCurrentIssueType];
    [self updateGetMsgTime];
    NSString *issueTitle = [self getIssueTitle:issueType];
    IssueViewType viewType =[[IssueListManger sharedIssueListManger] getCurrentIssueViewType];
    NSString *viewTitle = [self getIssueViewTitle:viewType];
    self.typeBtn = [[UIButton alloc]init];
    [self.typeBtn setTitle:issueTitle forState:UIControlStateNormal];
    self.typeBtn.titleLabel.font = RegularFONT(16);
    [self.typeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
    [self.typeBtn sizeToFit];
    [self.typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    CGFloat width = self.typeBtn.frame.size.width;
    [self addSubview:self.typeBtn];
    [self.typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(16));
        make.top.bottom.height.mas_equalTo(self);
        make.width.offset(width);
    }];
    UIButton *arrow = [[UIButton alloc]init];
    [arrow setImage:[UIImage imageNamed:@"triangle_down"] forState:UIControlStateNormal];
    [arrow setImage:[UIImage imageNamed:@"triangle_up"] forState:UIControlStateSelected];
    arrow.tag = IssueTypeBtnTag;
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeBtn.mas_right).offset(8);
        make.centerY.mas_equalTo(self.typeBtn);
        make.width.offset(18);
        make.height.offset(10);
    }];
    [arrow addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.viewTypeBtn = [[UIButton alloc]init];
    [self.viewTypeBtn setTitle:viewTitle forState:UIControlStateNormal];
    self.viewTypeBtn.titleLabel.font = RegularFONT(16);
    [self.viewTypeBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
    [self.viewTypeBtn sizeToFit];
    CGFloat width2 = self.viewTypeBtn.frame.size.width;
    [self.viewTypeBtn addTarget:self action:@selector(viewTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.viewTypeBtn];
    [self.viewTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(arrow.mas_right).offset(15);
        make.height.top.bottom.mas_equalTo(self);
        make.width.offset(width2);
    }];
    UIButton *arrow2 = [[UIButton alloc]init];
    [arrow2 setImage:[UIImage imageNamed:@"triangle_down"] forState:UIControlStateNormal];
    [arrow2 setImage:[UIImage imageNamed:@"triangle_up"] forState:UIControlStateSelected];
    [self addSubview:arrow2];
    arrow2.tag = IssueViewBtnTag;
    [arrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.viewTypeBtn.mas_right).offset(8);
        make.centerY.mas_equalTo(self.viewTypeBtn);
        make.width.offset(18);
        make.height.offset(10);
    }];
    UIButton *addIssueBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"创建情报"];
    addIssueBtn.titleLabel.font = RegularFONT(13);

    [self addSubview:addIssueBtn];
    [addIssueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-Interval(16));
        make.height.top.bottom.mas_equalTo(self);
    }];
    [addIssueBtn addTarget:self action:@selector(addIssueBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (NSString *)getIssueTitle:(IssueType)type{
    NSString *issueTitle;
    switch (type) {
        case IssueTypeAll:
            issueTitle = @"全部";
            break;
        case IssueTypeAlarm:
            issueTitle = @"监控";
            break;
        case IssueTypeSecurity:
            issueTitle = @"安全";
            break;
        case IssueTypeExpense:
            issueTitle = @"费用";
            break;
        case IssueTypeOptimization:
            issueTitle = @"优化";
            break;
        case IssueTypeMisc:
            issueTitle = @"提醒";
            break;
    }
    return issueTitle;
}
- (NSString *)getIssueViewTitle:(IssueViewType)type{
    NSString *viewTitle;
    switch (type) {
        case IssueViewTypeAll:
            viewTitle = @"全部视图";
            break;
        case IssueViewTypeNormal:
            viewTitle = @"标准视图";
            break;

    }
    return viewTitle;
}

-(SelectIssueTypeView *)issueSV{
    if (!_issueSV) {
        UIButton *arrow = [self viewWithTag:IssueTypeBtnTag];
        CGFloat x = self.typeBtn.frame.origin.x+ZOOM_SCALE(8);
        CGFloat y = CGRectGetMaxY(arrow.frame)+35+kTopHeight;
        _issueSV = [[SelectIssueTypeView alloc]initWithType:SelectTypeIssue contentViewPoint:CGPointMake(x, y)];
        _issueSV.delegate =self;
    }
    return _issueSV;
}
-(SelectIssueTypeView *)viewSV{
    if (!_viewSV) {
        UIButton *arrow = [self viewWithTag:IssueViewBtnTag];
        CGFloat x = arrow.frame.origin.x-ZOOM_SCALE(60);
        CGFloat y = CGRectGetMaxY(arrow.frame)+35+kTopHeight;
        _viewSV = [[SelectIssueTypeView alloc]initWithType:SelectTypeView contentViewPoint:CGPointMake(x, y)];
        _viewSV.delegate =self;
    }
    return _viewSV;
}
- (void)typeBtnClick{
    UIButton *button = [self viewWithTag:IssueTypeBtnTag];
    BOOL selected = button.selected;
    button.selected = !selected;
    if (!selected) {
        [self.issueSV showInView:[UIApplication sharedApplication].keyWindow];
    }
}
- (void)addIssueBtnClick{
    if([getTeamState isEqualToString:PW_isTeam]){
        AddIssueVC *creatVC = [[AddIssueVC alloc]init];
        [self.viewController.navigationController pushViewController:creatVC animated:YES];
    }else if([getTeamState isEqualToString:PW_isPersonal]){
        //        FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
        //        [self.navigationController pushViewController:createTeam animated:YES];
        
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
- (void)viewTypeBtnClick{
    UIButton *button = [self viewWithTag:IssueViewBtnTag];
    BOOL selected = button.selected;
    button.selected = !selected;
    if (!selected) {
        [self.viewSV showInView:[UIApplication sharedApplication].keyWindow];
    }
}
-(void)selectIssueCellClick:(NSInteger )index selectType:(SelectType)type{
   
    switch (type) {
        case SelectTypeIssue:{
            UIButton *button = [self viewWithTag:IssueTypeBtnTag];
            button.selected = NO;
            [self.typeBtn setTitle:[self getIssueTitle:(IssueType)(index+1)] forState:UIControlStateNormal];
            [self updateGetMsgTime];
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectIssueTypeIndex:)]){
            [self.delegate selectIssueTypeIndex:index];
        }
        }
            break;
        case SelectTypeView:{
            UIButton *button = [self viewWithTag:IssueViewBtnTag];
            button.selected = NO;
             [self.viewTypeBtn setTitle:[self getIssueViewTitle:(IssueViewType)(index+1)] forState:UIControlStateNormal];
            if(self.delegate && [self.delegate respondsToSelector:@selector(selectIssueViewTypeIndex:)]){
                [self.delegate selectIssueViewTypeIndex:index];
            }
        }
            break;
       default:
            break;
    }
}
-(void)disMissClickWithSelectType:(SelectType)type{
    switch (type) {
        case SelectTypeIssue:{
            UIButton *button = [self viewWithTag:IssueTypeBtnTag];
            button.selected = NO;
        }
            break;
        case SelectTypeView:{
            UIButton *button = [self viewWithTag:IssueViewBtnTag];
            button.selected = NO;
        }
            break;
            default:
            break;
    }
}
-(void)refreshHeaderViewTitle{
    IssueType issueType =[[IssueListManger sharedIssueListManger] getCurrentIssueType];
    NSString *issueTitle = [self getIssueTitle:issueType];
    IssueViewType viewType =[[IssueListManger sharedIssueListManger] getCurrentIssueViewType];
    NSString *viewTitle = [self getIssueViewTitle:viewType];
    [self.typeBtn setTitle:issueTitle forState:UIControlStateNormal];
    [self.viewTypeBtn setTitle:viewTitle forState:UIControlStateNormal];
}
- (void)updateGetMsgTime{
    IssueType issueType =[[IssueListManger sharedIssueListManger] getCurrentIssueType];
    NSString *type;
    switch (issueType) {
            
        case IssueTypeAll:
            type = @"all";
            break;
        case IssueTypeAlarm:
            type = @"alarm";
            break;
        case IssueTypeSecurity:
            type = @"security";
            break;
        case IssueTypeExpense:
            type = @"expense";
            break;
        case IssueTypeOptimization:
            type = @"optimization";
            break;
        case IssueTypeMisc:
            type = @"misc";
            break;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[IssueListManger sharedIssueListManger] updateIssueBoardGetMsgTime:type];
    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
