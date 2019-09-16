//
//  IssueSelectView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSelectView.h"
#import "TouchLargeButton.h"
#import "ZhugeIOIssueHelper.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "SelectOriginVC.h"
#import "SelectSourceVC.h"
#import "SelectAssignVC.h"
#import "MemberInfoModel.h"
#import "SourceModel.h"
#import "OriginModel.h"
#define LevelTag  200
#define TypeTag   300
@interface IssueSelectView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat topCons;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) IssueLevel currSelLevel;
@property (nonatomic, assign) IssueType currSelType;
@property (nonatomic, strong)  OriginModel *issueOrigin;
@property (nonatomic, strong)  SourceModel *issueSource;
@property (nonatomic, strong)  MemberInfoModel *issueAssigned;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *cancle;
@property (nonatomic, strong) UIButton *commit;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray<MineCellModel*>*dataSource;
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
    UITapGestureRecognizer *tap=   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    [self addGestureRecognizer:tap];
    tap.delegate =self;
    UILabel *levelName = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(12), ZOOM_SCALE(35), ZOOM_SCALE(21)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#66666A"] text:NSLocalizedString(@"local.level", @"")];
    [self.contentView addSubview:levelName];
   
    NSArray *levelNameAry = @[NSLocalizedString(@"local.ALL", @""),NSLocalizedString(@"local.danger", @""),NSLocalizedString(@"local.warning", @""),NSLocalizedString(@"local.info", @"")];
    CGFloat space = ZOOM_SCALE(8);
    for (NSInteger i=0; i<levelNameAry.count; i++) {
        UIButton *button = [self selButton];
        [button setTitle:levelNameAry[i] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(Interval(16)+(ZOOM_SCALE(50)+space)*i, CGRectGetMaxY(levelName.frame)+Interval(10), ZOOM_SCALE(50), ZOOM_SCALE(32));
        button.tag = LevelTag+i;
        
        [button addTarget:self action:@selector(levelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(84), kWidth, SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self.contentView addSubview:line];
    UILabel *typeLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(97), ZOOM_SCALE(35), ZOOM_SCALE(21)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#66666A"] text:NSLocalizedString(@"local.type", @"")];
    [self.contentView addSubview:typeLab];
    NSArray *typeNameAry = @[NSLocalizedString(@"local.ALL", @""),NSLocalizedString(@"local.alarm", @""),NSLocalizedString(@"local.security", @""),NSLocalizedString(@"local.expense", @""),NSLocalizedString(@"local.optimization", @""),NSLocalizedString(@"local.misc", @""),NSLocalizedString(@"local.report", @""),NSLocalizedString(@"local.task", @"")];
    for (NSInteger i=0; i<typeNameAry.count; i++) {
        UIButton *button = [self selButton];
        [button setTitle:typeNameAry[i] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(Interval(16)+(ZOOM_SCALE(50)+space)*(i%6), CGRectGetMaxY(typeLab.frame)+Interval(10)+(i/6)*(ZOOM_SCALE(32)+Interval(10)), ZOOM_SCALE(50), ZOOM_SCALE(32));
        button.tag = TypeTag+i;
        
        [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(344), kWidth, SINGLE_LINE_WIDTH)];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self.contentView addSubview:self.line];
    [self.mTableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    [self.contentView addSubview:self.mTableView];
    self.cancle = [PWCommonCtrl buttonWithFrame:CGRectMake(Interval(16), CGRectGetMaxY(self.line.frame)+ZOOM_SCALE(12), ZOOM_SCALE(163), ZOOM_SCALE(40)) type:PWButtonTypeSummarize text:NSLocalizedString(@"local.cancel", @"")];
    [self.cancle setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateNormal];
    [self.cancle addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    self.cancle.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    self.commit = [PWCommonCtrl buttonWithFrame:CGRectMake(CGRectGetMaxX(self.cancle.frame)+ZOOM_SCALE(17), CGRectGetMaxY(self.line.frame)+ZOOM_SCALE(14), ZOOM_SCALE(163), ZOOM_SCALE(40)) type:PWButtonTypeContain text:NSLocalizedString(@"local.confirm", @"")];
    [self.commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancle];
    [self.contentView addSubview:self.commit];
    MineCellModel *orign = [MineCellModel new];
    orign.title = NSLocalizedString(@"local.Origin", @"");
    MineCellModel *source = [MineCellModel new];
    source.title = NSLocalizedString(@"local.issueSource", @"");
    MineCellModel *assign = [MineCellModel new];
    assign.title = NSLocalizedString(@"local.Assigned", @"");
    [self.dataSource addObjectsFromArray:@[orign,source,assign]];
}
-(UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(212), kWidth, ZOOM_SCALE(132)) style:UITableViewStylePlain];
        _mTableView.rowHeight = ZOOM_SCALE(44);
        _mTableView.backgroundColor = PWWhiteColor;
        _mTableView.scrollEnabled = NO;
        _mTableView.delegate = self;
        _mTableView.dataSource =self;
    }
    return _mTableView;
}
-(UIButton *)selButton{
    UIButton *button = [[UIButton alloc]init];
    
    button.titleLabel.font = RegularFONT(14);
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#EAF2FF"]] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]] forState:UIControlStateNormal];
    [button setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
    [button setTitleColor:PWBlueColor forState:UIControlStateSelected];
    button.layer.cornerRadius = 4.0f;
    button.layer.masksToBounds = YES;
    
    //设置边框的颜色
//    [button setTitleColor:PWBlueColor forState:UIControlStateSelected];
//    [button.layer setBorderColor:[UIColor colorWithHexString:@"#E4E4E4"].CGColor];
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
    self.currSelType = self.selectObj.issueType;
    self.currSelLevel = self.selectObj.issueLevel;
    self.issueOrigin = self.selectObj.issueOrigin;
    self.issueSource = self.selectObj.issueSource;
    self.issueAssigned = self.selectObj.issueAssigned;
    self.dataSource[0].describeText =  self.selectObj.issueOrigin.name;
    self.dataSource[1].describeText = self.issueSource.name;
    self.dataSource[1].rightIcon = [self.issueSource.provider getIssueSourceIcon];
    self.dataSource[2].describeText = self.selectObj.issueAssigned.name;
    self.dataSource[2].rightIcon = [self.selectObj.issueAssigned.tags stringValueForKey:@"pwAvatar" default:@""];
    CGFloat contentHeight = ZOOM_SCALE(409);
    [self.mTableView reloadData];
    UIButton *typeBtn = [self.contentView viewWithTag:(int)self.selectObj.issueType+TypeTag-1];
    typeBtn.selected = YES;
    [typeBtn.layer setBorderColor:PWBlueColor.CGColor];
    UIButton *levelBtn = [self.contentView viewWithTag:(int)self.selectObj.issueLevel+LevelTag-1];
    levelBtn.selected = YES;
    [levelBtn.layer setBorderColor:PWBlueColor.CGColor];
    
    [_contentView setFrame:CGRectMake(0, -ZOOM_SCALE(400), kWidth,contentHeight)];
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = NO;
        self.alpha = 1.0;
        _contentView.alpha =1.0;
        [[AppDelegate shareAppDelegate].mainTabBar addCoverView];
        [_contentView setFrame:CGRectMake(0, 0, kWidth, contentHeight)];
        
    } completion:nil];
    
}
- (void)showInView:(UIView *)view selectObj:(SelectObject *)selectObj{
    self.selectObj = selectObj;
    [self showInView:view];
}
-(NSMutableArray<MineCellModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(409))];
        _contentView.backgroundColor = PWWhiteColor;
        _contentView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTap)];
        [_contentView addGestureRecognizer:tap];
        tap.delegate = self;
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
        [[[ZhugeIOIssueHelper new] eventClickIssueClass] track];
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
    [levelBtn.layer setBorderColor:[UIColor colorWithHexString:@"#E4E4E4"].CGColor];
    [[AppDelegate shareAppDelegate].mainTabBar removeCoverView];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0;
        self.contentView.frame = CGRectMake(0, -ZOOM_SCALE(409), kWidth, ZOOM_SCALE(400));
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
    sel.issueOrigin = self.issueOrigin;
    sel.issueAssigned = self.issueAssigned;
    sel.issueSource = self.issueSource;
       if(self.delegate && [self.delegate respondsToSelector:@selector(selectIssueWithSelectObject:)]){
        [self.delegate selectIssueWithSelectObject:sel];
    }
    [self disMissView];

}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    MineCellModel *model = self.dataSource[indexPath.row];
    if (indexPath.row==1) {
        model.isIssueSource = YES;
    }
    [cell initWithData:model type:MineVCCellTypeSelect];
  
    return cell;
}

#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.isShow = NO;
    WeakSelf
    switch (indexPath.row) {
        case 0:{
            SelectOriginVC *origin = [SelectOriginVC new];
            origin.itemClick = ^(OriginModel * _Nonnull origin) {
                weakSelf.issueOrigin = origin;
                weakSelf.dataSource[0].describeText = origin.name;
                [weakSelf.mTableView reloadData];
            };
            origin.disMissClick = ^{
                weakSelf.isShow = YES;
            };
            [self.viewController.navigationController pushViewController:origin animated:YES];
        }
            break;
        case 1:{
            SelectSourceVC *source = [SelectSourceVC new];
            source.itemClick = ^(SourceModel * _Nonnull source) {
                weakSelf.issueSource = source;
                weakSelf.dataSource[1].describeText = source.name;
                weakSelf.dataSource[1].rightIcon = [source.provider getIssueSourceIcon];
                [weakSelf.mTableView reloadData];
            };
            source.disMissClick = ^{
                weakSelf.isShow = YES;
            };
            [self.viewController.navigationController pushViewController:source animated:YES];
        }
            break;
        case 2:{
            SelectAssignVC *assign = [SelectAssignVC new];
            
            assign.itemClick = ^(MemberInfoModel * _Nonnull model) {
                weakSelf.issueAssigned = model;
                weakSelf.dataSource[2].describeText = model.name;
                weakSelf.dataSource[2].rightIcon = [model.tags stringValueForKey:@"pwAvatar" default:@""];
                [weakSelf.mTableView reloadData];
            };
            assign.disMissClick = ^{
                weakSelf.isShow = YES;
            };
            [self.viewController.navigationController pushViewController:assign animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // self.contentView为子控件
    if ([touch.view isDescendantOfView:self.mTableView]) {
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
