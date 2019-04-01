//
//  MessageDetailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MessageDetailVC.h"
#import "MineMessageModel.h"
@interface MessageDetailVC ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *sourceLab;

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    [self createUI];
    [self setMessageRead];
}
- (void)createUI{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(Interval(12));
    }];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTextBlackColor text:self.model.title];
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
    UIColor *color;
    NSString *type;
    if ([self.model.messageType isEqualToString:@"team"]) {
        color = [UIColor colorWithHexString:@"#2EB5F3"];
        type = @"团队";
    }else if([self.model.messageType isEqualToString:@"account"]){
        color = [UIColor colorWithHexString:@"#936AF2"];
        type = @"账号";
    }else if([self.model.messageType isEqualToString:@"issue_source"]){
        color = [UIColor colorWithHexString:@"#3B85F8"];
        type = @"情报源";
    }else if([_model.messageType isEqualToString:@"service_package"]){
        color = RGBACOLOR(85, 220, 117, 1);
        type = @"服务";
    }else if([_model.messageType isEqualToString:@"service"]){
        color = RGBACOLOR(85, 220, 117, 1);
        type = @"服务";
    }else{
        color = RGBACOLOR(85, 220, 117, 1);
        type = @"服务";
    }
    [self.sourceLab setTextColor:color];
    self.sourceLab.text = type;
    self.sourceLab.layer.borderColor = color.CGColor;
    
    UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:[UIColor colorWithHexString:@"#C7C7CC"] text:@""];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.sourceLab);
        make.left.mas_equalTo(self.sourceLab.mas_right).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(17));
    }];
     timeLab.text = [[NSString getLocalDateFormateUTCDate:_model.createTime formatter:@"yyyy-MM-dd'T'HH:mm:ssZ"] accurateTimeStr];
    UILabel *contentLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTitleColor text:self.model.content];
    NSString *regex_http = @"<a href=(?:.*?)>(.*?)<\\/a>";
     NSString *labelText = [contentLab.text copy];
//    NSArray *results = [regular matchesInString:regex_http options:0 range:NSMakeRange(0, checkString.length)];
// matchesInString:regex_http options:0 range:NSMakeRange(0, checkString.length)];

     labelText = [labelText stringByReplacingOccurrencesOfString:@"<a href=(.*?)>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange (0, labelText.length)];
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[self.model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    contentLab.attributedText = attrStr;
//    //如果想要改变文字的字体,请在设置attributedText之后设置
//    contentLab.font = MediumFONT(14);
//    contentLab.textAlignment = NSTextAlignmentLeft;
//    contentLab.numberOfLines = 0;
//    contentLab.textColor = PWTitleColor;
    [self.contentView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.sourceLab.mas_bottom).offset(Interval(11));
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
        _sourceLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:[UIColor colorWithHexString:@"#2EB5F3"] text:@""];
        _sourceLab.layer.cornerRadius = 4.;//边框圆角大小
        _sourceLab.layer.masksToBounds = YES;
        _sourceLab.layer.borderWidth = 1;//边框宽度
        _sourceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_sourceLab];
    }
    return _sourceLab;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
