//
//  FillinTeamInforVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "FillinTeamInforVC.h"
#import "ChooseAddressVC.h"
#import "ChooseTradesVC.h"
#import "CreateSuccessVC.h"

#define AddressTag 15
#define TradesTag  20

@interface FillinTeamInforVC ()
@property (nonatomic, strong) NSMutableArray<UITextField *> *tfAry;

@property (nonatomic, strong) UITextView *textView;
@end

@implementation FillinTeamInforVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写团队信息";
    self.tfAry = [NSMutableArray new];
    [self createUI];
}
- (void)createUI{
    NSArray *itemAry = @[@{@"title":@"团队名称",@"placeholder":@"请输入您的团队名称（必填）",@"enabled":@YES},@{@"title":@"所在地",@"placeholder":@"请选择您的团队所在区域（必选）",@"enabled":@NO},@{@"title":@"行业",@"placeholder":@"请选择您的团队所属行业（必选）",@"enabled":@NO}];
    UIView *temp = nil;
    CGFloat height = Interval(23)+ZOOM_SCALE(42);
    for (NSInteger i=0;i<itemAry.count ;i++) {
         UIView *item = [self itemWithData:itemAry[i]];
        if (temp == nil) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).offset(Interval(12));
                make.left.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.height.offset(height);
            }];
            temp = item;
        }else{
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(temp.mas_bottom).offset(Interval(2));
                make.left.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.height.offset(height);
            }];
            temp = item;
            if (i==1) {
                item.tag = AddressTag;
            }else{
                item.tag = TradesTag;
            }
        }
    }
    
    UIView *textItem = [[UIView alloc]init];
    textItem.backgroundColor = PWWhiteColor;
    [self.view addSubview:textItem];
    [textItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(temp.mas_bottom).offset(Interval(2));
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.offset(ZOOM_SCALE(100));
    }];
    UILabel *titel = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(8), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:MediumFONT(14) textColor:PWTitleColor text:@"团队介绍"];
    [textItem addSubview:titel];
    
    [textItem addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titel.mas_bottom);
        make.right.mas_equalTo(self.view).offset(-Interval(12));
        make.left.mas_equalTo(self.view).offset(Interval(12));
        make.bottom.mas_equalTo(textItem).offset(-Interval(8));
    }];
    UIButton *commitTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"提交"];
    commitTeam.enabled = NO;
    [commitTeam addTarget:self action:@selector(commitTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitTeam];
    [commitTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(textItem.mas_bottom).offset(Interval(50));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
    RACSignal *nameSignal = [[self.tfAry[0] rac_textSignal]map:^id(NSString *value) {
        if (value.length>15) {
            [iToast alertWithTitleCenter:@"已达到可输入的最大限制字数"];
            value = [value substringToIndex:15];
        }
        self.tfAry[0].text = value;
        return value;
    }];
    RACSignal *addressSignal = RACObserve(self.tfAry[1], text);
    RACSignal *tradesSignal =  RACObserve(self.tfAry[2], text);
                               
                               
     [[self.tfAry[2] rac_textSignal] map:^id(NSString *value) {
        if (value.length>250) {
            [iToast alertWithTitleCenter:@"已达到可输入的最大限制字数"];
            value = [value substringToIndex:250];
        }
        self.tfAry[2].text = value;
        return value;
    }];
    RACSignal *btnSignal = [RACSignal combineLatest:@[nameSignal,addressSignal,tradesSignal] reduce:^id(NSString * name,NSString * address,NSString *trades){
        return @(name.length>0 && self.tfAry[1].text.length>0 &&self.tfAry[2].text.length>0);
    }];
    RAC(commitTeam,enabled) = btnSignal;
    
}
- (void)commitTeamClick{
    NSDictionary *params ;
    NSArray *address = [self.tfAry[1].text componentsSeparatedByString:@" "];
    NSString *province =address[0];
    NSString *city = address[1];
    if (self.textView.text.length>0) {
        params= @{@"data":@{@"name":self.tfAry[0].text,@"city":city,@"industry":self.tfAry[2].text,@"province":province,@"tags":@{@"introduction":self.textView.text}}};
    }else{
        params= @{@"data":@{@"name":self.tfAry[0].text,@"city":city,@"industry":self.tfAry[2].text,@"province":province}};
                  
    }
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_AddTeam withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            setTeamState(PWisTeam);
            [kUserDefaults synchronize];
            KPostNotification(KNotificationTeamStatusChange, @YES);
            CreateSuccessVC *create = [[CreateSuccessVC alloc]init];
            [self presentViewController:create animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
        }
        [SVProgressHUD dismiss];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:@"请简单介绍一下您的团队" font:MediumFONT(16)];
    }
    return _textView;
}
- (UIView *)itemWithData:(NSDictionary *)dict{
    UIView *item = [[UIView alloc]init];
    item.backgroundColor = PWWhiteColor;
    [self.view addSubview:item];
    UILabel *titel = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(8), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:MediumFONT(14) textColor:PWTitleColor text:dict[@"title"]];
    [item addSubview:titel];
    UITextField *itemTF = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), Interval(14)+ZOOM_SCALE(20), kWidth-Interval(32), ZOOM_SCALE(22))];
    itemTF.placeholder = dict[@"placeholder"];
    BOOL enabled = [dict boolValueForKey:@"enabled" default:YES];
    [itemTF setEnabled:enabled];
    [item addSubview:itemTF];
    [self.tfAry addObject:itemTF];
    if (!enabled) {
        UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextgray"]];
        [item addSubview:arrow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
        [item addGestureRecognizer:tap];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(item).offset(-Interval(15));
            make.height.offset(ZOOM_SCALE(16));
            make.width.offset(ZOOM_SCALE(11));
            make.centerY.mas_equalTo(item);
        }];
    }
    return item;
}
- (void)itemClick:(UITapGestureRecognizer *)sender{
    if (sender.view.tag == AddressTag) {
        ChooseAddressVC *addressVC = [[ChooseAddressVC alloc]init];
        if (self.tfAry[1].text.length>0) {
            addressVC.currentAddress = self.tfAry[1].text;
        }
        addressVC.itemClick = ^(NSString *text){
            self.tfAry[1].text = text;
        };
        [self.navigationController pushViewController:addressVC animated:YES];
    }else{
        ChooseTradesVC *tradesVC = [[ChooseTradesVC alloc]init];
        tradesVC.itemClick=^(NSString * _Nonnull trades){
            self.tfAry[2].text = trades;
        };
        [self.navigationController pushViewController:tradesVC animated:YES];
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
