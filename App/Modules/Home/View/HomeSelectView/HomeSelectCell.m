//
//  HomeSelectCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HomeSelectCell.h"
#import "IssueListManger.h"
#import "SelectIssueTypeView.h"
@interface HomeSelectCell()
@property (nonatomic, strong) UIImageView *iconImgV;
@property (nonatomic, copy) NSString *selectedIcon;
@end
@implementation HomeSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setType:(int)type{
    _type = type;
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    switch (self.type) {
      case SelectTypeView:
            [self createView:_index];
            break;
      case SelectTypeIssue:
            [self createIssue:_index];
            break;
    }
    
}
- (void)createIssue:(NSInteger)index{
   IssueType type= index+1;
    NSString *title,*icon;
    switch (type) {
        case IssueTypeAll:
            title = @"全部";
            icon = @"all_g";
            self.selectedIcon = @"all_b";
            break;
        case IssueTypeAlarm:
            title = @"监控";
            icon = @"alarm_g";
            self.selectedIcon  = @"alarm_b";
            break;
        case IssueTypeSecurity:
            title = @"安全";
            icon = @"security_g";
            self.selectedIcon  = @"security_b";
            break;
        case IssueTypeExpense:
            title = @"费用";
            icon = @"expense_g";
            self.selectedIcon = @"expense_b";
            break;
        case IssueTypeOptimization:
            title = @"优化";
            icon = @"optimization_g";
            self.selectedIcon  = @"optimization_b";
            break;
        case IssueTypeMisc:
            title = @"提醒";
            icon = @"misc_g";
            self.selectedIcon = @"misc_b";
            break;
    }
    self.iconImgV.image = [UIImage imageNamed:icon];
  
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZOOM_SCALE(16));
        make.width.height.offset(ZOOM_SCALE(20));
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.titleLab.text = title;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgV.mas_right).offset(8);
        make.centerY.mas_equalTo(self.iconImgV);
        make.height.offset(ZOOM_SCALE(22));
    }];
   
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@""];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconImgV];
    }
    return _iconImgV;
}
- (void)createView:(NSInteger)index{
    IssueViewType type = index+1;
    switch (type) {
        case IssueViewTypeAll:
            self.titleLab.text = @"全部视图";
            break;
        case IssueViewTypeNormal:
            self.titleLab.text = @"标准视图";
            break;
        case IssueViewTypeIgnore:
            self.titleLab.text = @"忽略视图";
            break;
    }
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.offset(ZOOM_SCALE(22));
        make.centerY.mas_equalTo(self.contentView);
    }];
}
-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.titleLab.textColor = [UIColor colorWithHexString:@"#3B85F8"];
        if (_iconImgV) {
            self.iconImgV.image = [UIImage imageNamed:self.selectedIcon];
        }
    }
    
}

@end
