//
//  AssignView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AssignView.h"
#import "ChooseAssignVC.h"

@interface AssignView()
@property (nonatomic, strong) IssueListViewModel *model;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *handlerLab;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, copy) NSString *assignID;
@end
@implementation AssignView
-(instancetype)initWithFrame:(CGRect)frame IssueModel:(IssueListViewModel *)model{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(assignClick)];
    [self addGestureRecognizer:tap];
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.iconImg.frame)+Interval(10), 0, kWidth-ZOOM_SCALE(100), ZOOM_SCALE(22));
    self.nameLab.centerY = self.iconImg.centerY;
    self.arrow.hidden = NO;
    if (_model.statusChangeAccountInfo) {
        NSString *name = [_model.statusChangeAccountInfo stringValueForKey:@"name" default:@""];
        
     self.nameLab.textColor = PWTextBlackColor;
      self.nameLab.text =[NSString stringWithFormat:@"被%@修复",name];
    
       [self recoveredUI];
    }else{
        if(_model.assignedToAccountInfo){
            NSString *name = [_model.assignedToAccountInfo stringValueForKey:@"name" default:@""];
            self.nameLab.text = name;
            self.nameLab.textColor = PWTextBlackColor;
            NSString *pwAvatar = @"";
            NSDictionary *tags = PWSafeDictionaryVal(_model.assignedToAccountInfo, @"tags");
            if (tags) {
                pwAvatar = [tags stringValueForKey:@"pwAvatar" default:@""];
            }
            self.assignID = [_model.assignedToAccountInfo stringValueForKey:@"id" default:@""];
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:pwAvatar] placeholderImage:[UIImage imageNamed:@"icon_handler"]];
            [self assignUI];
        }else{
            
        [self noAssignUI];
        }
    }
}
- (void)assignUI{
    self.nameLab.textColor = PWTextBlackColor;
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-16);
        make.height.offset(ZOOM_SCALE(16));
        make.width.offset(ZOOM_SCALE(10));
        make.centerY.mas_equalTo(self.iconImg);
    }];
    self.handlerLab.hidden = NO;
    [self.handlerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow.mas_left).offset(-8);
        make.centerY.mas_equalTo(self);
        make.height.offset(ZOOM_SCALE(20));
    }];
}
- (void)noAssignUI{
    self.iconImg.image = [UIImage imageNamed:@"icon_handler"];
    self.nameLab.text = @"设置处理人";
    self.nameLab.textColor = [UIColor colorWithHexString:@"#C7C7CC"];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-16);
        make.height.offset(ZOOM_SCALE(16));
        make.width.offset(ZOOM_SCALE(10));
        make.centerY.mas_equalTo(self.iconImg);
    }];
    self.handlerLab.hidden = YES;
}
- (void)recoveredUI{
    UIView *dot = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), 0, 4, 4)];
    dot.centerY = self.nameLab.centerY;
    dot.layer.cornerRadius = 2;
    dot.backgroundColor = [UIColor colorWithHexString:@"#26D5A8"];
    [self addSubview:dot];
    self.iconImg.hidden = YES;
    [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(28));
        make.centerY.mas_equalTo(dot);
        make.height.offset(ZOOM_SCALE(22));
    }];
    self.nameLab.textColor = PWTextBlackColor;
    self.userInteractionEnabled = NO;
    self.arrow.hidden = YES;
    self.handlerLab.hidden = YES;
  
}
-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(16), (self.frame.size.height-ZOOM_SCALE(24))/2.0, ZOOM_SCALE(24), ZOOM_SCALE(24))];
        [self addSubview:_iconImg];
    }
    return _iconImg;
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.font = RegularFONT(16);
        [self addSubview:_nameLab];
    }
    return _nameLab;
}
-(UILabel *)handlerLab{
    if (!_handlerLab) {
        _handlerLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWSubTitleColor text:@"处理人"];
        _handlerLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_handlerLab];
    }
    return _handlerLab;
}
-(UIImageView *)arrow{
    if (!_arrow) {
        _arrow =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextgray"]];
        [self addSubview:_arrow];
    }
    return _arrow;
}
-(void)assignClick{
    ChooseAssignVC *chooseVC = [[ChooseAssignVC alloc]init];
    chooseVC.assignID = self.assignID;
    chooseVC.model = self.model;
    WeakSelf
    chooseVC.MemberInfo = ^(MemberInfoModel *model){
        [weakSelf dealWithMemberInfoModel:model];
        if (weakSelf.AssignClick) {
            weakSelf.AssignClick();
        }
    };
    [self.viewController.navigationController pushViewController:chooseVC animated:YES];
}
- (void)dealWithMemberInfoModel:(MemberInfoModel *)member{
    if (member.noAssign) {
        self.assignID = nil;
        [self noAssignUI];
    }else{
        self.assignID = member.memberID;
        self.nameLab.text = member.name;
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[member.tags stringValueForKey:@"pwAvatar" default:@""]] placeholderImage:[UIImage imageNamed:@"icon_handler"]];
        [self assignUI];
    }
}
-(void)assignWithMember:(nullable MemberInfoModel *)member{
    if (member) {
        self.nameLab.text = member.name;
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[member.tags stringValueForKey:@"pwAvatar" default:@""]] placeholderImage:[UIImage imageNamed:@"icon_handler"]];
        self.nameLab.text = member.name;
        [self assignUI];
    }else{
       
        [self noAssignUI];
    }
}
-(void)repair{
    
   self.nameLab.text =[NSString stringWithFormat:@"被%@修复", userManager.curUserInfo.name];
    [self recoveredUI];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
