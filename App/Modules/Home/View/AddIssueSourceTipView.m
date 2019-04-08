//
//  AddIssueSourceTipView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddIssueSourceTipView.h"
#import <TTTAttributedLabel.h>

@interface AddIssueSourceTipView()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TTTAttributedLabel *protocolLab;

@end
@implementation AddIssueSourceTipView
-(instancetype)init{
    if (self) {
        self= [super init];
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((kWidth-ZOOM_SCALE(270))/2.0, ZOOM_SCALE(149)+kTopHeight-64, ZOOM_SCALE(270), ZOOM_SCALE(308))];
        [self addSubview:_contentView];
        _contentView.layer.cornerRadius = 8.0;
        _contentView.backgroundColor = PWWhiteColor;
        UILabel *titleLab =[PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@"温馨提示"];
        [_contentView addSubview:titleLab];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentView).offset(ZOOM_SCALE(27));
            make.height.offset(ZOOM_SCALE(25));
            make.right.left.mas_equalTo(_contentView);
        }];
        UILabel *contentLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"依据最新的法律法规及监管政策的要求，我们拟定了《用户数据安全协议》。请您务必仔细阅读协议的内容，在充分了解后确认添加此云账号。"];
        [_contentView addSubview:contentLab];
        contentLab.numberOfLines = 0;
        [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLab.mas_bottom).offset(ZOOM_SCALE(17));
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(21));
            make.right.mas_equalTo(_contentView).offset(-ZOOM_SCALE(21));
        }];
        [_contentView addSubview:self.protocolLab];
        [self.protocolLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLab.mas_bottom).offset(ZOOM_SCALE(23));
            make.left.right.mas_equalTo(contentLab);
        }];
      
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [_contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView);
            make.right.mas_equalTo(_contentView);
            make.height.offset(1);
            make.bottom.mas_equalTo(_contentView).offset(-ZOOM_SCALE(41));
        }];
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [_contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.centerX.mas_equalTo(_contentView);
            make.width.offset(1);
            make.bottom.mas_equalTo(_contentView);
        }];
        UIButton *cancle = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"暂不同意"];
        [cancle setTitleColor:[UIColor colorWithHexString:@"#8E8E93"] forState:UIControlStateNormal];
        cancle.titleLabel.font = RegularFONT(15);
        [_contentView addSubview:cancle];
        [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(5));
            make.right.mas_equalTo(line2.mas_right);
            make.top.mas_equalTo(line.mas_bottom);
            make.bottom.mas_equalTo(line2.mas_bottom);
        }];
        [cancle addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        UIButton *addBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"同意并添加"];
        addBtn.titleLabel.font = RegularFONT(15);
        [_contentView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line2.mas_right);
            make.right.mas_equalTo(_contentView).offset(-ZOOM_SCALE(5));
            make.top.mas_equalTo(line.mas_bottom);
            make.bottom.mas_equalTo(line2.mas_bottom);
        }];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(TTTAttributedLabel *)protocolLab{
    if (!_protocolLab) {
        //    Access Key 可在您的阿里云 RAM 账号中找到，详细步骤请点击这里
        NSString *linkText = @"《用户数据安全协议》";
        NSString *promptText = [NSString stringWithFormat:@"点击“同意”即代表您已阅读并理解%@",linkText];
        NSRange linkRange = [promptText rangeOfString:linkText];
        _protocolLab = [[TTTAttributedLabel alloc] initWithFrame: CGRectZero];
        _protocolLab.font = RegularFONT(15);
        _protocolLab.textColor = [UIColor colorWithHexString:@"8E8E93"];
        _protocolLab.numberOfLines = 0;
        _protocolLab.delegate = self;
        _protocolLab.lineBreakMode = NSLineBreakByCharWrapping;
        _protocolLab.text = promptText;
        NSDictionary *attributesDic = @{(NSString *)kCTForegroundColorAttributeName : (__bridge id)PWBlueColor.CGColor,
                                        (NSString *)kCTUnderlineStyleAttributeName : @(NO)
                                        };
        _protocolLab.linkAttributes = attributesDic;
        _protocolLab.activeLinkAttributes = attributesDic;
        [_protocolLab addLinkToURL:[NSURL URLWithString:PW_Safelegal] withRange:linkRange];
    }
    return _protocolLab;
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [view addSubview:self];
}
- (void)addBtnClick{
    if (self.itemClick) {
        self.itemClick();
    }
    [self disMissView];
}
- (void)disMissView{
    [self removeFromSuperview];
    [_contentView removeFromSuperview];
}
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    if (self.netClick) {
        self.netClick(url);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
