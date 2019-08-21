//
//  MoreRuleLinkCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MoreRuleLinkCell.h"
#import "TouchLargeButton.h"
@interface MoreRuleLinkCell()<UITextFieldDelegate>
@property (nonatomic, strong) TouchLargeButton *minusBtn;
@property (nonatomic, strong) UITextField *linkTf;
@end
@implementation MoreRuleLinkCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.width.height.offset(ZOOM_SCALE(16));
        make.centerY.mas_equalTo(self);
    }];
    [self.linkTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minusBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-16);
    }];
}
-(void)setLinkStr:(NSString *)linkStr{
    _linkStr = linkStr;
    self.linkTf.text = linkStr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setIsDing:(BOOL)isDing{
    if(isDing){
    self.linkTf.placeholder = NSLocalizedString(@"local.PleaseInputDingDingCallbackAddress", @"");
    }else{
    self.linkTf.placeholder = NSLocalizedString(@"local.PleaseInputCustomCallbackAddress", @"");
    }
}
- (void)minusBtnClick{
    if (self.minusBlock) {
        self.minusBlock();
    }
}
-(TouchLargeButton *)minusBtn{
    if (!_minusBtn) {
        _minusBtn = [[TouchLargeButton alloc]init];
        _minusBtn.largeHeight = 30;
        [_minusBtn setImage:[UIImage imageNamed:@"link_minus"] forState:UIControlStateNormal];
        [_minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minusBtn];
    }
    return _minusBtn;
}
-(UITextField *)linkTf{
    if (!_linkTf) {
        _linkTf = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(14)];
        _linkTf.delegate = self;
        [self addSubview:_linkTf];
    }
    return _linkTf;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    WeakSelf
    if(self.linkBlock){
        self.linkBlock(weakSelf.linkTf.text);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
