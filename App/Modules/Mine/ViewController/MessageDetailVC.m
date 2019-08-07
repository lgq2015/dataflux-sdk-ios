//
//  MessageDetailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MessageDetailVC.h"
#import "MineMessageModel.h"
#import "NSString+Regex.h"
#import "PWBaseWebVC.h"
#import "CloudCareVC.h"
@interface MessageDetailVC ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *sourceLab;
@property (nonatomic, strong) YYLabel *contentLab;
@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.MessageDetails", @"");
    [self createUI];
    [self setMessageRead];
}
- (void)createUI{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(Interval(12));
    }];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:self.model.title];
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.top.mas_equalTo(self.contentView).offset(Interval(14));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
    }];
    [self.sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.width.offset(ZOOM_SCALE(54));
        make.height.offset(ZOOM_SCALE(24));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(Interval(10));
    }];
   
    [self.sourceLab setTextColor:[UIColor colorWithHexString:_model.colorStr]];
    self.sourceLab.text = _model.typeStr;
    self.sourceLab.layer.borderColor = [UIColor colorWithHexString:_model.colorStr].CGColor;
    
    UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:[UIColor colorWithHexString:@"#C7C7CC"] text:@""];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.sourceLab);
        make.left.mas_equalTo(self.sourceLab.mas_right).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(17));
    }];
     timeLab.text = [[NSString getLocalDateFormateUTCDate:_model.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ssZ"] accurateTimeStr];
    [self.contentView addSubview:self.contentLab];
    //去掉A标签后的文本
    NSString *zt_content = [self.model.content zt_convertLinkTextString];
    //去掉A标签后的文本高度
    CGFloat contentLabH = [zt_content zt_getHeight:self.contentLab.font width:kWidth - 32];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.sourceLab.mas_bottom).offset(Interval(11));
        make.height.mas_equalTo(contentLabH + 1);
        make.bottom.mas_equalTo(self.contentView).offset(-Interval(19));
    }];
    
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = PWWhiteColor;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}
- (void)loadMessageDetail{
//    [SVProgressHUD show];
//    [PWNetworking requsetHasTokenWithUrl:PW_systemMessageDetail(self.model.messageID) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
//        [SVProgressHUD dismiss];
//
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
}
- (void)setMessageRead{
    NSDictionary *param = @{@"data":@{@"system_message_ids":self.model.messageID}};
    [PWNetworking requsetHasTokenWithUrl:PW_systemMessageSetRead withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            if (self.refreshTable) {
                self.refreshTable();
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}
-(UILabel *)sourceLab{
    if (!_sourceLab) {
        _sourceLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#2EB5F3"] text:@""];
        _sourceLab.layer.cornerRadius = 4.;//边框圆角大小
        _sourceLab.layer.masksToBounds = YES;
        _sourceLab.layer.borderWidth = 1;//边框宽度
        _sourceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_sourceLab];
    }
    return _sourceLab;
}
- (YYLabel *)contentLab{
    if (!_contentLab){
        _contentLab = [PWCommonCtrl zy_lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:self.model.content];
        WeakSelf
        _contentLab.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect){
            text = [text attributedSubstringFromRange:range];
            NSDictionary *dic = text.attributes;
            YYTextHighlight *user = [dic valueForKey:@"YYTextHighlight"];
            NSString *linkUrl = [user.userInfo valueForKey:@"linkUrl"];
            if ([text.string containsString:NSLocalizedString(@"local.BuyNow", @"")]){
                CloudCareVC  *makeFriendVC = [[CloudCareVC alloc]initWithTitle:NSLocalizedString(@"local.service_package", @"") andURLString:PW_cloudcare];
                makeFriendVC.isHideProgress = YES;
                [weakSelf.navigationController pushViewController:makeFriendVC animated:YES];

            }else{
                PWBaseWebVC*webView= [[PWBaseWebVC alloc] initWithTitle:text.string andURLString:linkUrl];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }
        };
    }
    return _contentLab;
}
- (void)dealloc{
    DLog(@"%s",__func__);
}

@end
