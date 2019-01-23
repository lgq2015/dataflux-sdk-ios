//
//  ProblemDetailsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ProblemDetailsVC.h"
#import "BadgeButton.h"

@interface ProblemDetailsVC ()
@property (nonatomic, strong) BadgeButton *navRightBtn;
@property (nonatomic, strong) UIView *upContainerView;
@end

@implementation ProblemDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题详情";
    [self createUI];
}
#pragma mark ========== UI ==========
- (void)createUI{
#pragma mark 导航
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    
}
-(UIView *)upContainerView{
    if (!_upContainerView) {
        _upContainerView = [[UIView alloc]init];
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        titleLab.text = self.model.title;
        [_upContainerView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_upContainerView).offset(Interval(16));
            make.top.mas_equalTo(_upContainerView).offset(Interval(14));
            make.right.mas_equalTo(_upContainerView).offset(-Interval(16));
        }];
        
    }
    return _upContainerView;
}

-(BadgeButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn = [[BadgeButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_navRightBtn setTitle:@"讨论" forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navRightBtn;
}
-(void)didClickBtn:(UIButton *)button {
    //    self.btnSize = CGSizeMake(self.btnSize.width * 1.3, self.btnSize.height * 1.3); //设置一个属性（btnSize）保存其大小的变化
    
    //1.告知需要更新约束，但不会立刻开始，系统然后调用updateConstraints
    [self.view setNeedsUpdateConstraints];
    
    //2.告知立刻更新约束，系统立即调用updateConstraints
    [self.view updateConstraintsIfNeeded];
    
    //3.这里动画当然可以取消，具体看项目的需求
    //系统block内引用不会导致循环引用，block结束就会释放引用对象
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded]; //告知页面立刻刷新，系统立即调用updateConstraints
    }];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
}

- (void)navRightBtnClick:(UIButton *)button{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
