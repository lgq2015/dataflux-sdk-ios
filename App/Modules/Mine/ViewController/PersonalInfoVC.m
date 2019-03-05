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

@interface PersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource,PWPhotoPickerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUser)
                                                 name:KNotificationUserInfoChange
                                               object:nil];
    [self createUI];
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    NSString *emailText = userManager.curUserInfo.email ==nil? @"去绑定":userManager.curUserInfo.email;
    NSString *phoneText = userManager.curUserInfo.mobile ;
    NSString *nameText = userManager.curUserInfo.username==nil? phoneText:userManager.curUserInfo.username;
    
    MineCellModel *icon = [[MineCellModel alloc]initWithTitle:@"头像" rightIcon:userManager.curUserInfo.avatar];
    MineCellModel *name = [[MineCellModel alloc]initWithTitle:@"姓名" describeText:nameText];
    MineCellModel *phone = [[MineCellModel alloc]initWithTitle:@"手机号" describeText:phoneText];
    MineCellModel *email = [[MineCellModel alloc]initWithTitle:@"邮箱" describeText:emailText];

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
    NSString *emailText = userManager.curUserInfo.email ==nil? @"去绑定":userManager.curUserInfo.email;
    NSString *phoneText = userManager.curUserInfo.mobile ;
    NSString *nameText = userManager.curUserInfo.username==nil? phoneText:userManager.curUserInfo.username;
    MineCellModel *icon = [[MineCellModel alloc]initWithTitle:@"头像"];
    MineCellModel *name = [[MineCellModel alloc]initWithTitle:@"姓名" describeText:nameText];
    MineCellModel *phone = [[MineCellModel alloc]initWithTitle:@"手机号" describeText:phoneText];
    MineCellModel *email = [[MineCellModel alloc]initWithTitle:@"邮箱" describeText:emailText];
    NSArray *array =@[icon,name,phone,email];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
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
        [cell setAlermDescribeLabText:@"去绑定"];
    }
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PWPhotoPickerViewController *picker = [[PWPhotoPickerViewController alloc]init];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return YES;
        }];
        picker.isHidenNaviBar = YES;
        [self.navigationController pushViewController:picker animated:YES];
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

- (void)photoPicker:(PWPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
//    [self.photos addObjectsFromArray:assets];
//    if (assets.count == 1) {
//        ALAsset *asset = assets[0];
//        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        self.imageView.image = tempImg;
//    } else {
//        CGFloat x = 0;
//        CGRect frame = CGRectMake(0, 0, 50, 50);
//        for (int i = 0 ; i < self.photos.count; i++) {
//            ALAsset *asset = self.photos[i];
//            UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            frame.origin.x = x;
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//            [imageView setContentMode:UIViewContentModeScaleAspectFill];
//            imageView.clipsToBounds = YES;
//            imageView.image = tempImg;
//            imageView.tag = i;
//            imageView.userInteractionEnabled = YES;
//            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBig:)]];
//            [self.scrollView addSubview:imageView];
//            x += frame.size.width+5;
//        }
//        self.scrollView.contentSize = CGSizeMake(55 * self.photos.count, 0);
//    }
 //   [picker dismissViewControllerAnimated:NO completion:nil];
    
    //显示预览
    //    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:assets];
    //    photoBrowserViewController.delegate = self;
    //    [self presentViewController:photoBrowserViewController animated:YES completion:nil];
    
}

- (void)photoPicker:(PWPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}





- (void)photoPickerTapCameraAction:(PWPhotoPickerViewController *)picker {
//    [self checkCameraAvailability:^(BOOL auth) {
//        if (!auth) {
//            NSLog(@"没有访问相机权限");
//            return;
//        }
//
//        [picker dismissViewControllerAnimated:NO completion:nil];
//        UIImagePickerController *cameraUI = [UIImagePickerController new];
//        cameraUI.allowsEditing = NO;
//        cameraUI.delegate = self;
//        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
//        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
//
//        [self presentViewController: cameraUI animated: YES completion:nil];
//    }];
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
