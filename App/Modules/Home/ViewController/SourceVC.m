//
//  SourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SourceVC.h"
#import <TTTAttributedLabel.h>
typedef NS_ENUM(NSUInteger ,NaviType){
    NaviTypeNormal = 0,    //左返回，右更多
    NaviTypeAddBack,       //左返回
    NaviTypeEdit,          //修改 左取消 右完成
    NaviTypeAddDone,       //左空 右完成
};
@interface SourceVC ()<UITextFieldDelegate,TTTAttributedLabelDelegate>
@property (nonatomic, strong) NSMutableArray<UITextField *> *TFArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *successView;
@property (nonatomic, copy) NSString *successTip;
@property (nonatomic, strong) TTTAttributedLabel *findHelpLab;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, copy) NSString *provider;
@property (nonatomic, strong) UIButton  *showWordsBtn;

@property (nonatomic, assign) BOOL isFirstEdit;
@end
@implementation SourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TFArray = [NSMutableArray new];
    NSInteger type = self.model?self.model.type:self.type;
    [self createUIWithType:type];
    // Do any additional setup after loading the view.
}
- (void)createUIWithType:(SourceType)type{
    switch (type) {
        case SourceTypeAli:
            self.title = @"连接阿里云";
            self.provider = @"aliyun";
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
            self.provider = @"huaweicloud";
            [self createSourceTypeYunWithTitle:@"华为云"];
            break;
        case SourceTypeTencent:
            self.title = @"连接腾讯云";
            self.provider = @"qcloud";
            [self createSourceTypeYunWithTitle:@"腾讯云"];
            break;
        case SourceTypeAWS:
            self.title = @"连接AWS";
            self.provider = @"aws";
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
    if (self.isAdd == YES ) {
        if(type == SourceTypeURLDiagnose ||type == SourceTypeWebsiteSecurityScan||type == SourceTypeClusterDiagnose){
            [self createNavWithType:NaviTypeAddBack];
        }else{
            [self createNavWithType:NaviTypeAddDone];
        }
    }else{
        [self createNavWithType:NaviTypeNormal];
    }
    
}
- (void)createNavWithType:(NaviType)type{
    switch (type) {
        case NaviTypeNormal:
        [self addNavigationItemWithImageNames:@[@"icon_more"] isLeft:NO target:self action:@selector(navRightBtnClick:) tags:@[@99]];
            break;
        case NaviTypeAddDone:{
        [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(navLeftBtnClick:) tags:@[@200]];
            UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
            self.navigationItem.rightBarButtonItem = item;
            if (_navRightBtn) {
                if (self.TFArray.count>0) {
                    NSMutableArray<RACSignal*> *signalAry = [NSMutableArray new];
                    [self.TFArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        RACSignal *TfSignal = [obj rac_textSignal];
                        [signalAry addObject:TfSignal];
                    }];
                    RACSignal * navBtnSignal = [RACSignal combineLatest:signalAry reduce:^id{
                        __block BOOL isenable = YES;
                        [self.TFArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if(obj.text.length==0){
                                isenable = NO;
                                *stop = YES;
                            }
                        }];
                        return @(isenable);
                    }];
                    RAC(self.navRightBtn,enabled) = navBtnSignal;
                }
            }
            break;
        }
        case NaviTypeAddBack:
            break;
        case NaviTypeEdit:
            break;
    }
}
#pragma mark ========== 云系列 ==========
- (void)createSourceTypeYunWithTitle:(NSString *)title{
  
        NSString *tips = [NSString stringWithFormat:@"通过授权王教授只读权限，让王教授连接您的云账号，您就可以及时得到%@的诊断情报，发现可能存在的问题并获取专家建议。",title];
       UIView *tipView = [self tipsViewWithBackImg:@"card" tips:tips];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(110));
        }];
    NSArray *array ;
    if (self.isAdd) {
        array = @[@{@"title":@"名称",@"tfText":@"请输入云账号名称"},@{@"title":@"Access Key ID",@"tfText":@"请输入 Access Key ID"},@{@"title":@"Access Key Secret",@"tfText":@"请输入 Access Key Secret"}];
    }else{
        array = @[@{@"title":@"名称",@"tfText":self.model.name},@{@"title":@"Access Key ID",@"tfText":self.model.akId},@{@"title":@"Access Key Secret",@"tfText":@"***********"}];
    }
    
        
        UIView *temp = nil;
        self.TFArray = [NSMutableArray new];
        temp = tipView;
        for (NSDictionary *dict in array) {
            BOOL isSecureTextEntry = self.TFArray.count == array.count-1?YES:NO;
            UIView *item = [self itemViewWithTitle:dict[@"title"] tag:self.TFArray.count+1 tfText:dict[@"tfText"] secureTextEntry:isSecureTextEntry];
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
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(temp.mas_bottom);
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(117));
        }];
    if (!self.isAdd) {
        self.isFirstEdit = YES;
        UITextField *akId = self.TFArray[1];
        UITextField *password = self.TFArray[2];
        [[akId rac_textSignal] subscribeNext:^(id x) {
            if (self.isFirstEdit) {
                if (![x isEqualToString:self.model.akId]) {
                    password.text = @"";
                    self.isFirstEdit = NO;
                    self.showWordsBtn.enabled = YES;
                }
            }
        }];
    }
}
#pragma mark ========== 单机诊断 ==========
- (void)createSourceTypeSingle{
    self.title = @"单机诊断";
    NSArray *arrar ;
    if(self.isAdd){
        arrar= @[@{@"title":@"名称",@"tfText":@"请输入名称"},@{@"title":@"Instance ID",@"tfText":@"请输入Instance ID"},@{@"title":@"Hostname",@"tfText":@"请输入Hostname"},@{@"title":@"Host IP",@"tfText":@"请输入Host IP"},@{@"title":@"os",@"tfText":@"请输入os"}];
    }else{
        arrar= @[@{@"title":@"名称",@"tfText":@"oa-web-02"},@{@"title":@"Instance ID",@"tfText":@"i-vfht5456465"},@{@"title":@"Hostname",@"tfText":@"oa-gnldgla"},@{@"title":@"Host IP",@"tfText":@"43.114.113.1"},@{@"title":@"os",@"tfText":@"Windows"}];
    }
    self.dataSource = [NSMutableArray arrayWithArray:arrar];
    UIView *temp = nil;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        UIView *item = [self itemViewWithTitle:self.dataSource[i][@"title"] tag:i+1 tfText:self.dataSource[i][@"tfText"] secureTextEntry:NO];
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
    NSArray *arrar ;
    if(!self.isAdd){
        arrar= @[@{@"title":@"名称",@"tfText":@"oa-web-02"},@{@"title":@"Cluster ID",@"tfText":@"i-vfht54564657575797"},@{@"title":@"Cluster Hostname",@"tfText":@"oa-gnldgla"},@{@"title":@"Cluste IP",@"tfText":@"43.114.113.1"}];
        self.dataSource = [NSMutableArray arrayWithArray:arrar];
        UIView *temp = nil;
        for (NSInteger i=0; i<self.dataSource.count; i++) {
            UIView *item = [self itemViewWithTitle:self.dataSource[i][@"title"] tag:i+1 tfText:self.dataSource[i][@"tfText"] secureTextEntry:NO];
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
}
#pragma mark ========== 域名诊断 ==========
- (void)createSourceTypeDomainName{
    self.title = @"域名诊断";
    NSString *tfText = self.isAdd?@"请输入需要诊断的域名":@"cloudcare.cn";
    
        NSString *tips = @"配置您要诊断的域名，及时获取关于域名相关的诊断情报。包括了域名到期时间、SSL证书配置等。";
        UIView *tipView = [self tipsViewWithBackImg:@"card" tips:tips];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(110));
        }];
        UIView *item = [self itemViewWithTitle:@"域名" tag:33 tfText:tfText secureTextEntry:NO];
        [self.view addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipView.mas_bottom).offset(Interval(12));
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(65));
        }];
    
   
}
#pragma mark ========== 网站安全扫描 ==========
- (void)createSourceTypeWebsite{
    self.title = @"网站安全扫描";
    
        self.successTip = @"已为您发起网站安全扫描配置服务申请";
        NSString *tips = @"结合情报大数据、白帽渗透测试实战经验和深度机器学习的全面网站威胁检测，包括漏洞、涉政暴恐色情内容、网页篡改、挂马暗链、垃圾广告等，第一时间助您精准发现您的网站资产和关联资产存在的安全风险，满足合规要求，同时避免遭受品牌形象和经济损失。";
        UIView *tipView = [self tipsViewWithBackImg:@"bigcard" tips:tips];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(200));
        }];
    if (self.isAdd) {
        UIButton *allocationBtn = [[UIButton alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(270), kWidth-2*Interval(16), ZOOM_SCALE(47))];
        [allocationBtn setTitle:@"帮我配置" forState:UIControlStateNormal];
        [allocationBtn setBackgroundColor:PWBlueColor];
        allocationBtn.layer.cornerRadius = 4.0f;
        [self.view addSubview:allocationBtn];
    }else{
        UIView *item = [self itemViewWithTitle:@"URL" tag:1 tfText:@"http://www.skghak.com.cn/chart.php" secureTextEntry:NO];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipView.mas_bottom).offset(Interval(12));
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(65));
        }];
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
    }else{
        UIView *item = [self itemViewWithTitle:@"URL" tag:1 tfText:@"http://www.skghak.com.cn/chart.php" secureTextEntry:NO];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipView.mas_bottom).offset(Interval(12));
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(65));
        }];
    }
   
}
#pragma mark ========== UI 懒加载 ==========
-(UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _navRightBtn.frame = CGRectMake(0, 0, 40, 30);
        [_navRightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _navRightBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [_navRightBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_navRightBtn setTitleColor:PWGrayColor forState:UIControlStateDisabled];
        _navRightBtn.tag = 100;
        _navRightBtn.enabled = NO;
        [_navRightBtn sizeToFit];
    }
    return _navRightBtn;
}
-(UIView *)tipView{
    if (!_tipView) {
        _tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(117))];
        _tipView.backgroundColor = PWWhiteColor;
        [self.view addSubview:_tipView];
        UIView *dot = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(20), 8, 8)];
        dot.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
        dot.layer.cornerRadius = 4.0f;
        [_tipView addSubview:dot];
        UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(13), kWidth-Interval(32), ZOOM_SCALE(40))];
        tipLab.text = @"    为了您的数据安全，我们只接受您的具有只读权限的子账号 Access Key";
        tipLab.font =[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        tipLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
        tipLab.numberOfLines = 0;
        [_tipView addSubview:tipLab];
        UIView *dot2 = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(65), 8, 8)];
        dot2.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
        dot2.layer.cornerRadius = 4.0f;
        [_tipView addSubview:dot2];
        self.findHelpLab.frame = CGRectMake(Interval(16), ZOOM_SCALE(59), kWidth-Interval(32), ZOOM_SCALE(40));
        [_tipView addSubview:self.findHelpLab];
    }
    return _tipView;
}
-(TTTAttributedLabel *)findHelpLab{
    if (!_findHelpLab) {
        //    Access Key 可在您的阿里云 RAM 账号中找到，详细步骤请点击这里
        NSString *linkText = @"查看帮助 ";
        NSString *promptText = [NSString stringWithFormat:@"    Access Key 可在您的阿里云 RAM 账号中找到，详细步骤请点击这里%@", linkText];
        NSRange linkRange = [promptText rangeOfString:linkText];
        _findHelpLab = [[TTTAttributedLabel alloc] initWithFrame: CGRectZero];
        _findHelpLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _findHelpLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
        _findHelpLab.numberOfLines = 0;
        _findHelpLab.delegate = self;
        _findHelpLab.lineBreakMode = NSLineBreakByCharWrapping;
        _findHelpLab.text = promptText;
        NSDictionary *attributesDic = @{(NSString *)kCTForegroundColorAttributeName : (__bridge id)PWBlueColor.CGColor,
                                        (NSString *)kCTUnderlineStyleAttributeName : @(YES)
                                        };
        _findHelpLab.linkAttributes = attributesDic;
        _findHelpLab.activeLinkAttributes = attributesDic;
        [_findHelpLab addLinkToURL:[NSURL URLWithString:@"testURL"] withRange:linkRange];
    }
    return _findHelpLab;
}
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
- (UIView *)itemViewWithTitle:(NSString *)title tag:(NSInteger)tag tfText:(NSString *)tfText secureTextEntry:(BOOL )isSecureTextEntry{
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
    tf.secureTextEntry = isSecureTextEntry;
    if (isSecureTextEntry) {
        tf.frame = CGRectMake(Interval(16), ZOOM_SCALE(34), kWidth-Interval(64), ZOOM_SCALE(22));
      UIButton  *showWordsBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(337), ZOOM_SCALE(33), ZOOM_SCALE(24), ZOOM_SCALE(24))];
        [showWordsBtn setImage:[UIImage imageNamed:@"icon_visible"] forState:UIControlStateNormal];
        [showWordsBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [showWordsBtn addTarget:self action:@selector(pwdTextSwitch:) forControlEvents:UIControlEventTouchUpInside];
        showWordsBtn.tag = tag+100;
        [item addSubview:showWordsBtn];
        self.showWordsBtn = showWordsBtn;
    }
    tf.delegate = self;
    if (self.isAdd) {
        tf.placeholder = tfText;
    }else{
    tf.text = tfText;
        tf.enabled = NO;
    }
    [item addSubview:tf];
    [self.TFArray addObject:tf];
    return item;
}

#pragma mark ========== navClick ==========
- (void)navRightBtnClick:(UIButton *)button{
    if(button.tag == 99){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if (self.type != SourceTypeURLDiagnose && self.type != SourceTypeWebsiteSecurityScan) {
            UIAlertAction *edit = [PWCommonCtrl actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.TFArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.enabled = YES;
                }];
                UITextField *tf = self.TFArray[0];
                [tf becomeFirstResponder];
                self.showWordsBtn.enabled =NO;
                [self createNavWithType:NaviTypeAddDone];
            }];
            [alert addAction:edit];
        }
    UIAlertAction *delet = [PWCommonCtrl actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UIAlertController *deletAlert = [UIAlertController alertControllerWithTitle:nil message:@"文案产品提供" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self delectIssueSource];
        }];
        UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [deletAlert addAction:confirm];
        [deletAlert addAction:cancel];
        [self presentViewController:deletAlert animated:YES completion:nil];
        
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:delet];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
    }else if(button.tag == 100){
        if(self.isAdd){
            [self addIssueSource];
        }else{
            [self modifyIssueSource];
        }
    }
}
#pragma mark ========== 编辑情报源 ==========
- (void)modifyIssueSource{
    NSDictionary *param ;
    if ([self.TFArray[1].text isEqualToString:self.model.akId]) {
        param = @{@"data":@{@"name":self.TFArray[0].text}};
    }else{
        param = @{@"data":@{@"name":self.TFArray[0].text,@"credentialJSON":@{@"akId":self.TFArray[1].text,@"akSecret":self.TFArray[2].text}}};
    }
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceModify(self.model.issueId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        
    } failBlock:^(NSError *error) {
    }];
}
#pragma mark ========== 添加情报源 ==========
- (void)addIssueSource{
    NSDictionary *param = @{@"data":@{@"provider":self.provider,@"credentialJSON":@{@"akId":self.TFArray[1].text,@"akSecret":self.TFArray[2].text},@"name":self.TFArray[0].text}};
    [PWNetworking requsetHasTokenWithUrl:PW_addIssueSource withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }else{
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
    }];
}
#pragma mark ========== 删除情报源 ==========
- (void)delectIssueSource{
//    [SVProgressHUD showWithStatus:@"正在删除..."];
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceDelete(self.model.issueId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
//        [SVProgressHUD showSuccessWithStatus:@"删除成功"];

    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}
-(void)navLeftBtnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== TTTAttributedLabelDelegate ==========
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    
}
#pragma mark ========== BtnClick ==========
- (void)allocationBtnClick:(UIButton *)button{
    
}
- (void)pwdTextSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    UITextField *tf = [self.view viewWithTag:sender.tag-100];
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = tf.text;
        tf.text = @""; // 这句代码可以防止切换的时候光标偏移
        tf.secureTextEntry = NO;
        tf.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = tf.text;
        tf.text = @"";
        tf.secureTextEntry = YES;
        tf.text = tempPwdStr;
    }
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
