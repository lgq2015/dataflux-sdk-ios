//
//  CreateSuccessVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CreateSuccessVC.h"
#define WeChatBtnTag  100
#define QQBtnTag      200
#define DingBtnTag    300

@interface CreateSuccessVC ()
@property (nonatomic, strong) UIButton *skipBtn;

@end

@implementation CreateSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.view).offset(Interval(kStatusBarHeight+16));
        make.height.offset(ZOOM_SCALE(22));
    }];
    
    UIImageView *successIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"team_success"]];
    [self.view addSubview:successIcon];
    [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.skipBtn.mas_bottom).offset(Interval(8));
        make.centerX.mas_equalTo(self.view);
        make.width.height.offset(ZOOM_SCALE(80));
    }];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(24) textColor:PWTextBlackColor text:@"恭喜您创建团队成功！"];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successIcon.mas_bottom).offset(Interval(21));
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.offset(ZOOM_SCALE(33));
    }];
    UILabel *inviteLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWSubTitleColor text:@"现在就去邀请小伙伴加入团队吧"];
    [self.view addSubview:inviteLab];
    [inviteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(tipLab.mas_bottom).offset(Interval(54));
        make.height.offset(ZOOM_SCALE(20));
    }];
    NSArray *icon = @[@{@"name":@"team_weChat"},@{@"name":@"team_qq"},@{@"name":@"team_ding"}];
    NSArray *btnTag = @[@WeChatBtnTag,@QQBtnTag,@DingBtnTag];
    NSArray *iconName = @[@"微信好友",@"QQ 好友",@"钉钉"];
    for (NSInteger i=0; i<icon.count; i++) {
        UIImageView *imgView = [self inviteBtnWithDict:icon[i]];
        [self.view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(ZOOM_SCALE(70));
            make.top.mas_equalTo(inviteLab.mas_bottom).offset(Interval(42));
            if (i==0) {
                make.left.mas_equalTo(self.view).offset(Interval(40));
            }else if(i==1){
                make.centerX.mas_equalTo(self.view);
            }else{
                make.right.mas_equalTo(self.view).offset(-Interval(42));
            }
        }];
        imgView.tag = [btnTag[i] integerValue];
        UILabel *name = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTitleColor text:iconName[i]];
        name.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(Interval(7));
            make.centerX.mas_equalTo(imgView);
            make.width.offset(ZOOM_SCALE(51));
            make.height.offset(ZOOM_SCALE(17));
        }];
    }
    
}
-(UIImageView *)inviteBtnWithDict:(NSDictionary *)dict{
    UIImageView *item = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"name"]]];
    item.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inviteBtnClick:)];
    [item addGestureRecognizer:tap];
    return item;
}
-(void)inviteBtnClick:(UITapGestureRecognizer *)tap{
    //TODO:zhantao
    if (tap.view.tag == WeChatBtnTag) {
        
    }else if(tap.view.tag == QQBtnTag){
        
    }else if(tap.view.tag == DingBtnTag){
        
    }
    
}
-(UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.titleLabel.font = RegularFONT(16);
        [_skipBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [self.view addSubview:_skipBtn];
    }
    return _skipBtn;
}
- (void)skipBtnClick{
    if (self.btnClick) {
        self.btnClick();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
