//
//  ChooseAddressVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChooseAddressVC.h"

@interface ChooseAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *districtAry;
@property (nonatomic, strong) UILabel *currentDisLab;
@property (nonatomic, strong) NSMutableArray *cityAry;
@end
@implementation ChooseAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择所在地";
    self.cityAry = [NSMutableArray new];
    [self grtAdressData];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)grtAdressData{
    NSDictionary *param = @{@"keys":@"district"};
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:YES cache:YES params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content  =response[@"content"];
            self.districtAry = [content mutableArrayValueForKey:@"district"];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)createUI{
    if (self.currentAddress == nil || [self.currentAddress isEqualToString:@""]) {
        
    }else{
        self.currentDisLab.text = [NSString stringWithFormat:@"当前选择城市：%@",self.currentAddress];
    }
}
-(UILabel *)currentDisLab{
    if (!_currentDisLab) {
        _currentDisLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, Interval(2), kWidth, ZOOM_SCALE(44)) font:MediumFONT(16) textColor:PWTextBlackColor text:@""];
        _currentDisLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_currentDisLab];
    }
    return _currentDisLab;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.districtAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
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
