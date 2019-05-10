//
//  IssueProblemDetailsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueProblemDetailsVC.h"
#import "IssueAttachmentCell.h"
#import "IssueAttachmentModel.h"
#import "PPBadgeView.h"
#import "PWBaseWebVC.h"
#import "IssueChatVC.h"
#import "IssueListManger.h"
#import <QuickLook/QuickLook.h>
#import <AFNetworking.h>
#import "QLPreviewController+title.h"
#define ZY_AttachmentPreview @"ZY_AttachmentPreview"
@interface IssueProblemDetailsVC ()<UITableViewDelegate, UITableViewDataSource,QLPreviewControllerDataSource,UIDocumentInteractionControllerDelegate>


@property (nonatomic, strong) UIButton *ignoreBtn;
@property (copy, nonatomic)NSURL *fileURL; //文件路径
@property (nonatomic, strong) NSMutableArray *expireData;
@property (nonatomic, strong) UILabel *createNameLab;
@end

@implementation IssueProblemDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报详情";
    [self setupView];
    [self loadIssueDetailExtra];
    [self loadInfoDeatil];
}
#pragma mark ========== datas ==========
- (void)loadInfoDeatil{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response,@"content");
            self.infoDetailDict = content;
            NSDictionary *accountInfo =PWSafeDictionaryVal(content, @"accountInfo");
            NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
            
            if ([name isKindOfClass:NSNull.class]||name ==nil || [name isEqualToString:@""]) {
                self.model.isFromUser?name= NSLocalizedString(@"isseu.detail.accountInfo.user", @""):NSLocalizedString(@"isseu.detail.accountInfo.staff", @"");
            }
            self.createNameLab.text = [NSString stringWithFormat:@"%@ 创建",name];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (void)loadIssueDetailExtra{
    self.expireData = [NSMutableArray new];
    DLog(@"self.model.issueId = %@",self.model.issueId);
    NSDictionary *param = @{@"pageSize": @100,
            @"type":@"attachment",
            @"subType":@"issueDetailExtra",
            @"_withAttachmentExternalDownloadURL":@YES,
            @"_attachmentExternalDownloadURLOSSExpires":@(3600),
            @"issueId":self.model.issueId
    };
    [PWNetworking requsetHasTokenWithUrl:PW_issueLog withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if([response[ERROR_CODE] isEqualToString:@""]){
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            [self.expireData addObjectsFromArray:data];
            [self dealWithSubViewWithData:data];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}
#pragma mark ========== UI ==========


- (void)setupView{
    [self.createNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(Interval(11));
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.createNameLab.mas_bottom).offset(ZOOM_SCALE(11));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
        make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-Interval(20));
    }];
    self.contentLab.text = self.model.content;
}

- (void)dealWithSubViewWithData:(NSArray *)data{
       UIView *temp;
    if (data.count>0) {
        [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(20));
            make.left.right.mas_equalTo(self.view);
            make.width.offset(kWidth);
        }];
        UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(17), 100, ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWTextBlackColor text:@"附件"];
        [self.subContainerView addSubview:title];
        [self.subContainerView addSubview:self.tableView];
        self.tableView.backgroundColor = PWWhiteColor;
        [self.tableView registerClass:IssueAttachmentCell.class forCellReuseIdentifier:@"IssueAttachmentCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = ZOOM_SCALE(70);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(title.mas_bottom).offset(Interval(25));
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(70)*data.count);
            make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(15));
        }];
        temp = self.subContainerView;
    }else{
        temp = self.upContainerView;
    }
    DLog(@"model = %@ account = %@",self.model.accountId,getPWUserID);
    if ([[self.model.accountId stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:getPWUserID] || userManager.teamModel.isAdmin) {
        
        
        self.ignoreBtn.hidden = self.model.state == MonitorListStateRecommend?YES:NO;
        
        [self.ignoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.solveBtn.mas_bottom).offset(Interval(20));
            make.width.offset(ZOOM_SCALE(100));
            make.height.offset(ZOOM_SCALE(20));
            make.centerX.mas_equalTo(self.mainScrollView);
        }];
    }else{
        _ignoreBtn.hidden = YES;
    }
    [self.view layoutIfNeeded];
    
    
    CGFloat height =CGRectGetMaxY(self.solveBtn.frame)+Interval(30);
    
    if ([[self.model.accountId stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:getPWUserID] || userManager.teamModel.isAdmin) {
        height += 50;
    }
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);

}



#pragma mark ========== subView ==========
-(UILabel *)createNameLab{
    if (!_createNameLab) {
        _createNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_createNameLab];
    }
    return _createNameLab;
}
-(UIButton *)ignoreBtn{
    if (!_ignoreBtn) {
        _ignoreBtn = [[UIButton alloc]init];
        [_ignoreBtn setTitle:@"关闭此情报" forState:UIControlStateNormal];
        [_ignoreBtn setTitleColor:PWSubTitleColor forState:UIControlStateNormal];
        _ignoreBtn.titleLabel.font = RegularFONT(14);
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:_ignoreBtn];
    }
    return _ignoreBtn;
}
#pragma mark ========== btnClick ==========

- (void)ignoreBtnClick:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关闭情报将会结束情报相关的讨论与服务" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm =[PWCommonCtrl actionWithTitle:@"确认关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [PWNetworking requsetHasTokenWithUrl:PW_issueRecover(self.model.issueId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
                self.refreshClick?self.refreshClick():nil;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
                if ([response[ERROR_CODE] isEqualToString:@"home.issue.AlreadyIsRecovered"]) {
                    self.refreshClick?self.refreshClick():nil;
                 IssueModel *model = [[IssueListManger sharedIssueListManger] getIssueDataByData:self.model.issueId];
                    self.model =[[IssueListViewModel alloc]initWithJsonDictionary:model];
                    self.ignoreBtn.hidden = YES;
                    [self updateUI];
                }
            }
        } failBlock:^(NSError *error) {
            [error errorToast];
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupBadges{
    [self.navigationItem.rightBarButtonItem pp_addBadgeWithNumber:2];
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
        [self.navigationController pushViewController:webView animated:YES];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc refreshCurrentPreviewItem];
}
//跳转到Docuement预览界面
- (void)presentDocumentViewController:(NSURL *)filePath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"文件无法预览，是否使用第三方打开" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIDocumentInteractionController *vc = [UIDocumentInteractionController interactionControllerWithURL:filePath];
        vc.delegate = self;
        [vc presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }];
    UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}
@end
