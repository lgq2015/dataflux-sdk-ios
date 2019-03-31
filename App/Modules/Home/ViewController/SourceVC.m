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
#import "PWHttpEngine.h"
#import "CarrierItemModel.h"
#import "UIResponder+FirstResponder.h"
#import "AddSourceTipVC.h"
#import "IssueSourceManger.h"
#import "IssueListManger.h"

#define ACCESS_KEY @"****************"
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
@property (nonatomic, strong) IssueSourceConfige *confige;
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
    self.confige =  [[IssueSourceConfige alloc]initWithType:self.type];
    [self createUIWithType:type];
}

- (void)createUIWithType:(SourceType)type{
    self.title = self.confige.vcTitle;
    self.provider = self.confige.vcProvider;
    switch (type) {
        case SourceTypeAli:
            [self createSourceTypeYun];
            break;
        case SourceTypeSingleDiagnose:
            [self createSourceTypeSingle];
            break;
        case SourceTypeUcloud:
            [self createSourceTypeYun];
            break;
        case SourceTypeTencent:
            [self createSourceTypeYun];
            break;
        case SourceTypeAWS:
            [self createSourceTypeYun];
            break;
        case SourceTypeDomainNameDiagnose:
            [self createSourceTypeDomainName];
            break;
        case SourceTypeClusterDiagnose:
            [self createSourceTypeCluster];
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
            if([getTeamState isEqualToString:PW_isTeam]){
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
                        if(self.confige.issueTfArray[idx].enable == NO){
                            obj.textColor = PWSubTitleColor;
                        }
                    }];
                    RACSignal * navBtnSignal = [RACSignal combineLatest:signalAry reduce:^id{
                        __block BOOL isenable = NO;
                        [self.TFArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            DLog(@"%@%@",obj.text,self.confige.issueTfArray[idx].text);
                            if (self.confige.issueTfArray[idx].enable == YES && obj.text.length>0 &&![obj.text isEqualToString:self.confige.issueTfArray[idx].text]) {
                                isenable = YES;
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
- (void)createSourceTypeYun{

       UIView *tipView = [self tipsViewWithBackImg:@"card" tips:self.confige.topTip];
      [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(110));
        }];
    if(!self.isAdd){
        NSMutableArray<IssueTf*> *tfArray = [NSMutableArray arrayWithArray:self.confige.issueTfArray];
        tfArray[0].text = self.model.name;
        tfArray[1].text = self.model.akId;
        tfArray[2].text = ACCESS_KEY;
    }

        UIView *temp = nil;
        self.TFArray = [NSMutableArray new];
        temp = tipView;
        for (IssueTf *tf in self.confige.issueTfArray) {
            UIView *item = [self itemViewWithIssueTF:tf tag:self.TFArray.count+1];
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
                if (![x isEqualToString:self.model.akId] &&[password.text isEqualToString:ACCESS_KEY]) {
                    password.text = @"";
                    self.isFirstEdit = NO;
                    self.showWordsBtn.hidden = NO;
                    self.showWordsBtn.enabled = YES;
                }
            }
        }];

        [[password rac_textSignal] subscribeNext:^(id x) {
            self.showWordsBtn.hidden = [x isEqualToString:ACCESS_KEY]?YES:NO;
            self.showWordsBtn.enabled = !self.showWordsBtn.hidden;
        }];
    }
}
#pragma mark ========== 单机诊断 ==========
- (void)createSourceTypeSingle{


    if(!self.isAdd){
        self.confige.issueTfArray[0].text = self.model.name;
        self.confige.issueTfArray[1].text = self.model.clusterID;
    }

    UIView *temp = nil;
    for (NSInteger i=0; i<self.confige.issueTfArray.count; i++) {
        UIView *item = [self itemViewWithIssueTF:self.confige.issueTfArray[i] tag:i+1];
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

    [self bindClusterOrHostView];

}

#pragma mark ========== 先知监控 ==========
- (void)createSourceTypeCluster{

    if (!self.isAdd) {
        self.confige.issueTfArray[0].text = self.model.name;
        self.confige.issueTfArray[1].text = self.model.clusterID;
    }
        UIView *temp = nil;
        for (NSInteger i=0; i<self.confige.issueTfArray.count; i++) {
            UIView *item = [self itemViewWithIssueTF:self.confige.issueTfArray[i] tag:i+1];
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
                if(i<self.confige.issueTfArray.count-1){
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

    [self bindClusterOrHostView];

}

- (void)bindClusterOrHostView {

    [[PWHttpEngine sharedInstance] getProbe:self.model.clusterID callBack:^(id o) {
        CarrierItemModel *data = ((CarrierItemModel *) o);
        if ([data isSuccess]) {
            self.TFArray[2].text = data.hostName;
            self.TFArray[3].text = data.host;
        } else {
            [iToast alertWithTitleCenter:data.errorMsg delay:1];
        }

    }];
}


#pragma mark ========== 域名诊断 ==========
- (void)createSourceTypeDomainName{
        IssueTf *tf = self.confige.issueTfArray[0];
        tf.text = self.isAdd?@"":self.model.name;
        NSString *tips = self.confige.topTip;
        UIView *tipView = [self tipsViewWithBackImg:@"card" tips:tips];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self.view).offset(Interval(13));
            make.right.mas_equalTo(self.view).offset(Interval(-13));
            make.height.offset(ZOOM_SCALE(110));
        }];
        UIView *item = [self itemViewWithIssueTF:tf tag:33];
        [self.view addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipView.mas_bottom).offset(Interval(12));
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(65));
        }];


}


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
            NSString *tiptext = self.confige.subTip;
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

-(TTTAttributedLabel *)findHelpLab{
    if (!_findHelpLab) {
        //    Access Key 可在您的阿里云 RAM 账号中找到，详细步骤请点击这里
        NSString *linkText = @"查看帮助 ";
        NSString *promptText = [NSString stringWithFormat:@"    Access Key 可在您的%@账号中找到，详细步骤请点击这里%@", self.confige.yunTitle,linkText];
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
        [_findHelpLab addLinkToURL:[NSURL URLWithString:self.confige.helpUrl] withRange:linkRange];
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
    tipLab.font = MediumFONT(16);
    tipLab.bounds = CGRectMake(0, 0, kWidth-Interval(40), 85);
    tipLab.textColor = PWWhiteColor;
    tipLab.textAlignment = NSTextAlignmentLeft;
    tipLab.numberOfLines = 0;
    [view addSubview:tipLab];
    [tipLab sizeToFit];
    CGFloat left = (kWidth-Interval(32)-tipLab.frame.size.width)/2.0;
    [self.view addSubview:view];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(ZOOM_SCALE(15));
        make.left.mas_equalTo(view).offset(left);
        make.right.mas_equalTo(view).offset(Interval(-left));
    }];
    
    return view;
}
- (UIView *)itemViewWithIssueTF:(IssueTf *)issueTF tag:(NSInteger)tag{
    UIView *item = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(65))];
    [self.view addSubview:item];
    item.backgroundColor = PWWhiteColor;
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake (Interval(16), ZOOM_SCALE(8), 200, ZOOM_SCALE(20)) font:MediumFONT(14) textColor:PWTitleColor text:issueTF.tfTitle];
    [item addSubview:titleLab];
    UITextField *tf = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(34), kWidth-Interval(32), ZOOM_SCALE(22))];
    tf.tag = tag;
    tf.secureTextEntry = issueTF.secureTextEntry;
    if (issueTF.secureTextEntry) {
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
    tf.placeholder = issueTF.placeHolder;
    if (!self.isAdd) {
        tf.text = issueTF.text;
        tf.enabled = NO;
    }
    [item addSubview:tf];
    [self.TFArray addObject:tf];
    return item;
}

#pragma mark ========== navClick ==========
- (void)navRightBtnClick:(UIButton *)button{
    
    //编辑按钮
    if(button.tag == 99){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *edit = [PWCommonCtrl actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.TFArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.enabled = self.confige.issueTfArray[idx].enable;
                }];
                UITextField *tf = self.TFArray[0];
                [tf becomeFirstResponder];
                self.showWordsBtn.enabled =NO;
        
                [self createNavWithType:NaviTypeEdit];
        }];
        [alert addAction:edit];
        if (self.type!=SourceTypeClusterDiagnose) {
            UIAlertAction *delet = [PWCommonCtrl actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

                UIAlertController *deletAlert = [UIAlertController alertControllerWithTitle:nil message:self.confige.deletAlert preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self deleteIssueSource];
                }];
                UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [deletAlert addAction:confirm];
                [deletAlert addAction:cancel];
                [self presentViewController:deletAlert animated:YES completion:nil];

            }];
            [alert addAction:delet];
        }

    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];

    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
    }else if(button.tag == 100){
        
        if(self.isAdd){
            [[UIResponder currentFirstResponder] resignFirstResponder];
            [self addIssueSourcejudge];
        }else{
            [[UIResponder currentFirstResponder] resignFirstResponder];
            [self modifyIssueSourcejudge];
        }
    }
}
#pragma mark ========== 编辑情报源 ==========
- (void)modifyIssueSourcejudge{
     NSDictionary *param ;
    if (self.type == SourceTypeAli || self.type ==SourceTypeAWS||self.type ==SourceTypeUcloud||self.type ==SourceTypeTencent) {
      if ([self.TFArray[1].text isEqualToString:self.model.akId] && [self.TFArray[2].text isEqualToString:@"****************"]) {
             param = @{@"data":@{@"name":self.TFArray[0].text}};
        }else{
            param = @{@"data":@{@"name":self.TFArray[0].text,@"credentialJSON":@{@"akId":self.TFArray[1].text,@"akSecret":self.TFArray[2].text}}};
       }
         [self modifyIssueSourceWithParam:param];
    }else if(self.type == SourceTypeDomainNameDiagnose){
        param = @{@"data":@{@"name":self.TFArray[0].text,@"optionsJSON":@{@"domain":self.TFArray[0].text}}};
        [self modifyIssueSourceWithParam:param];
    }else if(self.type == SourceTypeClusterDiagnose||self.type == SourceTypeSingleDiagnose){
        [[PWHttpEngine sharedInstance] patchProbe:self.model.clusterID
                                             name:self.TFArray[0].text callBack:^(id o) {

                    BaseReturnModel *data = ((BaseReturnModel *) o) ;
                    if([data isSuccess]){
                        [self saveSuccess];
                    } else{
                        [SVProgressHUD showErrorWithStatus:@"保存失败"];
                    }

                }];

    }
}

-(void)saveSuccess{
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    KPostNotification(KNotificationIssueSourceChange,nil);
    __weak typeof (self) vc = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc.navigationController.view.layer addAnimation:[self createTransitionAnimation] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    });
   
}


- (void)modifyIssueSourceWithParam:(NSDictionary *)param{

    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceModify(self.model.issueSourceId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errorCode"] isEqualToString:@""]) {
            [self saveSuccess];
        } else {
            if([response[ERROR_CODE] isEqualToString:@"home.issueSource.invalidIssueSourceAK"]){
                 [iToast alertWithTitleCenter:@"密钥验证失败"];
            }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }
        }
    } failBlock:^(NSError *error) {
       
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];

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
        PWBaseWebVC *webvc = [[PWBaseWebVC alloc]initWithTitle:@"用户数据安全协议" andURL:url];
        weakSelf.addTipView.hidden = YES;
        [weakSelf.navigationController pushViewController:webvc animated:YES];
        };
    }else{
        if(![self.TFArray[0].text validateTopLevelDomain]){
            [iToast alertWithTitleCenter:@"域名格式错误"];
        }else{
        param = @{@"data":@{@"provider":self.provider,@"name":self.TFArray[0].text,@"optionsJSON":@{@"domain":self.TFArray[0].text}}};
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请确认您添加的是一级域名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        }];
        UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            [self.addTipView showInView:[UIApplication sharedApplication].keyWindow];
            self.addTipView.itemClick = ^{
                [weakSelf addIssueSourcewithparam:param];
            };
            self.addTipView.netClick = ^(NSURL *url){
            PWBaseWebVC *webvc = [[PWBaseWebVC alloc]initWithTitle:@"用户数据安全协议" andURL:url];
            weakSelf.addTipView.hidden = YES;
            [weakSelf.navigationController pushViewController:webvc animated:YES];
            };

        }];

        [alert addAction:cancle];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }
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


                [vc.navigationController.view.layer addAnimation:[self createTransitionAnimation] forKey:nil];
            __block   BOOL hasInfoSource = NO;
             for(UIViewController *temp in self.navigationController.viewControllers) {
                if([temp isKindOfClass:[InformationSourceVC class]]){
                    hasInfoSource = YES;
                [self.navigationController popToViewController:temp animated:YES];
                }
             }
                if (hasInfoSource == NO) {
                InformationSourceVC *source = [[InformationSourceVC alloc]init];
                [self.navigationController pushViewController:source animated:YES];
                }
            };
        }else{
          if([response[ERROR_CODE] isEqualToString:@"home.issueSource.basicSourceExceedCount"]){
              AddSourceTipVC *tipVC = [[AddSourceTipVC alloc]init];
              [self.navigationController pushViewController:tipVC animated:YES];
              
            }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
            }
        }
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
    }];
}


-(void)deleteAndRefreshDB{
    KPostNotification(KNotificationIssueSourceChange, nil);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[IssueListManger sharedIssueListManger] deleteIssueWithIssueSourceID:self.model.issueSourceId];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


#pragma mark ========== 删除情报源 ==========
- (void)deleteIssueSource{
    [SVProgressHUD showWithStatus:@"正在删除..."];

    void (^sourceNotExist)(void) = ^{
        [SVProgressHUD dismiss];
        [iToast alertWithTitleCenter:@"情报源不存在"];
        [self deleteAndRefreshDB];

    };

    void (^deleteSuccess)(void) = ^{
        [SVProgressHUD showSuccessWithStatus:@"已删除"];
        KPostNotification(KNotificationIssueSourceChange, nil);
        [self deleteAndRefreshDB];

    };


    if (self.type == SourceTypeSingleDiagnose) {
        [[PWHttpEngine sharedInstance] deleteProbe:self.model.clusterID callBack:^(id o) {
            BaseReturnModel *data = ((BaseReturnModel *) o);
            if ([data isSuccess]) {
                deleteSuccess();
            } else {
                if ([data.errorCode isEqualToString:@"carrier.kodo.issueSourceNotSet"]) {
                    sourceNotExist();
                } else {
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }

            }
        }];

    } else {

        [PWNetworking requsetHasTokenWithUrl:PW_issueSourceDelete(self.model.issueSourceId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[@"errorCode"] isEqualToString:@""]) {
                deleteSuccess();
            } else {
                if ([response[ERROR_CODE] isEqualToString:@"home.issueSource.noSuchIssueSource"]) {
                    sourceNotExist();

                } else {
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }
            }

        }                          failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }];
    }

}
-(void)navLeftBtnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== TTTAttributedLabelDelegate ==========
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    PWBaseWebVC *web = [[PWBaseWebVC alloc]initWithTitle:@"查看帮助" andURL:url];
    [self.navigationController pushViewController:web animated: YES];
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
    animation.duration = 0.3;
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
