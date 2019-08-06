//
//  ZYPayWayUIManager.m
//  App
//
//  Created by tao on 2019/4/22.
//  Copyright © 2019 hll. All rights reserved.
//
#define PayWayViewH 280.0

#import "ZYPayWayUIManager.h"
@interface ZYPayWayUIManager()
@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View
@property (nonatomic,strong) UIView * payWayView;//!<分享背景
@property (nonatomic, strong) UILabel *payWayLab;
@property (nonatomic, strong) UILabel *zhifubaoLab;
@property (nonatomic, strong) UILabel *contactsaleLab;
@property (nonatomic, strong) UIButton *zhifubaoBtn;
@property (nonatomic, strong) UIButton *contactsaleBtn;
@property (nonatomic, strong) UIButton *surePayBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy)PayWayBlock payWayBlock;
@property (nonatomic, strong)UIButton *selectedPayWayBtn; //选中的支付按钮
@property (nonatomic, assign)SelectPayWayType selectPayWayType;
@end
@implementation ZYPayWayUIManager
+ (instancetype)shareInstance{
    static ZYPayWayUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYPayWayUIManager alloc] init];
    });
    return instance;
}


#pragma mark --添加主控件--
-(void)s_UI{
    [self.window addSubview:self.backgroundGrayView];
    [self.window addSubview:self.payWayView];
    [self.payWayView addSubview:self.payWayLab];
    [self.payWayView addSubview:self.zhifubaoLab];
    [self.payWayView addSubview:self.contactsaleLab];
    [self.payWayView addSubview:self.zhifubaoBtn];
    [self.payWayView addSubview:self.contactsaleBtn];
    [self.payWayView addSubview:self.surePayBtn];
    [self.payWayView addSubview:self.closeBtn];
    [self p_hideFrame];
    [self s_childUI];
}

//隐藏
-(void)p_hideFrame{
    _payWayView.frame =CGRectMake(0,kHeight, kWidth, PayWayViewH);
}

//展示
-(void)p_disFrame{
    _payWayView.frame =CGRectMake(0,kHeight-PayWayViewH, kWidth, PayWayViewH);
}
#pragma mark - 布局子控件
- (void)s_childUI{
    [self.payWayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payWayView.mas_left).offset(16);
        make.top.equalTo(self.payWayView.mas_top).offset(52);
    }];
    [self.zhifubaoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payWayLab.mas_left);
        make.top.equalTo(self.payWayLab.mas_bottom).offset(27);
    }];
    [self.contactsaleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payWayLab.mas_left);
        make.top.equalTo(self.zhifubaoLab.mas_bottom).offset(27);
    }];
    [self.zhifubaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zhifubaoLab);
        make.right.equalTo(self.payWayView).offset(-28);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.contactsaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contactsaleLab);
        make.width.equalTo(self.zhifubaoBtn.mas_width);
        make.height.equalTo(self.zhifubaoBtn.mas_height);
        make.right.equalTo(self.zhifubaoBtn.mas_right);
    }];
    [self.surePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.payWayView.mas_bottom).offset(-21);
        make.left.equalTo(self.payWayView.mas_left).offset(16);
        make.right.equalTo(self.payWayView.mas_right).offset(-16);
        make.height.equalTo(@47);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payWayView.mas_top).offset(8);
        make.right.equalTo(self.payWayView.mas_right).offset(-15);
        make.width.height.equalTo(@47);
    }];
}
#pragma mark - 展示
- (void)showWithPayWaySelectionBlock:(PayWayBlock)payWayBlock{
    _payWayBlock = payWayBlock;
    [self s_UI];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_disFrame];
        self->_payWayView.alpha = 1;
        self->_backgroundGrayView.alpha = 0.8;
    } completion:^(BOOL finished) {
        if (finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];

    [UIView commitAnimations];
}
-(void)dismiss{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_hideFrame];
        self.alpha = 0;
        self.payWayView.alpha = 0;
        self.backgroundGrayView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.payWayView = nil;
            [self.payWayView removeFromSuperview];
            [self.backgroundGrayView removeFromSuperview];
            [self removeFromSuperview];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [UIView commitAnimations];
}

#pragma mark -  按钮交互事件
-(void)payWayBtnClick:(UIButton *)btn{
    if (btn.tag != _selectedPayWayBtn.tag){
        _selectedPayWayBtn.selected = NO;
        btn.selected = !btn.selected;
        _selectedPayWayBtn = btn;
    }
   
}
- (void)sureBtnClick:(UIButton *)btn{
    switch (_selectedPayWayBtn.tag) {
        case 100:
            self.selectPayWayType = Zhifubao_PayWayType;
            break;
        case 101:
            self.selectPayWayType = ContactSale_PayWayType;
            break;
        default:
            break;
    }
    _payWayBlock(self.selectPayWayType);
    [self dismiss];
}
#pragma mark --lazy--
-(UIWindow *)window{
    if (!_window) {
        _window = [[[UIApplication sharedApplication]delegate]window];
    }
    return _window;
}
-(UIView *)payWayView{
    if (!_payWayView) {
        _payWayView = [[UIView alloc]init];
        _payWayView.backgroundColor = [UIColor whiteColor];
    }
    return _payWayView;
}
-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,0, kWidth, kHeight);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_backgroundGrayView addGestureRecognizer:tap];
        
    }
    return _backgroundGrayView;
}
- (UILabel *)payWayLab{
    if (!_payWayLab){
        _payWayLab = [[UILabel alloc] init];
        _payWayLab.font = [UIFont systemFontOfSize:20];
        _payWayLab.text = @"支付方式";
    }
    return _payWayLab;
}
- (UILabel *)zhifubaoLab{
    if (!_zhifubaoLab){
        _zhifubaoLab = [[UILabel alloc] init];
        _zhifubaoLab.font = [UIFont systemFontOfSize:20];
        _zhifubaoLab.text = @"支付宝";
    }
    return _zhifubaoLab;
}
- (UILabel *)contactsaleLab{
    if (!_contactsaleLab){
        _contactsaleLab = [[UILabel alloc] init];
        _contactsaleLab.font = [UIFont systemFontOfSize:20];
        _contactsaleLab.text = @"联系销售";
    }
    return _contactsaleLab;
}
- (UIButton *)zhifubaoBtn{
    if (!_zhifubaoBtn){
        _zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhifubaoBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [_zhifubaoBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
        _zhifubaoBtn.tag = 100;
        [_zhifubaoBtn addTarget:self action:@selector(payWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _zhifubaoBtn.selected = YES;
        _selectedPayWayBtn =_zhifubaoBtn;
        //TODO:zhangtao
        _zhifubaoBtn.layer.cornerRadius = 10;
        _zhifubaoBtn.layer.masksToBounds = YES;
    }
    return _zhifubaoBtn;
}
- (UIButton *)contactsaleBtn{
    if (!_contactsaleBtn){
        _contactsaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactsaleBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [_contactsaleBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
        [_contactsaleBtn setImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
        _contactsaleBtn.tag = 101;
        [_contactsaleBtn addTarget:self action:@selector(payWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //TODO:zhangtao
        _contactsaleBtn.layer.cornerRadius = 10;
        _contactsaleBtn.layer.masksToBounds = YES;
    }
    return _contactsaleBtn;
}
- (UIButton *)surePayBtn{
    if (!_surePayBtn){
        _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _surePayBtn.backgroundColor = [UIColor colorWithHexString:@"#2A7AF7"];
        _surePayBtn.layer.cornerRadius = 23.5;
        _surePayBtn.layer.masksToBounds = YES;
        _surePayBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_surePayBtn setTitle:@"￥1000，000  去支付" forState:UIControlStateNormal];
        [_surePayBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _surePayBtn;
}
- (UIButton *)closeBtn{
    if (!_closeBtn){
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_payway_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
