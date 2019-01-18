//
//  CreateQuestionVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CreateQuestionVC.h"

@interface CreateQuestionVC ()
@property (nonatomic, strong) UITextField *titleTf;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *levelView;
// type = 1 严重 type = 2  警告
@property (nonatomic, assign) NSInteger type;
@end

@implementation CreateQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建问题";
    self.isShowLiftBack = NO;
    [self createUI];
}
- (void)createUI{
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(navigationBtnClick:) tags:@[@5]];
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(navigationBtnClick:) tags:@[@6]];
    [self.view addSubview:self.mainScrollView];
   
    self.titleTf = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(34), ZOOM_SCALE(350), ZOOM_SCALE(22))];
    [self.titleView addSubview:self.titleTf];
    
    self.mainScrollView.contentSize = CGSizeMake(0, kHeight);
    [self.view addSubview:self.mainScrollView];
}
-(UIView *)titleView{
    if (!_titleView) {
       _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, ZOOM_SCALE(65))];
        _titleView.backgroundColor = PWWhiteColor;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(8), ZOOM_SCALE(40), ZOOM_SCALE(20))];
        lab.text = @"标题";
        lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        lab.textColor = [UIColor colorWithHexString:@"595860"];
        lab.textAlignment = NSTextAlignmentLeft;
        [_titleView addSubview:lab];
    }
    return _titleView;
}
-(UIView *)levelView{
    if (!_levelView) {
        _levelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(55))];
        UILabel *title = [[UILabel alloc]init];
        title.text = @"严重程度";
        title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        title.textColor = [UIColor colorWithHexString:@"595860"];
        title.textAlignment = NSTextAlignmentLeft;
        [self.mainScrollView addSubview:_levelView];
        [_levelView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_levelView).offset(Interval(12));
            make.centerY.mas_equalTo(_levelView);
            make.height.offset(ZOOM_SCALE(22));
        }];
        
    }
    return _levelView;
}
- (void)navigationBtnClick:(UIButton *)button{
    if (button.tag == 5) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag == 6){
        
    }
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
