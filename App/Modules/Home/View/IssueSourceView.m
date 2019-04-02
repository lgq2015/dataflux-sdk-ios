//
//  IssueSourceView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceView.h"
#import "IssueTf.h"

@interface IssueSourceView ()
@property (nonatomic,weak) UIViewController  *viewController; //-> 一定是weak 避免循环引用
@end
@implementation IssueSourceView
- (instancetype)initWithShowInControllerView:(UIViewController *)controller withIssueConfig:(IssueSourceConfige*)config{
    if (self) {
        self= [super init];
        self.viewController = controller;
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    
}
//- (UIView *)itemViewWithIssueTF:(IssueTf *)issueTF tag:(NSInteger)tag{
//    UIView *item = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(65))];
//    [self addSubview:item];
//    item.backgroundColor = PWWhiteColor;
//    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake (Interval(16), ZOOM_SCALE(8), 200, ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTitleColor text:issueTF.tfTitle];
//    [item addSubview:titleLab];
//    UITextField *tf = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(34), kWidth-Interval(32), ZOOM_SCALE(22))];
//    tf.tag = tag;
//    tf.secureTextEntry = issueTF.secureTextEntry;
//    if (issueTF.secureTextEntry) {
//        tf.frame = CGRectMake(Interval(16), ZOOM_SCALE(34), kWidth-Interval(64), ZOOM_SCALE(22));
//        UIButton  *showWordsBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(337), ZOOM_SCALE(33), ZOOM_SCALE(24), ZOOM_SCALE(24))];
//        [showWordsBtn setImage:[UIImage imageNamed:@"icon_disvisible"] forState:UIControlStateNormal];
//        [showWordsBtn setImage:[UIImage imageNamed:@"icon_visible"] forState:UIControlStateSelected];
//        [showWordsBtn addTarget:self action:@selector(pwdTextSwitch:) forControlEvents:UIControlEventTouchUpInside];
//        showWordsBtn.tag = tag+100;
//        [item addSubview:showWordsBtn];
//    //    self.showWordsBtn = showWordsBtn;
//    }
//    tf.delegate = self.viewController;
//    tf.placeholder = issueTF.placeHolder;
//    if (!self.isAdd) {
//        tf.text = issueTF.text;
//        tf.enabled = NO;
//    }
//    [item addSubview:tf];
//    [self.TFArray addObject:tf];
//    return item;
//}
- (void)pwdTextSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    UITextField *tf = [self viewWithTag:sender.tag-100];
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = tf.text;
        tf.text = @""; // 这句代码可以防止切换的时候光标偏移
        tf.secureTextEntry = NO;
        tf.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = tf.text;
        tf.text = @"";
        tf.secureTextEntry = YES;
        tf.text = tempPwdStr;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
