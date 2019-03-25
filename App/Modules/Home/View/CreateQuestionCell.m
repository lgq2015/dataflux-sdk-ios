//
//  CreateSourceCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CreateQuestionCell.h"
#import "CreateQuestionModel.h"
@interface CreateQuestionCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *sizeLab;
@property (nonatomic, strong) UIButton *reloadBtn;
@property (nonatomic, strong) UILabel *uploadStateLab;
@end
@implementation CreateQuestionCell
-(void)setTitleWithProgress:(float)progress{
    self.titleLab.text = [NSString stringWithFormat:@"正在上传… (%d%%)",(int)(progress*100)];
    self.titleLab.hidden = NO;
}
-(void)setModel:(CreateQuestionModel *)model{
    _model = model;
    switch (_model.type) {
        case UploadTypeSuccess:
          self.uploadStateLab.text = @"上传成功";
          self.uploadStateLab.hidden = NO;
          self.uploadStateLab.textColor = [UIColor colorWithHexString:@"#9B9EA0"];
          self.reloadBtn.hidden = YES;
          self.sizeLab.text = _model.size;
            break;
        case UploadTypeError:
          self.uploadStateLab.text = @"上传失败！";
          self.uploadStateLab.hidden = NO;
          self.reloadBtn.hidden = NO;
          self.uploadStateLab.textColor = [UIColor colorWithHexString:@"#D50000"];
            break;
        case UploadTypeNotStarted:
          self.uploadStateLab.hidden = YES;
          self.reloadBtn.hidden = YES;
            break;
    }
    self.iconView.image = _model.image;
}
-(void)uploadError{
    self.reloadBtn.hidden = NO;
    self.titleLab.text = self.model.name;
    self.sizeLab.text = self.model.size;
    self.uploadStateLab.text = @"上传失败！";
    self.uploadStateLab.hidden = NO;
    self.reloadBtn.hidden = NO;
    self.uploadStateLab.textColor = [UIColor colorWithHexString:@"#D50000"];
}
-(void)completeUpload{
    self.titleLab.text = self.model.name;
    self.sizeLab.text = self.model.size;
    self.uploadStateLab.text = @"上传成功";
    self.uploadStateLab.hidden = NO;
    self.uploadStateLab.textColor = [UIColor colorWithHexString:@"#9B9EA0"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UILabel *)uploadStateLab{
    if (!_uploadStateLab) {
        _uploadStateLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:[UIColor colorWithHexString:@"#9B9EA0"] text:@""];
        [self.contentView addSubview:_uploadStateLab];
    }
    return _uploadStateLab;
}
- (UIButton *)reloadBtn{
    if (!_reloadBtn) {
        _reloadBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"重新上传"];
        _reloadBtn.titleLabel.font = MediumFONT(14);
        [_reloadBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(reloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_reloadBtn];
    }
    return _reloadBtn;
}
- (void)reloadBtnClick{
    self.titleLab.text = @"正在上传…";
    self.uploadStateLab.text = @"";
    self.reloadBtn.hidden = YES;
    if (self.reUpload) {
        self.reUpload(self.index);
    }
    
}
-(void)layoutSubviews{
   
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZOOM_SCALE(5));
        make.left.mas_equalTo(self.iconView.mas_right).offset(Interval(13));
        make.right.mas_equalTo(self.contentView).offset(-Interval(53));
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(7));
        make.left.mas_equalTo(self.iconView.mas_right).offset(Interval(13));
        make.height.offset(ZOOM_SCALE(17));
    }];
    
    UIButton *cancelUpBtn = [[UIButton alloc]init];
    [cancelUpBtn setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
    cancelUpBtn.tag = 200;
    [[cancelUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.removeFile) {
            self.removeFile(self.index);
        }
    }];
    [[self.contentView viewWithTag:200] removeFromSuperview];
    [self.contentView addSubview:cancelUpBtn];
    [cancelUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-Interval(20));
        make.width.height.offset(ZOOM_SCALE(26));
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.uploadStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sizeLab);
        make.top.mas_equalTo(self.sizeLab.mas_bottom).offset(Interval(6));
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uploadStateLab.mas_right).offset(Interval(20));
        make.height.offset(ZOOM_SCALE(20));
        make.centerY.mas_equalTo(self.uploadStateLab);
    }];
    
}
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(15), ZOOM_SCALE(5), ZOOM_SCALE(60), ZOOM_SCALE(60))];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTextBlackColor text:@""];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)sizeLab{
    if (!_sizeLab) {
        _sizeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWSubTitleColor text:@""];
        [self.contentView addSubview:_sizeLab];
    }
    return _sizeLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
