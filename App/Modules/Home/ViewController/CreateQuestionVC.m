//
//  CreateQuestionVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CreateQuestionVC.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "IssueExtraCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define NavRightBtnTag  100  // 右侧图片

@interface CreateQuestionVC ()
@property (nonatomic,strong) PWPhotoOrAlbumImagePicker *myPicker;
@property (nonatomic, strong) UITextField *titleTf;
@property (nonatomic, strong) UITextView *describeTextView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) NSMutableArray *attachmentArray;

// type = 1 严重 type = 2  警告
@property (nonatomic, assign) NSString *level;
@end

@implementation CreateQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建问题";
    self.isShowLiftBack = NO;
    [self createUI];
}
- (void)createUI{
    self.attachmentArray = [NSMutableArray new];
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(navigationBtnClick:) tags:@[@5]];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
    self.navigationItem.rightBarButtonItem = item;
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, kHeight);
    [self.mainScrollView setUserInteractionEnabled:YES];

    self.titleView.backgroundColor = PWWhiteColor;
    
    UIView *levelView = [[UIView alloc]init];
    levelView.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:levelView];
    
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(Interval(12));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(56));
    }];
    UILabel *leve = [[UILabel alloc]init];
    leve.text = @"严重程度";
    leve.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    leve.textColor = [UIColor colorWithRed:89/255.0 green:88/255.0 blue:96/255.0 alpha:1/1.0];
    [levelView addSubview:leve];
    [leve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(levelView).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(22));
        make.width.offset(ZOOM_SCALE(100));
        make.centerY.mas_equalTo(levelView.centerY);
    }];
    UIButton *waringBtn = [self levalBtnWithColor:[UIColor colorWithHexString:@"FFC163"]];
    [waringBtn setTitle:@"警告" forState:UIControlStateNormal];
    waringBtn.tag = 10;
    [levelView addSubview:waringBtn];
    UIButton *seriousBtn = [self levalBtnWithColor:[UIColor colorWithHexString:@"FC7676"]];
    seriousBtn.tag = 11;
    [seriousBtn setTitle:@"严重" forState:UIControlStateNormal];
    [levelView addSubview:seriousBtn];
    [waringBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(levelView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(24));
        make.width.offset(ZOOM_SCALE(50));
        make.centerY.mas_equalTo(levelView.centerY);
    }];
    [seriousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(waringBtn.mas_left).offset(-Interval(20));
        make.height.offset(ZOOM_SCALE(24));
        make.width.offset(ZOOM_SCALE(50));
        make.centerY.mas_equalTo(levelView.centerY);
    }];
    [[waringBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.level = @"warning";
        waringBtn.selected = YES;
        seriousBtn.selected = NO;
    }];
    [[seriousBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.level = @"danger";
        seriousBtn.selected = YES;
        waringBtn.selected = NO;
    }];
    UIView *describeView = [[UIView alloc]init];
    describeView.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:describeView];
    [describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelView.mas_bottom).offset(Interval(12));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(180));
    }];
    UILabel *desTitleLab =[[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(8), 100, ZOOM_SCALE(20))];
    desTitleLab.text = @"描述";
    desTitleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    desTitleLab.textColor = PWTitleColor;
    [describeView addSubview:desTitleLab];
    if (!_describeTextView) {
        self.describeTextView = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:@"请输入" font:MediumFONT(16)];
        [describeView addSubview:self.describeTextView];
        [self.describeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(desTitleLab.mas_bottom).offset(ZOOM_SCALE(6));
            make.left.mas_equalTo(describeView).offset(Interval(12));
            make.right.mas_equalTo(describeView).offset(-Interval(16));
            make.bottom.mas_equalTo(describeView).offset(-Interval(19));
        }];
    }
    
    UIButton *accessoryBtn = [[UIButton alloc]init];
    [accessoryBtn addTarget:self action:@selector(accessoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [accessoryBtn setImage:[UIImage imageNamed:@"paper-clip"] forState:UIControlStateNormal];
    [describeView addSubview:accessoryBtn];
    [accessoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(describeView).offset(-Interval(21));
        make.height.with.offset(ZOOM_SCALE(20));
        make.bottom.mas_equalTo(describeView).offset(-Interval(10));
    }];
    UILabel *count = [[UILabel alloc]init];
    count.text = @"0/250";
    count.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    count.textColor = [UIColor colorWithHexString:@"8E8E93"];
    count.textAlignment = NSTextAlignmentRight;
    [describeView addSubview:count];
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(accessoryBtn.mas_left).offset(-Interval(15));
        make.height.offset(ZOOM_SCALE(18));
        make.centerY.mas_equalTo(accessoryBtn);
    }];
   [[self.describeTextView rac_textSignal] subscribeNext:^(NSString *text) {
        if (text.length>1000) {
            text = [text substringToIndex:250];
            self.describeTextView.text = text;
        }
        count.text = [NSString stringWithFormat:@"%lu/250",(unsigned long)text.length];
    }];
    RACSignal *describeTextView = [self.describeTextView rac_textSignal];
    RACSignal *titleSignal = [self.titleTf rac_textSignal];
    RACSignal *state = RACObserve(seriousBtn, selected);
    RACSignal *state2 = RACObserve(waringBtn, selected);

    RACSignal * navBtnSignal = [RACSignal combineLatest:@[describeTextView,titleSignal,state,state2] reduce:^id(NSString * title,NSString * content){
        return @(title.length>0 && content.length>0 && self.level.length>0);
    }];
    RAC(self.navRightBtn,enabled) = navBtnSignal;
    
}
-(UIButton *)levalBtnWithColor:(UIColor *)color{
    UIButton *button = [[UIButton alloc]init];
    [button setTitleColor:PWWhiteColor forState:UIControlStateSelected];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    button.layer.cornerRadius = 4.;//边框圆角大小
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;//边框宽度
    button.layer.borderColor = color.CGColor;
    [button setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateSelected];
    return button;
}
-(UIView *)titleView{
    if (!_titleView) {
       _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, ZOOM_SCALE(65))];
        _titleView.backgroundColor = PWWhiteColor;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(8), ZOOM_SCALE(40), ZOOM_SCALE(20))];
        lab.text = @"标题";
        lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        lab.textColor = PWTitleColor;
        lab.textAlignment = NSTextAlignmentLeft;
        [_titleView addSubview:lab];
        self.titleTf = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(34), ZOOM_SCALE(350), ZOOM_SCALE(22))];
        self.titleTf.placeholder = @"请输入";
        [_titleView addSubview:self.titleTf];
        [self.mainScrollView addSubview:_titleView];
    }
    return _titleView;
}
-(UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _navRightBtn.frame = CGRectMake(0, 0, 40, 30);
        [_navRightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(navigationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _navRightBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [_navRightBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_navRightBtn setTitleColor:PWGrayColor forState:UIControlStateDisabled];
        _navRightBtn.tag = NavRightBtnTag;
        _navRightBtn.enabled = NO;
        [_navRightBtn sizeToFit];
    }
    return _navRightBtn;
}
- (void)accessoryBtnClick{
    self.myPicker = [[PWPhotoOrAlbumImagePicker alloc]init];
    [self.myPicker getPhotoAlbumTakeAPhotoAndNameWithController:self photoBlock:^(UIImage *image, NSString *name) {
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [self upLoadImageWithData:data name:name];
    }];
}
- (void)navigationBtnClick:(UIButton *)button{
    if (button.tag == 5) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag == NavRightBtnTag){
        NSDictionary *params = @{@"data":@{@"level":self.level,@"type":self.type,@"title":self.titleTf.text,@"content":self.describeTextView.text}};
        [PWNetworking requsetHasTokenWithUrl:PW_issueAdd withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
            if([response[@"errorCode"] isEqualToString:@""]){
                [SVProgressHUD showSuccessWithStatus:@"创建问题成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
}
-(void)upLoadImageWithData:(NSData *)data name:(NSString *)name{
    double convertedValue = [data length] * 1.0;
    if (convertedValue>1024*1024*5) {
        [iToast alertWithTitleCenter:@"文件过大"];
    }else{
//    NSString *time = [NSDate getNowTimeTimestamp];
//    NSDictionary *param = @{@"type":@"attachment",@"subType":@"issueDetailExtra",@"batchId":[NSString stringWithFormat:@"%@%@",time,getPWUserID]};
//    [PWNetworking uploadFileWithUrl:PW_AdduploaAttachment params:param fileData:data type:@"jpg" name:@"files" mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
//        DLog(@"bytesWritten = %lld totalBytes = %lld",bytesWritten,totalBytes);
//    } successBlock:^(id response) {
//        DLog(@"response = %@",response);
//    } failBlock:^(NSError *error) {
//        DLog(@"error = %@",error);
//
//    }];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.titleTf resignFirstResponder];
    [self.describeTextView resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.attachmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueExtraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueExtraCell"];
//    IssueExtraModel *model = [[IssueExtraModel alloc]initWithDictionary:self.attachmentArray[indexPath.row]];
//    cell.model = model;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (NSString *)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double convertedValue = [data length] * 1.0;
    int multiplyFactor = 0;

    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"M",nil];
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }

    return [NSString stringWithFormat:@"%0.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
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
