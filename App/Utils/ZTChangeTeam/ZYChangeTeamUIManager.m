//
//  ZYChangeTeamUIManager.m
//  App
//
//  Created by tao on 2019/4/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZYChangeTeamUIManager.h"
#import "ZYChangeTeamCell.h"
#import "UITableViewCell+ZTCategory.h"
@interface ZYChangeTeamUIManager()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View
@property (nonatomic, assign) CGFloat offsetY;//从哪个位置弹出来
@property (nonatomic, strong) UIViewController *fromVC;//从哪个控制器上弹出
@property (nonatomic, strong) UITableView *tab;
@end
@implementation ZYChangeTeamUIManager

+ (instancetype)shareInstance{
    static ZYChangeTeamUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYChangeTeamUIManager alloc] init];
    });
    return instance;
}

#pragma mark --添加主控件--
-(void)s_UI{
    [self.window addSubview:self.backgroundGrayView];
    [self.backgroundGrayView addSubview:self.tab];
    [self p_hideFrame];
}

//隐藏
-(void)p_hideFrame{
    CGFloat teamViewH = [self getHeight];
    _tab.frame =CGRectMake(0,- teamViewH, kWidth, teamViewH);
}

//展示
-(void)p_disFrame{
    CGFloat teamViewH = [self getHeight];
    _tab.frame =CGRectMake(0,0, kWidth, teamViewH);
}

- (void)showWithOffsetY:(CGFloat)offset fromViewController:(UIViewController *)fromVC{
    _fromVC = fromVC;
    _offsetY = offset;
    [self s_UI];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_disFrame];
        self.tab.alpha = 1;
        self.backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        if (finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    
    [UIView commitAnimations];
}

-(void)dismiss{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_hideFrame];
        self.tab.alpha = 0;
        self.backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tab removeFromSuperview];
            self.tab = nil;
            [self.backgroundGrayView removeFromSuperview];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [UIView commitAnimations];
}

#pragma mark --lazy--
-(UIWindow *)window{
    if (!_window) {
        _window = [[[UIApplication sharedApplication]delegate]window];
        _window.clipsToBounds = YES;
    }
    return _window;
}

-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,_offsetY, kWidth, kHeight);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _backgroundGrayView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [_backgroundGrayView addGestureRecognizer:tap];
    }
    return _backgroundGrayView;
}
- (UITableView *)tab{
    if (!_tab){
        _tab = [[UITableView alloc] init];
        _tab.delegate = self;
        _tab.dataSource = self;
        _tab.backgroundColor = [UIColor whiteColor];
        [_tab setSeparatorInset:UIEdgeInsetsZero];
        [_tab registerNib:[ZYChangeTeamCell cellWithNib] forCellReuseIdentifier:[ZYChangeTeamCell cellReuseIdentifier]];
        [_tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tab;
}
#pragma mark --UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0
        || indexPath.row == 1
        || indexPath.row == 2
        || indexPath.row == 3){
        ZYChangeTeamCell *cell = (ZYChangeTeamCell *)[tableView dequeueReusableCellWithIdentifier:[ZYChangeTeamCell cellReuseIdentifier]];
        if (indexPath.row == 0){
            cell.selectedImage.hidden = YES;
            cell.callLab.hidden = YES;
            cell.numLab.hidden = NO;
        }
        if (indexPath.row == 1){
            cell.selectedImage.hidden = NO;
            cell.callLab.hidden = YES;
            cell.numLab.hidden = YES;
        }
        if (indexPath.row == 2){
            cell.selectedImage.hidden = YES;
            cell.callLab.hidden = NO;
            cell.numLab.hidden = NO;
        }
        if (indexPath.row == 3){
            cell.selectedImage.hidden = YES;
            cell.callLab.hidden = YES;
            cell.numLab.hidden = NO;
        }
        return  cell;
    }else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"创建新团队";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#C7C7CC"];
        return  cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0
        || indexPath.row == 1
        || indexPath.row == 2
        || indexPath.row == 3){
        return ZOOM_SCALE(44);
    }else{
        return ZOOM_SCALE(60);
    }
}
#pragma mark --UITableViewDelegate--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4){
        DLog(@"开始创建团队");
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickChangeTeamWithGroupID:)]){
        [self.delegate didClickChangeTeamWithGroupID:nil];
    }
}

#pragma mark ---UIGestureRecognizerDelegate---
//解决didSelectRowAtIndexPath 和 手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark --获取表的高度---
- (CGFloat)getHeight{
    NSArray *titles = @[@"上海驻云团队",@"上海驻云团队2",@"上海驻云团队2",@"我的团队"];
    CGFloat height = titles.count * ZOOM_SCALE(44) + ZOOM_SCALE(60);
    if (height > kHeight * 0.5){
        height = kHeight * 0.5;
    }
    return height;
}


@end
