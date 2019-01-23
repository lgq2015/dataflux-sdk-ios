//
//  SourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SourceVC.h"

@interface SourceVC ()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray<UITextField *> *TFArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *successView;
@property (nonatomic, copy) NSString *successTip;
@end
@implementation SourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUIWithType:self.type];
    // Do any additional setup after loading the view.
}
- (void)createUIWithType:(SourceType)type{
    if (self.isAdd == YES) {
        [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(navLeftBtnClick:) tags:@[@"100"]];
    }else{
    [self addNavigationItemWithImageNames:@[@"icon_more"] isLeft:NO target:self action:@selector(navRightBtnClick:) tags:@[@99]];
    }
    switch (type) {
        case SourceTypeAli:
            self.title = @"连接阿里云";
            [self createSourceTypeYunWithTitle:@"阿里云"];
            break;
        case SourceTypeSingleDiagnose:
            [self createSourceTypeSingle];
            break;
        case SourceTypeClusterDiagnose:
            [self createSourceTypeCluster];
            break;
        case SourceTypeHUAWEI:
            self.title = @"连接华为云";
            [self createSourceTypeYunWithTitle:@"华为云"];
            break;
        case SourceTypeTencent:
            self.title = @"连接腾讯云";
            [self createSourceTypeYunWithTitle:@"腾讯云"];
            break;
        case SourceTypeAWS:
            self.title = @"连接AWS";
            [self createSourceTypeYunWithTitle:@"AWS"];
            break;
        case SourceTypeURLDiagnose:
            [self createSourceTypeURL];
            break;
        case SourceTypeDomainNameDiagnose:
            [self createSourceTypeDomainName];
            break;
        case SourceTypeWebsiteSecurityScan:
            [self createSourceTypeWebsite];
            break;
    }
}
#pragma mark ========== 阿里云 ==========
- (void)createSourceTypeYunWithTitle:(NSString *)title{
    if (self.isAdd) {
        
        NSString *tips = [NSString stringWithFormat:@"通过授权王教授只读权限，让王教授连接您的云账号，您就可以及时得到%@的诊断情报，发现可能存在的问题并获取专家建议。",title];
    UIView *tipView = [self tipsViewWithBackImg:@"card" tips:tips];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(110));
        }];
        NSArray *arrar = @[@{@"title":@"名称",@"placeholder":@"请输入云账号名称"},@{@"title":@"Access Key ID",@"placeholder":@"请输入 Access Key ID"},@{@"title":@"Access Key Secret",@"placeholder":@"请输入 Access Key Secret"}];
        UIView *temp = nil;
        self.TFArray = [NSMutableArray new];
        temp = tipView;
        for (NSDictionary *dict in arrar) {
            UIView *item = [self itemViewWithTitle:dict[@"title"] tag:self.TFArray.count+1 placeholder:dict[@"placeholder"]];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                if(self.TFArray.count <= 2){
                make.top.mas_equalTo(temp.mas_bottom).offset(ZOOM_SCALE(12));
                }else{
                make.top.mas_equalTo(temp.mas_bottom);
                }
                make.width.offset(kWidth);
                make.height.offset(ZOOM_SCALE(65));
            }];
            if (self.TFArray.count>=2) {
                UIView *line = [[UIView alloc]init];
                line.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
                [self.view addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(item.mas_bottom);
                    make.width.offset(kWidth);
                    make.height.offset(1);
                }];
                temp = line;
            }else{
                temp = item;
            }
        }
    }
    
    
    
}
#pragma mark ========== 主机诊断 ==========
- (void)createSourceTypeSingle{
    self.title = @"单机诊断";
 
    NSArray *arrar = @[@{@"title":@"名称"},@{@"title":@"Instance ID"},@{@"title":@"Hostname"},@{@"title":@"Host IP"},@{@"title":@"os"}];
    self.TFArray = [NSMutableArray new];
    self.dataSource = [NSMutableArray arrayWithArray:arrar];
    UIView *temp = nil;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        UIView *item = [self itemViewWithTitle:self.dataSource[i][@"title"] tag:i+1 placeholder:@"请输入"];
        if (i==0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).offset(Interval(12));
                make.width.offset(kWidth);
                make.height.offset(ZOOM_SCALE(65));
            }];
            temp = item;
        }else{
            
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i==1) {
                make.top.mas_equalTo(temp.mas_bottom).offset(Interval(12));
                }else{
                make.top.mas_equalTo(temp.mas_bottom);
                }
                make.width.offset(kWidth);
                make.height.offset(ZOOM_SCALE(65));
            }];
            if(i<self.dataSource.count-1){
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            [self.view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(item.mas_bottom);
                make.width.offset(kWidth);
                make.height.offset(1);
            }];
                temp = line;
            }
        }
    }
}

#pragma mark ========== 集群诊断 ==========
- (void)createSourceTypeCluster{
    self.title = @"集群诊断";
}
#pragma mark ========== 域名诊断 ==========
- (void)createSourceTypeDomainName{
    self.title = @"域名诊断";
    if (self.isAdd) {
        NSString *tips = @"配置您要诊断的域名，及时获取关于域名相关的诊断情报。包括了域名到期时间、SSL证书配置等。";
        UIView *tipView = [self tipsViewWithBackImg:@"card" tips:tips];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(110));
        }];
        UIView *item = [self itemViewWithTitle:@"域名" tag:33 placeholder:@"请输入需要诊断的域名"];
        [self.view addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipView.mas_bottom).offset(Interval(12));
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(65));
        }];
    }
   
}
#pragma mark ========== 网站安全扫描 ==========
- (void)createSourceTypeWebsite{
    self.title = @"网站安全扫描";
    if (self.isAdd) {
        self.successTip = @"已为您发起网站安全扫描配置服务申请";
        NSString *tips = @"结合情报大数据、白帽渗透测试实战经验和深度机器学习的全面网站威胁检测，包括漏洞、涉政暴恐色情内容、网页篡改、挂马暗链、垃圾广告等，第一时间助您精准发现您的网站资产和关联资产存在的安全风险，满足合规要求，同时避免遭受品牌形象和经济损失。";
        UIView *tipView = [self tipsViewWithBackImg:@"bigcard" tips:tips];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(200));
        }];
        UIButton *allocationBtn = [[UIButton alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(270), kWidth-2*Interval(16), ZOOM_SCALE(47))];
        [allocationBtn setTitle:@"帮我配置" forState:UIControlStateNormal];
        [allocationBtn setBackgroundColor:PWBlueColor];
        allocationBtn.layer.cornerRadius = 4.0f;
        [self.view addSubview:allocationBtn];
    }
}
#pragma mark ========== URL 诊断 ==========
- (void)createSourceTypeURL{
    self.title = @"URL 诊断";
    NSString *tip = @"为您检测您的 URL 在多个地域下的访问速度，及时发现可能存在的访问故障，帮助您避免业务遭受影响。";
    UIView *tipView = [self tipsViewWithBackImg:@"card" tips:tip];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
        make.left.mas_equalTo(self.view).offset(Interval(15));
        make.right.mas_equalTo(self.view).offset(Interval(-15));
        make.height.offset(ZOOM_SCALE(105));
    }];
    if (self.isAdd) {
        self.successTip = @"已为您发起 URL 诊断配置服务申请";
        UIButton *allocationBtn = [[UIButton alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(181), kWidth-2*Interval(16), ZOOM_SCALE(47))];
        [allocationBtn setTitle:@"帮我配置" forState:UIControlStateNormal];
        [allocationBtn setBackgroundColor:PWBlueColor];
        [allocationBtn addTarget:self action:@selector(allocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        allocationBtn.layer.cornerRadius = 4.0f;
        [self.view addSubview:allocationBtn];
    }
   
}
#pragma mark ========== UI ==========
-(UIView *)successView{
    if (!_successView) {
        _successView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, kHeight-kTopHeight-Interval(12))];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_succeed"]];
        [_successView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_successView).offset(Interval(55));
            make.width.height.offset(ZOOM_SCALE(80));
            make.centerX.mas_equalTo(_successView.centerX);
        }];
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(167), kWidth, ZOOM_SCALE(25))];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        tip.textColor = PWTextBlackColor;
        tip.text =self.successTip;
        [_successView addSubview:tip];
        UILabel *subTip = [[UILabel alloc]init];
        subTip.text = @"您可以在首页的提醒分类中查看到发起的申请在线与我们的服务人员沟通，也可以直接拨打400XXXXXXX电话咨询我们的在线客服";
        subTip.font =[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [_successView addSubview:subTip];
    }
    return _successView;
}
- (UIImageView *)tipsViewWithBackImg:(NSString *)imageName tips:(NSString *)tip{
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.text = tip;
    tipLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    tipLab.textColor = PWWhiteColor;
    tipLab.textAlignment = NSTextAlignmentLeft;
    tipLab.numberOfLines = 0;
    [view addSubview:tipLab];
    [self.view addSubview:view];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(ZOOM_SCALE(15));
        make.left.mas_equalTo(view).offset(Interval(10));
        make.right.mas_equalTo(view).offset(Interval(-10));
        make.bottom.mas_equalTo(view).offset(ZOOM_SCALE(-15));
    }];
    return view;
}
- (UIView *)itemViewWithTitle:(NSString *)title tag:(NSInteger)tag placeholder:(NSString *)placeholder{
    UIView *item = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(65))];
    [self.view addSubview:item];
    item.backgroundColor = PWWhiteColor;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(8), 200, ZOOM_SCALE(20))];
    titleLab.text = title;
    titleLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    titleLab.textColor = PWTitleColor;
    [item addSubview:titleLab];
    UITextField *tf = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(34), kWidth-Interval(32), ZOOM_SCALE(22))];
    tf.tag = tag;
    tf.delegate = self;
    tf.placeholder = placeholder;
    [item addSubview:tf];
    [self.TFArray addObject:tf];
    return item;
}
#pragma mark ========== navClick ==========
- (void)navRightBtnClick:(UIButton *)button{
    if(button.tag == 99){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *edit = [PWCommonCtrl actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *delet = [PWCommonCtrl actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:edit];
    [alert addAction:delet];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)navLeftBtnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== allocationBtnClick ==========
- (void)allocationBtnClick:(UIButton *)button{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.tag<self.TFArray.count) {
        UITextField *tf = self.TFArray[textField.tag];
        [tf becomeFirstResponder];
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.TFArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj resignFirstResponder];
    }];
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
