//
//  SourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SourceVC.h"
#import "AddSourceTipView.h"
#import "TeamInfoModel.h"
#import <TTTAttributedLabel.h>
#import "AddIssueSourceTipView.h"
#import "PWBaseWebVC.h"
#import "InformationSourceVC.h"

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
@property (nonatomic, strong) AddIssueSourceTipView *addTipView;
@property (nonatomic, assign) BOOL isFirstEdit;
@property (nonatomic, copy) NSString *yunTitle;
@end
@implementation SourceVC
-(void)viewDidAppear:(BOOL)animated{
    if (_addTipView) {
        _addTipView.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.TFArray = [NSMutableArray new];
    [self.view addSubview:self.mainScrollView];
    NSInteger type = self.model?self.model.type:self.type;
    self.type = type;
    [self createUIWithType:type];
}

- (void)createUIWithType:(SourceType)type{
    NSArray *placeArray;
    switch (type) {
        case SourceTypeAli:
            self.title = @"连接阿里云";
            self.provider = @"aliyun";
            self.yunTitle = @"阿里云 RAM ";
            placeArray = @[@{@"title":@"名称",@"tfText":@"请输入情报源名称"},@{@"title":@"Access Key ID",@"tfText":@"请输入 RAM 账号的 Access Key ID"},@{@"title":@"Access Key Secret",@"tfText":@"请输入 RAM 账号的 Access Key Secret"}];
            [self createSourceTypeYunWithTitle:@"阿里云" array:placeArray];
            break;
        case SourceTypeSingleDiagnose:
            [self createSourceTypeSingle];
            break;
        case SourceTypeUcloud:
            self.title = @"连接Ucloud";
            self.provider = @"ucloud";
            self.yunTitle = @" UCloud UAM ";
             placeArray = @[@{@"title":@"名称",@"tfText":@"请输入情报源名称"},@{@"title":@"Access Key ID",@"tfText":@"请输入 UAM 账号的 Public key"},@{@"title":@"Access Key Secret",@"tfText":@"请输入 UAM 账号的 Privite key"}];
            [self createSourceTypeYunWithTitle:@"Ucloud" array:placeArray];
            break;
        case SourceTypeTencent:
            self.title = @"连接腾讯云";
            self.provider = @"qcloud";
            self.yunTitle = @"腾讯云 CAM ";
            placeArray = @[@{@"title":@"名称",@"tfText":@"请输入情报源名称"},@{@"title":@"Access Key ID",@"tfText":@"请输入 CAM 账号的 Access Key ID"},@{@"title":@"Access Key Secret",@"tfText":@"请输入 CAM 账号的 Access Key Secret"}];
            [self createSourceTypeYunWithTitle:@"腾讯云" array:placeArray];
            break;
        case SourceTypeAWS:
            self.title = @"连接AWS";
            self.provider = @"aws";
            self.yunTitle = @" AWS IAM ";
            placeArray = @[@{@"title":@"名称",@"tfText":@"请输入情报源名称"},@{@"title":@"Access Key ID",@"tfText":@"请输入 IAM 账号的 Access Key ID"},@{@"title":@"Access Key Secret",@"tfText":@"请输入 IAM 账号的 Access Key Secret"}];
            [self createSourceTypeYunWithTitle:@"AWS" array:placeArray];
            break;
        case SourceTypeDomainNameDiagnose:
            self.provider = @"domain";
            [self createSourceTypeDomainName];
            break;
        case SourceTypeClusterDiagnose:
            break;
        default:
            break;
    }
    if (self.isAdd == YES ) {
        if(type == SourceTypeClusterDiagnose){
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
            if(getTeamState){
                BOOL isadmain = userManager.teamModel.isAdmin;
                if (isadmain) {
                   [self addNavigationItemWithImageNames:@[@"icon_more"] isLeft:NO target:self action:@selector(navRightBtnClick:) tags:@[@99]];
                }
            }else{
                [self addNavigationItemWithImageNames:@[@"icon_more"] isLeft:NO target:self action:@selector(navRightBtnClick:) tags:@[@99]];
            }
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
           [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(navLeftBtnClick:) tags:@[@200]];
            [self.navRightBtn setTitle:@"保存" forState:UIControlStateNormal];
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
}
#pragma mark ========== 云系列 ==========
- (void)createSourceTypeYunWithTitle:(NSString *)title array:(NSArray *)placearray{
  
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
        array = placearray;
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
        CGFloat height = self.isDefault?ZOOM_SCALE(120):ZOOM_SCALE(60);
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(temp.mas_bottom);
            make.width.offset(kWidth);
            make.height.offset(height);
        }];
    if (!self.isAdd) {
        self.isFirstEdit = YES;
        UITextField *akId = self.TFArray[1];
        UITextField *password = self.TFArray[2];
        self.showWordsBtn.hidden = YES;
        [[akId rac_textSignal] subscribeNext:^(id x) {
            if (self.isFirstEdit) {
                if (![x isEqualToString:self.model.akId]) {
                    password.text = @"";
                    self.isFirstEdit = NO;
                    self.showWordsBtn.hidden = NO;
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
        arrar= @[@{@"title":@"情报源名称",@"tfText":@"oa-web-02"},@{@"title":@"ID",@"tfText":@"i-vfht5456465"},@{@"title":@"Hostname",@"tfText":@"oa-gnldgla"},@{@"title":@"Host IP",@"tfText":@"43.114.113.1"}];
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

//#pragma mark ========== 集群诊断 ==========
- (void)createSourceTypeCluster{
    self.title = @"集群诊断";
    NSArray *arrar ;
    if(!self.isAdd){
        arrar= @[@{@"title":@"情报源名称",@"tfText":@"oa-web-02"},@{@"title":@"Cluster ID",@"tfText":@"i-vfht54564657575797"},@{@"title":@"Cluster Hostname",@"tfText":@"oa-gnldgla"},@{@"title":@"Cluste IP",@"tfText":@"43.114.113.1"}];
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
        NSString *tfText = self.isAdd?@"请输入需要诊断的一级域名":self.model.name;
    
        NSString *tips = @"配置您要诊断的一级域名，及时获取关于域名相关的诊断情报。包括了域名到期时间、SSL证书配置等。";
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
//#pragma mark ========== 网站安全扫描 ==========
//- (void)createSourceTypeWebsite{
//    self.title = @"网站安全扫描";
//
//        self.successTip = @"已为您发起网站安全扫描配置服务申请";
//        NSString *tips = @"结合情报大数据、白帽渗透测试实战经验和深度机器学习的全面网站威胁检测，包括漏洞、涉政暴恐色情内容、网页篡改、挂马暗链、垃圾广告等，第一时间助您精准发现您的网站资产和关联资产存在的安全风险，满足合规要求，同时避免遭受品牌形象和经济损失。";
//        UIView *tipView = [self tipsViewWithBackImg:@"bigcard" tips:tips];
//        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
//            make.left.mas_equalTo(self.view).offset(Interval(13));
//            make.right.mas_equalTo(self.view).offset(Interval(-13));
//            make.height.offset(ZOOM_SCALE(200));
//        }];
//    if (self.isAdd) {
//        UIButton *allocationBtn = [[UIButton alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(270), kWidth-2*Interval(16), ZOOM_SCALE(47))];
//        [allocationBtn setTitle:@"帮我配置" forState:UIControlStateNormal];
//        [allocationBtn setBackgroundColor:PWBlueColor];
//        allocationBtn.layer.cornerRadius = 4.0f;
//        [self.view addSubview:allocationBtn];
//    }else{
//        UIView *item = [self itemViewWithTitle:@"URL" tag:1 tfText:@"http://www.skghak.com.cn/chart.php" secureTextEntry:NO];
//        [item mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(tipView.mas_bottom).offset(Interval(12));
//            make.width.offset(kWidth);
//            make.height.offset(ZOOM_SCALE(65));
//        }];
//    }
//}

#pragma mark ========== UI 懒加载 ==========
-(UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _navRightBtn.frame = CGRectMake(0, 0, 40, 30);
        [_navRightBtn setTitle:@"添加" forState:UIControlStateNormal];
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
        CGFloat height = self.isDefault?ZOOM_SCALE(120):ZOOM_SCALE(60);
        _tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, height)];
        _tipView.backgroundColor = PWWhiteColor;
        [self.view addSubview:_tipView];
        UIView *dot = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(20), 8, 8)];
        dot.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
        dot.layer.cornerRadius = 4.0f;
        [_tipView addSubview:dot];
        self.findHelpLab.frame = CGRectMake(Interval(16), ZOOM_SCALE(13), kWidth-Interval(32), ZOOM_SCALE(40));
        [_tipView addSubview:self.findHelpLab];
       
        if (self.isDefault) {
            UIView *dot2 = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(65), 8, 8)];
            dot2.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
            dot2.layer.cornerRadius = 4.0f;
            [_tipView addSubview:dot2];
            NSString *tiptext = [self getsubTip];
            UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:[UIColor colorWithHexString:@"9B9EA0"] text:tiptext];
            tipLab.numberOfLines = 0;
            [_tipView addSubview:tipLab];
            [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(ZOOM_SCALE(58));
                make.left.offset(Interval(16));
                make.right.mas_equalTo(_tipView).offset(-Interval(16));
            }];
        }
       
       
    }
    return _tipView;
}
- (NSString *)getsubTip{
    switch (self.type) {
        case SourceTypeAli:
            return @"    您当前为免费版本，支持针对 ECS、块存储、OSS、RDS、SLB、VPC、云监控这几类资源进行相关的诊断。";
            break;
        case SourceTypeAWS:
            return @"    您当前为免费版本，支持针对 EC2、VPC、EBS、ELB、RDS、S3 这几类资源进行相关的诊断。";
            break;
        case SourceTypeTencent:
            return @"    您当前为免费版本，支持针对 CVM、CBS、TencentDB（MySQL / SQLServer）、CLB、VPC 这几类资源进行相关的诊断。";
            break;
            break;
        case SourceTypeUcloud:
            return @"    您当前为免费版本，支持针对 UHost、UDisk、UNet、UDB、UFile、CLB、UVPC 这几类资源进行相关的诊断。";
            break;
       default:
            return nil;
            break;
    }
}
-(TTTAttributedLabel *)findHelpLab{
    if (!_findHelpLab) {
        //    Access Key 可在您的阿里云 RAM 账号中找到，详细步骤请点击这里
        NSString *linkText = @"查看帮助 ";
        NSString *promptText = [NSString stringWithFormat:@"    Access Key 可在您的%@账号中找到，详细步骤请点击这里%@", self.yunTitle,linkText];
        NSRange linkRange = [promptText rangeOfString:linkText];
        _findHelpLab = [[TTTAttributedLabel alloc] initWithFrame: CGRectZero];
        _findHelpLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _findHelpLab.textColor = [UIColor colorWithHexString:@"9B9EA0"];
        _findHelpLab.numberOfLines = 0;
        _findHelpLab.delegate = self;
        _findHelpLab.lineBreakMode = NSLineBreakByCharWrapping;
        _findHelpLab.text = promptText;
        NSDictionary *attributesDic = @{(NSString *)kCTForegroundColorAttributeName : (__bridge id)PWBlueColor.CGColor,
                                        (NSString *)kCTUnderlineStyleAttributeName : @(NO)
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
        [showWordsBtn setImage:[UIImage imageNamed:@"icon_disvisible"] forState:UIControlStateNormal];
        [showWordsBtn setImage:[UIImage imageNamed:@"icon_visible"] forState:UIControlStateSelected];
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
    UIAlertAction *edit = [PWCommonCtrl actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.TFArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.enabled = YES;
                }];
                UITextField *tf = self.TFArray[0];
                [tf becomeFirstResponder];
                self.showWordsBtn.enabled =NO;
                [self createNavWithType:NaviTypeEdit];
        }];
        [alert addAction:edit];
    UIAlertAction *delet = [PWCommonCtrl actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UIAlertController *deletAlert = [UIAlertController alertControllerWithTitle:nil message:@"删除情报源将会同时删除关于该情报的所有情报记录，请谨慎操作" preferredStyle:UIAlertControllerStyleAlert];
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
            [self addIssueSourcejudge];
        }else{
            [self modifyIssueSourcejudge];
        }
    }
}
#pragma mark ========== 编辑情报源 ==========
- (void)modifyIssueSourcejudge{
     NSDictionary *param ;
    if (self.type == SourceTypeAli || self.type ==SourceTypeAWS||self.type ==SourceTypeUcloud||self.type ==SourceTypeTencent) {
      if ([self.TFArray[1].text isEqualToString:self.model.akId]) {
             param = @{@"data":@{@"name":self.TFArray[0].text}};
        }else{
            param = @{@"data":@{@"name":self.TFArray[0].text,@"credentialJSON":@{@"akId":self.TFArray[1].text,@"akSecret":self.TFArray[2].text}}};
       }
         [self modifyIssueSourceWithParam:param];
    }else if(self.type == SourceTypeDomainNameDiagnose){
        param = @{@"data":@{@"provider":self.provider,@"name":self.TFArray[0].text,@"optionsJSON":@{@"domain":self.TFArray[0].text}}};
        [self modifyIssueSourceWithParam:param];
    }
}
- (void)modifyIssueSourceWithParam:(NSDictionary *)param{
    
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceModify(self.model.issueSourceId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
         if ([response[@"errorCode"] isEqualToString:@""]) {
         [SVProgressHUD showSuccessWithStatus:@"保存成功"];
         KPostNotification(KNotificationIssueSourceChange,nil);

        __weak typeof (self) vc = self;
        [vc.navigationController.view.layer addAnimation:[self createTransitionAnimation] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
         }else{
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];
         }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];

    }];
}
#pragma mark ========== 添加情报源 ==========
- (void)addIssueSourcejudge{
    NSDictionary *param;
     self.addTipView = [[AddIssueSourceTipView alloc]init];
    WeakSelf
    if (self.type != SourceTypeDomainNameDiagnose) {
        param = @{@"data":@{@"provider":self.provider,@"credentialJSON":@{@"akId":self.TFArray[1].text,@"akSecret":self.TFArray[2].text},@"name":self.TFArray[0].text}};
        
        [self.addTipView showInView:[UIApplication sharedApplication].keyWindow];
        self.addTipView.itemClick = ^{
         [weakSelf addIssueSourcewithparam:param];
        };
        self.addTipView.netClick = ^(NSURL *url){
        PWBaseWebVC *webvc = [[PWBaseWebVC alloc]initWithTitle:@"《用户数据安全协议》" andURL:url];
        weakSelf.addTipView.hidden = YES;
        [weakSelf.navigationController pushViewController:webvc animated:YES];
        };
    }else{
        param = @{@"data":@{@"provider":self.provider,@"name":self.TFArray[0].text,@"optionsJSON":@{@"domain":self.TFArray[0].text}}};
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请确认您添加的是一级域名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if( [self.TFArray[0].text validateTopLevelDomain]){
            [self.addTipView showInView:[UIApplication sharedApplication].keyWindow];
            self.addTipView.itemClick = ^{
                [weakSelf addIssueSourcewithparam:param];
            };
            self.addTipView.netClick = ^(NSURL *url){
            PWBaseWebVC *webvc = [[PWBaseWebVC alloc]initWithTitle:@"《用户数据安全协议》" andURL:url];
            weakSelf.addTipView.hidden = YES;
            [weakSelf.navigationController pushViewController:webvc animated:YES];
            };
            }else{
                [iToast alertWithTitleCenter:@"域名格式错误"];
            }
                
        }];
        [alert addAction:cancle];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}
- (void)addIssueSourcewithparam:(NSDictionary *)param{
    [PWNetworking requsetHasTokenWithUrl:PW_addIssueSource withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errorCode"] isEqualToString:@""]) {
            KPostNotification(KNotificationIssueSourceChange,nil);
            AddSourceTipView *tip = [[AddSourceTipView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, kHeight-kTopHeight-Interval(12)) type:AddSourceTipTypeSuccess];
            [self.view removeAllSubviews];
            [self.view addSubview:tip];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
            __weak typeof (self) vc = self;
            tip.btnClick = ^(){
                if(getConnectState == NO){
                    setIsHideGuide(YES);
                [vc.navigationController.view.layer addAnimation:[self createTransitionAnimation] forKey:nil];
                InformationSourceVC *source = [[InformationSourceVC alloc]init];
                [self.navigationController pushViewController:source animated:YES];
                }else{
                [vc.navigationController.view.layer addAnimation:[self createTransitionAnimation] forKey:nil];
                    for(UIViewController *temp in self.navigationController.viewControllers) {
                        if([temp isKindOfClass:[InformationSourceVC class]]){
                            [self.navigationController popToViewController:temp animated:YES];
                        }}
                    
                }
            };
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
    }];
}
#pragma mark ========== 删除情报源 ==========
- (void)delectIssueSource{
    [SVProgressHUD showWithStatus:@"正在删除..."];
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceDelete(self.model.issueSourceId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[@"errorCode"] isEqualToString:@""]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            KPostNotification(KNotificationIssueSourceChange,nil);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
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
-(CATransition *)createTransitionAnimation
{
    //切换之前添加动画效果
    //后面知识: Core Animation 核心动画
    //不要写成: CATransaction
    //创建CATransition动画对象
    CATransition *animation = [CATransition animation];
    //设置动画的类型:
    animation.type = @"reveal";
    //设置动画的方向
    animation.subtype = kCATransitionFromBottom;
    //设置动画的持续时间
    animation.duration = 1;
    //设置动画速率(可变的)
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画添加到切换的过程中
    return animation;
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
