//
//  AddIssueVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddIssueVC.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "IssueAttachmentCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AddIssueCell.h"
#import "CreateQuestionModel.h"
#import "UIResponder+FirstResponder.h"
#import "PWSocketManager.h"
#import "IssueListManger.h"
#import "IssueListViewModel.h"
#import "IssueDetailsVC.h"
#import "IssueChatDataManager.h"
#import "ZhugeIOIssueHelper.h"
#import "NSString+ErrorCode.h"

#define NavRightBtnTag  100  // 右侧图片

@interface AddIssueVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) PWPhotoOrAlbumImagePicker *myPicker;
@property (nonatomic, strong) UITextField *titleTf;
@property (nonatomic, strong) UITextView *describeTextView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) NSMutableArray<CreateQuestionModel *> *attachmentArray;
@property (nonatomic, copy) NSString *batchId;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, copy) NSString *upBatchId;
// type = 1 严重 type = 2  警告 3  一般
@property (nonatomic, assign) NSString *level;
@end

@implementation AddIssueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.issueCreate", @"");
    self.isShowLiftBack = NO;
    [self createUI];
}
- (void)createUI{
    self.attachmentArray = [NSMutableArray new];
    [self addNavigationItemWithTitles:@[NSLocalizedString(@"local.cancel", @"")] isLeft:YES target:self action:@selector(navigationBtnClick:) tags:@[@5]];
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
    leve.text = NSLocalizedString(@"local.level", @"");
    leve.font = RegularFONT(16);
    leve.textColor = [UIColor colorWithRed:89/255.0 green:88/255.0 blue:96/255.0 alpha:1/1.0];
    [levelView addSubview:leve];
    [leve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(levelView).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(22));
        make.width.offset(ZOOM_SCALE(100));
        make.centerY.mas_equalTo(levelView.centerY);
    }];
    UIButton *waringBtn = [self levalBtnWithColor:[UIColor colorWithHexString:@"FFC163"]];
    [waringBtn setTitle:NSLocalizedString(@"local.warning", @"") forState:UIControlStateNormal];
    waringBtn.tag = 10;
    [levelView addSubview:waringBtn];
    UIButton *seriousBtn = [self levalBtnWithColor:[UIColor colorWithHexString:@"FC7676"]];
    seriousBtn.tag = 11;
    seriousBtn.selected = YES;
    self.level = @"danger";
    [seriousBtn setTitle:NSLocalizedString(@"local.danger", @"") forState:UIControlStateNormal];
    [levelView addSubview:seriousBtn];
    UIButton *infoBtn = [self levalBtnWithColor:[UIColor colorWithHexString:@"599AFF"]];
    [infoBtn setTitle:NSLocalizedString(@"local.info", @"") forState:UIControlStateNormal];
    infoBtn.tag = 12;
    [levelView addSubview:infoBtn];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(levelView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(24));
        make.width.offset(ZOOM_SCALE(50));
        make.centerY.mas_equalTo(levelView.centerY);
    }];
    [waringBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(infoBtn.mas_left).offset(-Interval(16));
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
        infoBtn.selected = NO;
    }];
    [[seriousBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.level = @"danger";
        seriousBtn.selected = YES;
        waringBtn.selected = NO;
        infoBtn.selected = NO;
    }];
    [[infoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.level = @"info";
        infoBtn.selected = YES;
        seriousBtn.selected = NO;
        waringBtn.selected = NO;
    }];
    UIView *typeView = [[UIView alloc]init];
    typeView.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelView.mas_bottom).offset(Interval(12));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(56));
    }];
    UILabel *typeTip = [[UILabel alloc]init];
    typeTip.text = NSLocalizedString(@"local.category", @"");
    typeTip.font = RegularFONT(16);
    typeTip.textColor = [UIColor colorWithRed:89/255.0 green:88/255.0 blue:96/255.0 alpha:1/1.0];
    [typeView addSubview:typeTip];
    [typeTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(typeView).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(22));
        make.width.offset(ZOOM_SCALE(100));
        make.centerY.mas_equalTo(typeView.centerY);
    }];
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextgray"]];
    [typeView addSubview:arrow];
    [arrow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(typeView).offset(-16);
        make.centerY.mas_equalTo(typeView);
        make.width.offset(ZOOM_SCALE(11));
        make.height.offset(ZOOM_SCALE(16));
    }];
    self.typeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(15) textColor:PWSubTitleColor text:@""];
    [typeView addSubview:self.typeLab];
    [self.typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrow.mas_left).offset(-10);
        make.centerY.mas_equalTo(arrow);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(issueTypeChoose)];
    [typeView addGestureRecognizer:tap];
    UIView *describeView = [[UIView alloc]init];
    describeView.backgroundColor = PWWhiteColor;
    [self.mainScrollView addSubview:describeView];
    [describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeView.mas_bottom).offset(Interval(12));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(180));
    }];
    UILabel *desTitleLab =[[UILabel alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(8), 100, ZOOM_SCALE(20))];
    desTitleLab.text = NSLocalizedString(@"local.description", @"");
    desTitleLab.font = RegularFONT(14);
    desTitleLab.textColor = PWTitleColor;
    [describeView addSubview:desTitleLab];
    if (!_describeTextView) {
        self.describeTextView = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:[NSString stringWithFormat:@"%@...",NSLocalizedString(@"local.PleaseInput", @"")] font:RegularFONT(16)];
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
    count.text = @"0/1000";
    count.font = RegularFONT(13);
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
            text = [text substringToIndex:1000];
            self.describeTextView.text = text;
        }
        count.text = [NSString stringWithFormat:@"%lu/1000",(unsigned long)text.length];
    }];
    RACSignal *describeTextView = [self.describeTextView rac_textSignal];
    RACSignal *titleSignal = [self.titleTf rac_textSignal];
    RACSignal *state = RACObserve(seriousBtn, selected);
    RACSignal *state2 = RACObserve(waringBtn, selected);
    RACSignal *typeSignal = RACObserve(self.typeLab, text);
    RACSignal * navBtnSignal = [RACSignal combineLatest:@[titleSignal,describeTextView,state,state2,typeSignal] reduce:^id(NSString * title,NSString * content,NSString *typeStr){
        NSString *describe = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        return @(title.length>0 && describe.length>0 && self.level.length>0&&self.type.length>0);
    }];
    RAC(self.navRightBtn,enabled) = navBtnSignal;
    self.tableView.rowHeight = ZOOM_SCALE(60)+Interval(30);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:AddIssueCell.class forCellReuseIdentifier:@"AddIssueCell"];
    [self.mainScrollView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeTextView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view);
    make.height.offset(self.attachmentArray.count*(ZOOM_SCALE(60)+Interval(30)));
    }];
}
- (void)issueTypeChoose{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *type = @[@"alarm",@"security",@"expense",@"optimization",@"misc"];
    NSArray *title = @[[type[0] getIssueTypeStr],[type[1] getIssueTypeStr],[type[2] getIssueTypeStr],[type[3] getIssueTypeStr],[type[4] getIssueTypeStr]];

    for (NSInteger i=0; i<title.count; i++) {
        UIAlertAction *alarm = [PWCommonCtrl actionWithTitle:title[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            self.type = type[i];
            self.typeLab.text = title[i];
        }];
        [alert addAction:alarm];
    }
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nullable action) {
        
    }];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(UIButton *)levalBtnWithColor:(UIColor *)color{
    UIButton *button = [[UIButton alloc]init];
    [button setTitleColor:PWWhiteColor forState:UIControlStateSelected];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font =  RegularFONT(14);
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
        lab.text = NSLocalizedString(@"local.headline", @"");
        lab.font = RegularFONT(14);
        lab.textColor = PWTitleColor;
        lab.textAlignment = NSTextAlignmentLeft;
        [_titleView addSubview:lab];
        self.titleTf = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(34), ZOOM_SCALE(350), ZOOM_SCALE(22))];
        self.titleTf.placeholder =[NSString stringWithFormat:@"%@...",NSLocalizedString(@"local.PleaseInput", @"")];
        [_titleView addSubview:self.titleTf];
        [self.mainScrollView addSubview:_titleView];
    }
    return _titleView;
}
-(UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _navRightBtn.frame = CGRectMake(0, 0, 40, 30);
        [_navRightBtn setTitle:NSLocalizedString(@"local.complete", @"") forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(navigationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _navRightBtn.titleLabel.font = RegularFONT(16);
        [_navRightBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_navRightBtn setTitleColor:PWGrayColor forState:UIControlStateDisabled];
        _navRightBtn.tag = NavRightBtnTag;
        _navRightBtn.enabled = NO;
        [_navRightBtn sizeToFit];
    }
    return _navRightBtn;
}
- (void)accessoryBtnClick{
      [[UIResponder currentFirstResponder] resignFirstResponder];
    self.myPicker = [[PWPhotoOrAlbumImagePicker alloc]init];
    [self.myPicker getPhotoAlbumTakeAPhotoAndNameWithController:self photoBlock:^(UIImage *image, NSString *name) {
        [self upLoadImageWithImage:image name:name tag:self.attachmentArray.count+100];
    }];
}
- (void)navigationBtnClick:(UIButton *)button{
    if (button.tag == 5) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@?",NSLocalizedString(@"local.ConfirmToCancelThisNewIssue", @"")] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.verify", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:cancle];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (button.tag == NavRightBtnTag){
        self.navigationItem.rightBarButtonItem.enabled = NO;
        NSDictionary *params;
        if (self.attachmentArray.count>0 && self.batchId !=nil) {
            NSMutableArray *confirmFormUids = [NSMutableArray new];
            [self.attachmentArray enumerateObjectsUsingBlock:^(CreateQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.type == UploadTypeSuccess?[confirmFormUids addObject:obj.fileID]:nil;
            }];
            if (confirmFormUids.count>0) {
                NSDictionary *issueLogForm = @{@"batchId":self.batchId,@"confirmFormUids":confirmFormUids};
                
                params = @{@"data":@{@"level":self.level,@"type":self.type,@"title":self.titleTf.text,@"content":self.describeTextView.text},@"issueLogForm":issueLogForm};
            }else{
              params = @{@"data":@{@"level":self.level,@"type":self.type,@"title":self.titleTf.text,@"content":self.describeTextView.text}};
            }
        }else{
        params = @{@"data":@{@"level":self.level,@"type":self.type,@"title":self.titleTf.text,@"content":self.describeTextView.text}};
        }
        [SVProgressHUD show];

        [PWNetworking requsetHasTokenWithUrl:PW_issueAdd withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
            if([response[@"errorCode"] isEqualToString:@""]){
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.issue.issueCreateSuccess", @"")];
                IssueListViewModel *model = [[IssueListViewModel alloc]init];
                if ([self.level isEqualToString:@"danger"]) {
                    model.state =IssueStateSeriousness;
                }else if([self.level isEqualToString:@"info"]){
                    model.state =IssueStateCommon;
                }else{
                    model.state =IssueStateWarning;
                }
                model.title = self.titleTf.text;
                model.content = self.describeTextView.text;
                model.issueId = [response[@"content"] stringValueForKey:@"id" default:@""];
                model.accountId = getPWUserID;
                model.isFromUser = YES;
                model.watchInfoJSONStr = userManager.curUserInfo.userID;
                model.time = [NSString getLocalDateFormateUTCDate:[[NSDate date] getNowUTCTimeStr] formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                IssueDetailsVC *details = [[IssueDetailsVC alloc]init];
                details.model = model;
                if(![[PWSocketManager sharedPWSocketManager] isConnect]){
                    self.refresh? self.refresh():nil;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:details animated:YES];
                    NSMutableArray *delect = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[AddIssueVC class]]) {
                            [delect removeObject:vc];
                        }
                    }
                    self.navigationController.viewControllers = delect;
                });

                [[[ZhugeIOIssueHelper new] eventCreateProblem] attrAddEnclosure:self.attachmentArray.count > 0];

            }else{
                [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
                [SVProgressHUD dismiss];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [error errorToast];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
}
-(void)upLoadImageWithImage:(UIImage *)image name:(NSString *)name tag:(NSInteger)tag{
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
   
    CreateQuestionModel *model = [[CreateQuestionModel alloc]init];

    if (self.attachmentArray.count<=tag-100) {
        double convertedValue = [data length] * 1.0;
        __block double totleSize;
        [self.attachmentArray enumerateObjectsUsingBlock:^(CreateQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *data = UIImageJPEGRepresentation(obj.image, 0.5);
                totleSize+=[data length]*1.0;
        }];
        if (totleSize>1024*1024*50 || convertedValue>1024*1024*10) {
            [iToast alertWithTitleCenter:NSLocalizedString(@"home.base.payloadTooLarge", @"")];
            return;
        }
    
        
        NSString *size =[self calulateImageFileSize:data];
        if (!name) {
            name = [NSDate getCurrentTimestamp];
        }
        model.name = [NSString stringWithFormat:@"%@.jpg",name];
        model.image = image;
        model.size = size;
        model.fileID = [NSString stringWithFormat:@"%ld",(long)tag];
        model.type = UploadTypeNotStarted;
    
       [self.attachmentArray addObject:model];
       [self.tableView reloadData];
       [self updateTableViewFrame];
    }else{
        model = self.attachmentArray[tag-100];
    }

    NSIndexPath *index = [NSIndexPath indexPathForRow:tag-100 inSection:0];
    AddIssueCell *cell = (AddIssueCell *)[self.tableView cellForRowAtIndexPath:index];
    NSString *time = [NSDate getCurrentTimestamp];
        if (self.upBatchId==nil) {
            self.upBatchId = [NSString stringWithFormat:@"%@%@",time,getPWUserID];
        }
    NSDictionary *param = @{@"type":@"attachment",@"subType":@"issueDetailExtra",@"batchId":self.upBatchId};
    [PWNetworking uploadFileWithUrl:PW_AdduploaAttachment params:param fileData:data type:@"jpg" name:@"files" fileName:[NSString stringWithFormat:@"%@.jpg",name] mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
        DLog(@"bytesWritten = %lld totalBytes = %lld",bytesWritten,totalBytes);
       float progress = 1.0*bytesWritten/totalBytes;
        //回到主线程刷新cell进度
        dispatch_async(dispatch_get_main_queue(), ^{
          [cell setTitleWithProgress:progress];
            [cell layoutIfNeeded];
        });
      
    } successBlock:^(id response) {
        DLog(@"response = %@",response);
        NSDictionary *extra_data = response[@"content"][@"extra_data"];
        self.batchId = [extra_data stringValueForKey:@"batchId" default:@""];
        model.fileID = [extra_data stringValueForKey:@"formUid" default:@""];
        model.type = UploadTypeSuccess;
        dispatch_async(dispatch_get_main_queue(), ^{
             [cell completeUpload];
            [cell layoutIfNeeded];
        });
    } failBlock:^(NSError *error) {
        DLog(@"error = %@",error);
         model.type = UploadTypeError;
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell uploadError];
            [cell layoutIfNeeded];
        });
       
    }];

}
//更新tableView 与 mainScrollView frame
-(void)updateTableViewFrame{
    [self.view updateConstraintsIfNeeded];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
  make.height.offset(self.attachmentArray.count*(ZOOM_SCALE(60)+Interval(30)));
    }];
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.tableView.frame)+10;
    self.mainScrollView.contentSize = CGSizeMake(kWidth,height);
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
   AddIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddIssueCell"];
    cell.index = indexPath;
    cell.model = self.attachmentArray[indexPath.row];
    cell.reUpload = ^(NSIndexPath *index){
        CreateQuestionModel *model = self.attachmentArray[index.row];
        [self upLoadImageWithImage:model.image name:model.name tag:indexPath.row+100];
    };
    cell.removeFile = ^(NSIndexPath *index){
        CreateQuestionModel *model = self.attachmentArray[index.row];
        NSMutableArray<CreateQuestionModel*> *array =[NSMutableArray arrayWithArray:self.attachmentArray];
        [self.attachmentArray enumerateObjectsUsingBlock:^(CreateQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.fileID isEqualToString:obj.fileID]) {
                [array removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
        [self.attachmentArray removeAllObjects];
        self.attachmentArray = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
    };
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (NSString *)calulateImageFileSize:(NSData *)data {
 
    double convertedValue = [data length] * 1.0;
    int multiplyFactor = 0;

    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"M",nil];
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }

    return [NSString stringWithFormat:@"%.f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
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
