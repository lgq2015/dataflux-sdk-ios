//
//  IssueUserDetailView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueUserDetailView.h"
#import "IssueListViewModel.h"
#import "IssueAttachmentCell.h"
#import "IssueAttachmentModel.h"
#import <QuickLook/QuickLook.h>
#import <AFNetworking.h>
#import "QLPreviewController+title.h"
#import "PWBaseWebVC.h"
#import "AssignView.h"
#import "TouchLargeButton.h"

#define ZY_AttachmentPreview @"ZY_AttachmentPreview"
@interface IssueUserDetailView()<UITableViewDelegate, UITableViewDataSource,QLPreviewControllerDataSource,UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) IssueListViewModel *model;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView  *upContainerView;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIView  *subContainerView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *expireData;
@property (nonatomic, strong) UILabel *createUser;
@property (nonatomic, copy)   NSURL *fileURL; //文件路径
@property (nonatomic, strong) UIImageView *repairIcon;
@property (nonatomic, strong) TouchLargeButton *repairBtn;
@property (nonatomic, strong) AssignView *assignView;


@end
@implementation IssueUserDetailView
-(instancetype)initHeaderWithIssueModel:(IssueListViewModel *)model{
    if (self = [super init]) {
        self.model = model;
        [self createHeaderUI];
    }
    return self;
}
- (void)createHeaderUI{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
        make.top.mas_equalTo(self.upContainerView).offset(Interval(14));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
    }];
    [self.upContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(Interval(12));
        make.right.left.mas_equalTo(self);
    }];
    self.titleLab.text =self.model.title;
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(16);
        make.width.offset(ZOOM_SCALE(54));
        make.height.offset(ZOOM_SCALE(24));
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(ZOOM_SCALE(10));
    }];
    [self stateLabUI];
    [self.repairBtn sizeToFit];
    CGSize btnSize = self.repairBtn.frame.size;
    [self.repairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.upContainerView).offset(-16);
        make.width.offset(btnSize.width);
        make.height.offset(ZOOM_SCALE(14));
    }];
    [self.repairIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.repairBtn.mas_left).offset(-4);
        make.width.height.offset(ZOOM_SCALE(16));
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(Interval(10));
        make.centerY.mas_equalTo(self.stateLab);
        make.height.offset(ZOOM_SCALE(18));
    }];
    self.timeLab.text =[self.model.time accurateTimeStr];
//    [self.createUser mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.stateLab);
//        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(10);
//        make.height.offset(ZOOM_SCALE(18));
//    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self.upContainerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.mas_equalTo(self.upContainerView);
        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(Interval(17));
        make.height.offset(1);
        make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(ZOOM_SCALE(-54));
    }];
    [self.assignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.right.mas_equalTo(self.upContainerView);
        make.height.offset(ZOOM_SCALE(54));
        make.bottom.mas_equalTo(self.upContainerView);
    }];
    UILabel *lab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:@"详细信息"];
    [self.subContainerView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subContainerView).offset(Interval(16));
        make.top.mas_equalTo(self.subContainerView).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(22));
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lab);
        make.top.mas_equalTo(lab.mas_bottom).offset(ZOOM_SCALE(16));
        make.right.mas_equalTo(self.subContainerView).offset(-Interval(16));
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(20));
    }];
    self.contentLab.text = self.model.content;
    [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(12));
        make.width.offset(kWidth);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-12);
    }];
}
-(void)createAttachmentUIWithAry:(NSArray *)array{
    self.expireData = [NSMutableArray new];
    [self.expireData addObjectsFromArray:array];
        if (array.count>0) {
            self.mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:@"附件"];
            [self.subContainerView addSubview:title];
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLab.mas_bottom).offset(Interval(16));
                make.left.mas_equalTo(self.contentLab);
                make.height.offset(ZOOM_SCALE(22));
            }];
            [self.subContainerView addSubview:self.mTableView];
            self.mTableView.backgroundColor = PWWhiteColor;
            [self.mTableView registerClass:IssueAttachmentCell.class forCellReuseIdentifier:@"IssueAttachmentCell"];
            self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.mTableView.rowHeight = ZOOM_SCALE(70);
            self.mTableView.delegate = self;
            self.mTableView.dataSource = self;
            self.mTableView.scrollEnabled = NO;
            [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-ZOOM_SCALE(70)*array.count-Interval(56)-ZOOM_SCALE(22));
            }];
            [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(title.mas_bottom).offset(Interval(25));
                make.width.offset(kWidth);
                make.height.offset(ZOOM_SCALE(70)*array.count);
                make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(12));
            }];
        }
        [self layoutIfNeeded];
    
}
- (void)recoveClick{
//    if (self.recoverClick) {
//        self.recoverClick();
//    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"手动修复情报后，该情报将不会再出现在您的活跃情报中" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *commit = [PWCommonCtrl actionWithTitle:@"确认修复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
        
        [[PWHttpEngine sharedInstance]recoveIssueWithIssueid:self.model.issueId callBack:^(id response) {
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                KPostNotification(KNotificationReloadIssueList, nil);
                [self recoveUI];
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nullable action) {
        
    }];
    [alert addAction:commit];
    [alert addAction:cancle];
    [self.viewController presentViewController:alert animated:YES completion:nil];
    DLog(@"self.model.issueId == %@",self.model.issueId);
  
    
}
- (void)recoveUI{
    [self.assignView repair];
    [_repairBtn setTitle:@"已恢复" forState:UIControlStateNormal];
    _repairBtn.enabled = NO;
    [_repairIcon setImage:[UIImage imageNamed:@"issue_tick"]];
    _repairIcon.userInteractionEnabled = NO;
    [self.repairBtn sizeToFit];
    CGSize btnSize = self.repairBtn.frame.size;
    [self.repairBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.upContainerView).offset(-16);
        make.width.offset(btnSize.width);
        make.height.offset(ZOOM_SCALE(14));
    }];
    [self.repairIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.repairBtn.mas_left).offset(-4);
        make.width.height.offset(ZOOM_SCALE(16));
    }];
    if (self.recoverClick) {
        self.recoverClick(NO);
    }
}

- (void)reloadHeaderUI{
    [self stateLabUI];
    self.timeLab.text =[self.model.time accurateTimeStr];
    [self layoutIfNeeded];
}
- (void)stateLabUI{
    switch (self.model.state) {
        case IssueStateWarning:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.stateLab.text = @"警告";
            break;
        case IssueStateSeriousness:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"严重";
            break;
        case IssueStateCommon:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            self.stateLab.text = @"提示";
            break;
        case IssueStateRecommend:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已恢复";
            break;
        case IssueStateLoseeEfficacy:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
}
-(void)setCreateUserName:(NSString *)name{
    self.createUser.text = name;
    [self layoutIfNeeded];
}
#pragma mark ========== UI/INIT ==========

-(UIView *)upContainerView{
    if (!_upContainerView) {
        _upContainerView = [[UIView alloc]init];
        _upContainerView.backgroundColor = PWWhiteColor;
        [self addSubview:_upContainerView];
    }
    return _upContainerView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@""];
        _titleLab.numberOfLines = 0;
        [self.upContainerView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)createUser{
    if (!_createUser) {
        _createUser = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13)
                                         textColor:PWTitleColor text:@""];
        [self.upContainerView addSubview:_createUser];
    }
    return _createUser;
}
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWSubTitleColor text:nil];
        _contentLab.backgroundColor = PWWhiteColor;
        _contentLab.numberOfLines = 0;
        [self.subContainerView addSubview:_contentLab];
    }
    return _contentLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:nil];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        [self.upContainerView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  RegularFONT(14);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self.upContainerView addSubview:_stateLab];
    }
    return _stateLab;
}
-(UIImageView *)repairIcon{
    if (!_repairIcon) {
        _repairIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        if (self.model.recovered) {
            [_repairIcon setImage:[UIImage imageNamed:@"issue_tick"]];
            _repairIcon.userInteractionEnabled = NO;
        }else{
            _repairIcon.userInteractionEnabled = YES;
            [_repairIcon setImage:[UIImage imageNamed:@"icon_repair"]];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoveClick)];
        [_repairIcon addGestureRecognizer:tap];
        [self.upContainerView addSubview:_repairIcon];
    }
    return _repairIcon;
}
-(TouchLargeButton *)repairBtn{
    if (!_repairBtn) {
        _repairBtn = [[TouchLargeButton alloc]initWithFrame:CGRectZero];
        _repairBtn.titleLabel.font = RegularFONT(14);
        [_repairBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        if (self.model.recovered) {
            [_repairBtn setTitle:@"已恢复" forState:UIControlStateNormal];
            _repairBtn.enabled = NO;
        }else{
            [_repairBtn setTitle:@"修复" forState:UIControlStateNormal];
        }
         [_repairBtn addTarget:self action:@selector(recoveClick) forControlEvents:UIControlEventTouchUpInside];
        [self.upContainerView addSubview:_repairBtn];
    }
    return _repairBtn;
}
-(AssignView *)assignView{
    if (!_assignView) {
        _assignView = [[AssignView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(54)) IssueModel:self.model];
        WeakSelf
        _assignView.AssignClick = ^(BOOL isAssignSelf){
            if (weakSelf.recoverClick) {
                weakSelf.recoverClick(isAssignSelf);
            }
        };
        [self.upContainerView addSubview:_assignView];
    }
    return _assignView;
}
-(UIView *)subContainerView{
    if (!_subContainerView) {
        _subContainerView = [[UIView alloc]init];
        _subContainerView.backgroundColor = PWWhiteColor;
        [self addSubview:_subContainerView];
    }
    return _subContainerView;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.expireData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueAttachmentCell"];
    IssueAttachmentModel *model = [[IssueAttachmentModel alloc]initWithDictionary:self.expireData[indexPath.row]];
    cell.model = model;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IssueAttachmentModel *model = [[IssueAttachmentModel alloc]initWithDictionary:self.expireData[indexPath.row]];
    DLog(@"fileUrl----%@",model.fileUrl);
    NSString *ext = [model.fileUrl pathExtension];
    if ([ext isEqualToString:@"csv"]
        || [ext isEqualToString:@"rar"]
        || [ext isEqualToString:@"zip"]){
        [iToast alertWithTitleCenter:@"抱歉，该文件暂时不支持预览"];
        return;
    }else if( [ext isEqualToString:@"txt"]){//下载后用QL预览
        [self previewInternet:model.fileUrl];
    }else{
        PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:@"附件" andURL:[NSURL URLWithString:model.fileUrl]];
        [self.viewController.navigationController pushViewController:webView animated:YES];
    }
}
#pragma mark ----预览网络文件-----
- (void)previewInternet:(NSString *)urlStr{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURL *url =[self cachePath:fileName];
    //判断是否存在
    if([self isFileExist:fileName]) {
        [self presentQLViewController:url];
    }else {
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat value = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                NSString *valueStr = [NSString stringWithFormat:@"%.2f",value];
                [SVProgressHUD showProgress:[valueStr floatValue]];
            });
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [SVProgressHUD dismiss];
            [self presentQLViewController:url];
        }];
        [downloadTask resume];
    }
    
}
//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [[path stringByAppendingPathComponent:ZY_AttachmentPreview] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}
//获取附件路径URL
- (NSURL *)cachePath:(NSString *)fileUrlStr{
    NSURL *cachesDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:ZY_AttachmentPreview];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]){
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSURL *url = [[cachesDirectoryURL URLByAppendingPathComponent:ZY_AttachmentPreview] URLByAppendingPathComponent:fileUrlStr];
    DLog(@"fileLocalPath-----%@",url);
    return url;
}
//跳转到QL预览界面
- (void)presentQLViewController:(NSURL *)filePath{
    self.fileURL = filePath;
    QLPreviewController *vc  =  [[QLPreviewController alloc]  init];
    vc.dataSource  = self;
    vc.qltitle = @"附件";
    self.viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [vc refreshCurrentPreviewItem];
}
//跳转到Docuement预览界面
- (void)presentDocumentViewController:(NSURL *)filePath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"文件无法预览，是否使用第三方打开" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIDocumentInteractionController *vc = [UIDocumentInteractionController interactionControllerWithURL:filePath];
        vc.delegate = self;
        [vc presentOpenInMenuFromRect:CGRectZero inView:self animated:YES];
    }];
    UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
