//
//  IssueIndexHeaderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueIndexHeaderView.h"
#import "HomeNoticeScrollView.h"
@interface IssueIndexHeaderView ()
@property (nonatomic, assign) PWIssueBoardStyle style;

@end
@implementation IssueIndexHeaderView
-(instancetype)initWithStyle:(PWIssueBoardStyle)style{
    if (self = [super init]) {
        self.style = style;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    [self addSubview:self.issueBoard];
    [self addSubview:self.notice];
    [self.issueBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
    }];
    [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.issueBoard.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self);
        make.height.offset(ZOOM_SCALE(60));
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.notice.mas_bottom).offset(2);
    }];
}
- (void)updateIssueBoardStyle:(PWIssueBoardStyle)style itemData:(NSDictionary *)paramsDict{
    [self.issueBoard updataInfoBoardStyle:style itemData:paramsDict];
}
- (HomeNoticeScrollView *)notice {
    if (!_notice) {
        _notice = [[HomeNoticeScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(60))];
        _notice.backgroundColor = PWWhiteColor;
    }
    return _notice;
}
- (IssueBoard *)issueBoard {
    if (!_issueBoard) {
        _issueBoard = [[IssueBoard alloc] initWithStyle:self.style]; // type从用户信息里提前获取
    }
    return _issueBoard;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
