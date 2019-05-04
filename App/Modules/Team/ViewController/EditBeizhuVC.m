//
//  EditBeizhuVC.m
//  App
//
//  Created by tao on 2019/4/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "EditBeizhuVC.h"
#import "UITextField+HLLHelper.h"

@interface EditBeizhuVC ()
@property (nonatomic, strong)UIButton *leftNavBtn;
@property (nonatomic, strong)UIButton *rightNavBtn;
@property (weak, nonatomic) IBOutlet UITextField *beizhuTF;

@end

@implementation EditBeizhuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beizhuTF.text = self.noteName;
    self.title = @"设置备注";
    [self.beizhuTF becomeFirstResponder];
    self.beizhuTF.hll_limitTextLength = 20;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
}
#pragma mark =====内部事件====
- (void)leftNavBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightNavBtnClick{
    [self preservationBeizhu];
}
#pragma mark ====请求======
//保存备注
- (void)preservationBeizhu{
    [SVProgressHUD show];
    NSString *inTeamNote = self.beizhuTF.text;
    NSDictionary *params = @{@"accounts":@[@{@"id":self.memeberID,@"inTeamNote":inTeamNote}]};
    [PWNetworking requsetHasTokenWithUrl:PW_TeamAccountModify withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            BOOL content = [response[@"content"] boolValue];
            if (content){
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                if (_editTeamMemberNote){
                    _editTeamMemberNote(inTeamNote);
                }
                KPostNotification(KNotificationEditTeamNote, nil);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark --lazy--
- (UIButton *)leftNavBtn{
    if (!_leftNavBtn){
        _leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftNavBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftNavBtn setTitleColor:[UIColor colorWithHexString:@"#2A7AF7"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(leftNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _leftNavBtn.titleLabel.font = RegularFONT(16);
    }
    return _leftNavBtn;
}
- (UIButton *)rightNavBtn{
    if (!_rightNavBtn){
        _rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightNavBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightNavBtn setTitleColor:[UIColor colorWithHexString:@"#2A7AF7"] forState:UIControlStateNormal];
        _rightNavBtn.titleLabel.font = RegularFONT(16);
        [_rightNavBtn addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}
@end
