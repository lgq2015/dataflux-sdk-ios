//
//  TeamVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamVC.h"

@interface TeamVC ()
@property (nonatomic, strong) UILabel *teamNameLab;
@property (nonatomic, strong) UILabel *feeLab;
@end

@implementation TeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    [self createUI];
}

- (void)createUI{
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight);
    
}
-(UILabel *)teamNameLab{
    if (!_teamNameLab) {
        _teamNameLab = [[UILabel alloc]init];
        _teamNameLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:20];
        _teamNameLab.textColor = PWWhiteColor;
    }
    return _teamNameLab;
}
-(UILabel *)feeLab{
    if (!_feeLab) {
        _feeLab = [[UILabel alloc]init];
        _feeLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:30];
        _feeLab.textColor = PWWhiteColor;
    }
    return _feeLab;
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
