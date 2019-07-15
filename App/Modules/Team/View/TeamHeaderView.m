//
//  TeamHeaderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamHeaderView.h"
#import "UIColor+Gradual.h"
#import "UtilsConstManager.h"

@interface TeamHeaderView ()
@property (nonatomic, strong) UIView *bgContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *specialProjectView;
@end
@implementation TeamHeaderView
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)createUI{
    self.backgroundColor = PWWhiteColor;
    [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(12);
        make.left.mas_equalTo(self).offset(16);
        make.right.mas_equalTo(self).offset(-16);
        make.bottom.mas_equalTo(self).offset(-12);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgContentView).offset(12);
        make.top.mas_equalTo(self.bgContentView).offset(20);
        make.height.offset(ZOOM_SCALE(30));
    }];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.bgContentView);
        make.width.offset(ZOOM_SCALE(163));
        make.height.offset(ZOOM_SCALE(108));
    }];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(18);
        make.height.offset(ZOOM_SCALE(17));
        make.width.offset(ZOOM_SCALE(50));
    }];
   
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipLab.mas_right).offset(18);
        make.height.offset(SINGLE_LINE_WIDTH/2);
        make.centerY.mas_equalTo(self.tipLab);
        make.right.mas_equalTo(self.bgContentView).offset(-10);
    }];
    [self.specialProjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.bgContentView);
        make.top.mas_equalTo(self.tipLab.mas_bottom).offset(8);
        make.height.offset(ZOOM_SCALE(15)+13);
    }];
    
}
-(void)updataUIWithDatas:(NSDictionary *)datas{
    [self.specialProjectView removeAllSubviews];
  
    NSDictionary *CloudCare = PWSafeDictionaryVal(datas, @"CloudCare");
    NSString *code = [CloudCare stringValueForKey:@"code" default:@""];
    UtilsConstManager *manager = [[UtilsConstManager alloc]init];
    [manager getserviceCodeNameByKey:code name:^(NSString * _Nonnull name) {
        self.titleLab.text = name;
    }];
    CGFloat height = ZOOM_SCALE(47)+50;

    if ([datas containsObjectForKey:@"managed"]) {
        NSArray *managed = PWSafeArrayVal(datas, @"managed");
        if (managed.count == 0) {
            self.tipLab.hidden = YES;
            self.line.hidden = YES;
            height +=ZOOM_SCALE(17)+12;
            [self.specialProjectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(ZOOM_SCALE(15)+12);
            }];
        }else{
            self.tipLab.hidden = NO;
            self.line.hidden = NO;
            UIView *temp = nil;
            for (NSInteger i=0; i<managed.count; i++) {
                NSDictionary *dict = managed[i];
                NSString *manageCode = [dict stringValueForKey:@"code" default:@""];
                NSString *icon = manageCode;
                UIColor *labColor = PWWhiteColor;
                if ([code isEqualToString:@"CloudCare_default"]) {
                    labColor = PWTextBlackColor;
                    icon = [NSString stringWithFormat:@"%@1",manageCode];
                }
                UIImageView *iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
                [self.specialProjectView addSubview:iconImg];
                UILabel *lab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:labColor text:@""];
                [manager getserviceCodeNameByKey:manageCode name:^(NSString * _Nonnull name) {
                    lab.text = name;
                }];
                [self.specialProjectView addSubview:lab];
                [lab sizeToFit];
                CGFloat labWidth = lab.frame.size.width;
                if (temp == nil) {
                    iconImg.frame = CGRectMake(11, 0, ZOOM_SCALE(15), ZOOM_SCALE(15));
                    lab.frame = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, 0, labWidth+2, ZOOM_SCALE(17));
                    lab.centerY = iconImg.centerY;
                }else{
                    CGFloat lastWidth = CGRectGetMaxX(temp.frame);
                    if (lastWidth+33+ZOOM_SCALE(15)+labWidth>kWidth-32) {
                        iconImg.frame = CGRectMake(11, CGRectGetMaxY(temp.frame)+8, ZOOM_SCALE(15), ZOOM_SCALE(15));
                        lab.frame = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, 0, labWidth+2, ZOOM_SCALE(17));
                        lab.centerY = iconImg.centerY;
                    }else{
                        iconImg.frame = CGRectMake(lastWidth+15, 0, ZOOM_SCALE(15), ZOOM_SCALE(15));
                        lab.frame = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, 0, labWidth+2, ZOOM_SCALE(17));
                        lab.centerY = iconImg.centerY;
                    }
                }
                temp = lab;
                if (i == managed.count-1) {
                    height +=CGRectGetMaxY(lab.frame)+12;
                    [self.specialProjectView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(CGRectGetMaxY(lab.frame)+12);
                    }];
                }
            }
        }
        
        
    }
    
    self.titleLab.textColor = PWWhiteColor;
    self.tipLab.textColor = PWWhiteColor;
    self.line.backgroundColor = PWWhiteColor;
    self.bgImgView.image = [UIImage imageNamed:code];
    if ([code isEqualToString:@"CloudCare_default"]) {
        self.titleLab.textColor = PWTextBlackColor;
        self.tipLab.textColor = [UIColor colorWithHexString:@"#949499"];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        [self.bgContentView.layer insertSublayer:[UIColor setGradualChangingColorWithFrame:CGRectMake(0, 0, kWidth-32, height)  fromColor:@"#F4F4FA" mediumColor:@"" toColor:@"#FFFFFF" isDefault:NO]  atIndex:0];
        self.bgContentView.layer.shadowColor = PWBlackColor.CGColor;

    }
    if ([code isEqualToString:@"CloudCare_1"]) {
         [self.bgContentView.layer insertSublayer:[UIColor setGradualChangingColorWithFrame:CGRectMake(0, 0, kWidth-32, height)  fromColor:@"#0CCAB8" mediumColor:@"#38D8C4" toColor:@"#24D8C5" isDefault:YES] atIndex:0];
        self.bgContentView.layer.shadowColor = [UIColor colorWithHexString:@"#95E9DE"].CGColor;
    }
    if ([code isEqualToString:@"CloudCare_2"]) {
          [self.bgContentView.layer insertSublayer:[UIColor setGradualChangingColorWithFrame:CGRectMake(0, 0, kWidth-32, height)  fromColor:@"#895DFF" mediumColor:@"" toColor:@"#8A79FF" isDefault:YES] atIndex:0];
        
        self.bgContentView.layer.shadowColor = [UIColor colorWithHexString:@"#FFC994"].CGColor;

    }
    if ([code isEqualToString:@"CloudCare_3"]) {
         [self.bgContentView.layer insertSublayer:[UIColor setGradualChangingColorWithFrame:CGRectMake(0, 0, kWidth-32, height)  fromColor:@"#FF8033" mediumColor:@"#FDC55E" toColor:@"#FFB04F" isDefault:YES] atIndex:0];
        self.bgContentView.layer.shadowColor = [UIColor colorWithHexString:@"#BEAAFF"].CGColor;
    }
    
    
    
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        [self.bgContentView addSubview:_line];
    }
    return _line;
}
-(UIView *)specialProjectView{
    if (!_specialProjectView) {
        _specialProjectView = [[UIView alloc]init];
        [self.bgContentView addSubview:_specialProjectView];
    }
    return _specialProjectView;
}
-(UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWWhiteColor text:@"专项权益"];
        [self.bgContentView addSubview:_tipLab];
    }
    return _tipLab;
}
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
        [self.bgContentView addSubview:_bgImgView];
    }
    return _bgImgView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(22) textColor:PWWhiteColor text:@""];
        [self.bgContentView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UIView *)bgContentView{
    if (!_bgContentView ) {
        _bgContentView = [[UIView alloc]init];
        _bgContentView.layer.masksToBounds = YES;
        _bgContentView.layer.shadowRadius = 6;
        self.layer.shadowOffset = CGSizeMake(0,2);
        _bgContentView.layer.shadowOpacity = 0.06;
        _bgContentView.layer.cornerRadius = 3.0;
        [self addSubview:_bgContentView];
    }
    return _bgContentView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
