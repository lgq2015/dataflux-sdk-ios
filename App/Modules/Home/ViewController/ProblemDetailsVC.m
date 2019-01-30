//
//  ProblemDetailsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ProblemDetailsVC.h"
#import "PPBadgeView.h"

@interface ProblemDetailsVC ()
@property (nonatomic, strong) UIBarButtonItem *navRightBtn;
@property (nonatomic, strong) UIView *upContainerView;
@end

@implementation ProblemDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报详情";
    [self createUI];
}
#pragma mark ========== UI ==========
- (void)createUI{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"讨论" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick:)];;
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupBadges];
    });

#pragma mark 导航
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
//    [self.navRightBtn setBadgeValue:2];
//    self.navigationItem.rightBarButtonItem = item;
    

   
}
- (void)setupBadges{
    [self.navigationItem.rightBarButtonItem pp_addBadgeWithNumber:2];
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

-(UIBarButtonItem *)navRightBtn{
    if (!_navRightBtn) {
        
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
