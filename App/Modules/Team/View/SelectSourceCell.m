//
//  SelectSourceCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectSourceCell.h"
@interface SelectSourceCell()
@property (nonatomic, strong) UIImageView *sourceIcon;
@end
@implementation SelectSourceCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            [self createCellUI];
     }
    return self;
}
- (void)createCellUI{
   
    self.sourceIcon = [[UIImageView alloc]init];
    [self addSubview:self.sourceIcon];
    [self.sourceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(16);
        make.centerY.mas_equalTo(self);
        make.width.offset(ZOOM_SCALE(27));
        make.height.offset(ZOOM_SCALE(19));
    }];
}
-(void)setSource:(NSDictionary *)source{
    _source = source;
       NSString *icon = @"",*sourceName;
   
       NSString *type = [source stringValueForKey:@"provider" default:@""];
        sourceName = [source stringValueForKey:@"name" default:@""];
        if ([type isEqualToString:@"carrier.corsairmaster"]){
            icon = @"icon_foresight_small";
        }else if([type isEqualToString:@"aliyun"]) {
            icon = @"icon_alis";
        }else if([type isEqualToString:@"qcloud"]){
            icon = @"icon_tencent_small";
        }else if([type isEqualToString:@"aws"]){
            icon = @"icon_aws_small";
        }else if([type isEqualToString:@"ucloud"]){
            icon = @"icon_tencent_small";
        }else if ([type isEqualToString:@"domain"]){
            icon = @"icon_domainname_small";
        }else if([type isEqualToString:@"carrier.corsair"]){
            icon =@"icon_mainframe_small";
        }else if([type isEqualToString:@"carrier.alert"]){
            icon = @"message_docks";
        }else if ([type isEqualToString:@"aliyun.finance"]){
            icon = @"icon_alis";
        }else if ([type isEqualToString:@"aliyun.cainiao"]){
            icon = @"cainiao_s";
        }
    
    [[self viewWithTag:22] removeFromSuperview];
    UILabel *sourceNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:sourceName];
    sourceNameLab.tag = 22;
    [self addSubview:sourceNameLab];
    if (icon.length>0) {
        self.sourceIcon.image = [UIImage imageNamed:icon];
        self.sourceIcon.hidden = NO;
       
        [sourceNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sourceIcon.mas_right).offset(12);
            make.centerY.mas_equalTo(self);
            make.height.offset(ZOOM_SCALE(22));
            make.right.mas_equalTo(self).offset(-16);
        }];
    }else{
        self.sourceIcon.hidden = YES;
        [sourceNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(16);
            make.centerY.mas_equalTo(self);
            make.height.offset(ZOOM_SCALE(22));
            make.right.mas_equalTo(self).offset(-16);
        }];
    }
    [self layoutIfNeeded];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
