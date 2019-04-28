//
//  DetectionVersionAlert.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "DetectionVersionAlert.h"
@interface DetectionVersionAlert()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSString *releaseNotes;
@property (nonatomic, copy) NSString *version;
@end
@implementation DetectionVersionAlert

-(instancetype)initWithReleaseNotes:(NSString *)releaseNotes Version:(NSString *)version
{
    if (self) {
        self= [super init];
        self.releaseNotes = releaseNotes;
        self.version = version;
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((kWidth-ZOOM_SCALE(300))/2.0, ZOOM_SCALE(132)+kTopHeight-64, ZOOM_SCALE(300), ZOOM_SCALE(363))];
        
        [self addSubview:_contentView];
        UIImageView *back = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_newVersion"]];
        [_contentView addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_contentView);
            make.top.bottom.mas_equalTo(_contentView);
        }];
        UILabel *tip  =[PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(20) textColor:PWWhiteColor text:@"发现新版本"];
        [_contentView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(42));
            make.top.mas_equalTo(_contentView).offset(ZOOM_SCALE(19));
            make.height.offset(ZOOM_SCALE(28));
        }];
        UILabel *versionLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWWhiteColor text:self.version];
        [_contentView addSubview:versionLab];
        versionLab.textAlignment = NSTextAlignmentCenter;
        [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tip.mas_bottom).offset(ZOOM_SCALE(1));
            make.height.offset(ZOOM_SCALE(22));
            make.width.mas_equalTo(tip);
            make.centerX.mas_equalTo(tip);
        }];
        UILabel *update = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:@"更新内容"];
        [_contentView addSubview:update];
        [update mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentView).offset(ZOOM_SCALE(132));
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(42));
            make.height.offset(ZOOM_SCALE(22));
        }];
        UITextView *releaseNotesLab = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:@"" font:RegularFONT(16)];
        releaseNotesLab.textColor = PWTextBlackColor;
        releaseNotesLab.text = self.releaseNotes;
        [_contentView addSubview:releaseNotesLab];
        [releaseNotesLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(42));
            make.top.mas_equalTo(update.mas_bottom).offset(ZOOM_SCALE(9));
            make.right.mas_equalTo(_contentView).offset(-ZOOM_SCALE(16));
            make.bottom.mas_equalTo(_contentView).offset(-ZOOM_SCALE(11)-45);
        }];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [_contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(7));
            make.right.mas_equalTo(_contentView).offset(-ZOOM_SCALE(7));
            make.height.offset(1);
            make.bottom.mas_equalTo(_contentView).offset(-ZOOM_SCALE(11)-40);
        }];
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [_contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(150));
            make.right.mas_equalTo(_contentView).offset(-ZOOM_SCALE(149));
            make.width.offset(1);
            make.bottom.mas_equalTo(_contentView).offset(-ZOOM_SCALE(10));
        }];
        UIButton *cancle = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"下次再说"];
        [cancle setTitleColor:[UIColor colorWithHexString:@"#8E8E93"] forState:UIControlStateNormal];
        cancle.titleLabel.font = RegularFONT(15);
        [_contentView addSubview:cancle];
        [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView).offset(ZOOM_SCALE(5));
            make.right.mas_equalTo(line2.mas_right);
            make.top.mas_equalTo(line.mas_bottom);
            make.bottom.mas_equalTo(line2.mas_bottom);
        }];
        [cancle addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
        UIButton *updateBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"立即更新"];
        updateBtn.titleLabel.font = RegularFONT(15);
        [_contentView addSubview:updateBtn];
        [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line2.mas_right);
            make.right.mas_equalTo(_contentView).offset(-ZOOM_SCALE(5));
            make.top.mas_equalTo(line.mas_bottom);
            make.bottom.mas_equalTo(line2.mas_bottom);
        }];
        [updateBtn addTarget:self action:@selector(updateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
 
    
}
- (void)cancleClick{
    if (self.nextClick) {
        self.nextClick();
    }
    [self disMissView];
}
- (void)disMissView{
    [self removeFromSuperview];
    [_contentView removeFromSuperview];
}
- (void)updateBtnClick{
    if (self.itemClick) {
        self.itemClick();
    }
    [self disMissView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
