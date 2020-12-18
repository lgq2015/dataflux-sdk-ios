//
//  PersonalInfoVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "ChangeUserInfoVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "BindEmailOrPhoneVC.h"
#import "PWPhotoPickerViewController.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "UIImage+fixOrientation.h"
#import "ZhugeIOMineHelper.h"
#import <FTMobileAgent.h>
@interface PersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource,PWPhotoPickerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.PersonalInformation", @"");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUser)
                                                 name:KNotificationUserInfoChange
                                               object:nil];
    [self createUI];
    [self loadUserInfo];
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    NSString *emailText = userManager.curUserInfo.email ==nil? NSLocalizedString(@"local.ToBind", @""):userManager.curUserInfo.email;
    NSString *phoneText = userManager.curUserInfo.mobile ;
    NSString *nameText =  userManager.curUserInfo.name;
;
     NSString *avatar =[userManager.curUserInfo.tags stringValueForKey:@"pwAvatar" default:@""];
    MineCellModel *icon = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.ProfilePhoto", @"") rightIcon:avatar];
    MineCellModel *name = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.name", @"") describeText:nameText];
    MineCellModel *phone = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.MobilePhoneNo", @"") describeText:phoneText];
    MineCellModel *email = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.mailbox", @"") describeText:emailText];

    NSArray *array =@[icon,name,phone,email];
    [self.dataSource addObjectsFromArray:array];
    self.tableView.frame = CGRectMake(0, 5, kWidth, self.dataSource.count*45);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, Interval(16), 0, 0);
    [self.tableView reloadData];
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    [self.view addSubview:self.tableView];
}
- (void)updateUser{
    NSString *emailText = userManager.curUserInfo.email ==nil? NSLocalizedString(@"local.ToBind", @""):userManager.curUserInfo.email;
    NSString *phoneText = userManager.curUserInfo.mobile ;
    NSString *nameText = userManager.curUserInfo.name;
    NSString *avatar =[userManager.curUserInfo.tags stringValueForKey:@"pwAvatar" default:@""];
    MineCellModel *icon = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.ProfilePhoto", @"") rightIcon:avatar];
    MineCellModel *name = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.name", @"") describeText:nameText];
    MineCellModel *phone = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.MobilePhoneNo", @"") describeText:phoneText];
    MineCellModel *email = [[MineCellModel alloc]initWithTitle:NSLocalizedString(@"local.mailbox", @"") describeText:emailText];
    NSArray *array =@[icon,name,phone,email];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (void)loadUserInfo{
    [PWNetworking requsetHasTokenWithUrl:PW_currentUser withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response isKindOfClass:NSDictionary.class] && [response[@"content"] isKindOfClass:NSDictionary.class]) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSError *error;
               CurrentUserModel *model  = [[CurrentUserModel alloc]initWithDictionary:response[@"content"] error:&error];
                userManager.curUserInfo = model;
                [self updateUser];
                [userManager saveChangeUserInfo];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    
    if (indexPath.row==0 ) {
        [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeImage];
    }else {
        [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypedDescribe];
    }
    
    if (indexPath.row == self.dataSource.count-1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
    }
    if (userManager.curUserInfo.email ==nil && indexPath.row == 3) {
        [cell setAlermDescribeLabText:NSLocalizedString(@"local.ToBind", @"")];
    }else if(indexPath.row == 3){
        [cell setDescribeLabText:userManager.curUserInfo.email];
    }
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PWPhotoPickerViewController *picker = [[PWPhotoPickerViewController alloc]init];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.cameraAdd = YES;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return YES;
        }];
        picker.isHidenNaviBar = YES;
        [self.navigationController pushViewController:picker animated:YES];
        [[[ZhugeIOMineHelper new] eventChangeHeadImage] track];

    }else if(indexPath.row == 1){
        BindEmailOrPhoneVC *nameVC = [[BindEmailOrPhoneVC alloc]init];
        nameVC.isShowCustomNaviBar = YES;
        nameVC.isFirst = userManager.curUserInfo.username ==nil?YES:NO;
        nameVC.changeType = BindUserInfoTypeName;
        [self.navigationController pushViewController:nameVC animated:YES];
    }else if(indexPath.row == 2){
        ChangeUserInfoVC *change = [[ChangeUserInfoVC alloc]init];
        change.type = ChangeUITPhoneNumber;
        change.isShowCustomNaviBar = YES;
        [self.navigationController pushViewController:change animated:YES];
    }else{
        ChangeUserInfoVC *change = [[ChangeUserInfoVC alloc]init];
        change.type = ChangeUITEmail;
        change.isShowCustomNaviBar = YES;
        [self.navigationController pushViewController:change animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(PWPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(PWPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}

- (void)photoPicker:(PWPhotoPickerViewController *)picker image:(UIImage *)image{
    //shangchuan

  
     NSData *data = UIImageJPEGRepresentation(image, 1);
    [PWNetworking uploadFileWithUrl:PW_accountAvatar fileData:data type:@"jpg" name:@"files" mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
        DLog(@"%lld",totalBytes);
          [SVProgressHUD show];
    } successBlock:^(id response) {
        DLog(@"%@",response);
        if([response[ERROR_CODE] isEqualToString:@""]){
            NSDictionary *tags = response[@"content"][@"tags"];
            userManager.curUserInfo.tags = tags;
            KPostNotification(KNotificationUserInfoChange, nil);
            
        }
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.tip.ChangeAvatarSuccess", @"")];
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"server.err.home.recommendation.uploadFailed", @"")];

    }];

}



- (void)photoPickerTapCameraAction:(PWPhotoPickerViewController *)picker {
    
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
