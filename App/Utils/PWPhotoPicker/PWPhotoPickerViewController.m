//
//  PWPhotoPickerViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWPhotoPickerViewController.h"
#import "PWPhotoGroupView.h"
#import "PWPhotoListView.h"
#import "PWPhotoListCell.h"
#import "LZImageCropper.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "PrivacySecurityControls.h"


@interface PWPhotoPickerViewController ()<PWPhotoGroupViewProtocol,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LZImageCroppingDelegate>
@property (weak, nonatomic) PWPhotoGroupView *photoGroupView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *navBar;
@property (weak, nonatomic) UIView *bgMaskView;
@property (weak, nonatomic) PWPhotoListView *photoListView;
@property (weak, nonatomic) UIImageView *selectTip;
@property(nonatomic,strong)    LZImageCropper * cropper;
@property (nonatomic,strong) PWPhotoOrAlbumImagePicker *myPicker;


@property (nonatomic) BOOL isNotAllowed;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSIndexPath *lastAccessed;
@end

@implementation PWPhotoPickerViewController
#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        _maximumNumberOfSelection = 10;
        _minimumNumberOfSelection = 0;
        _assetsFilter = [ALAssetsFilter allAssets];
        _showEmptyGroups = NO;
        _assets = [NSMutableArray new];
        _selectionFilter = [NSPredicate predicateWithValue:YES];
    }
    return self;
}
#pragma mark - lifecycle
- (void)loadView {
    [super loadView];
    //加载控件
    //导航条
      [self setupNavBar];
    
    //列表view
    [self setupPhotoListView];
    
    //相册分组
    [self setupGroupView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //没有相册访问权限通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNotAllowed)
                                                 name:@"NotAllowedPhoto"
                                               object:nil];
    //数据初始化
    [self setupData];
    
    //滑动选中图片
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onPanForSelection:)];
    [self.view addGestureRecognizer:pan];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}
#pragma mark - 界面初始化

/**
 *  头部导航
 */
- (void)setupNavBar {
    //界面组件
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = PWWhiteColor;
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:navBar];
    self.navBar = navBar;
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.offset(kTopHeight);
    }];
   
    
    //cancelBtn
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [navBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.bottom.mas_equalTo(navBar);
        make.left.mas_equalTo(navBar);
        make.width.offset(40);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = PWBackgroundColor;
    [navBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(navBar);
        make.height.offset(1);
    }];

    
    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = PWBlackColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [navBar addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cancelBtn);
        make.height.offset(44);
        make.bottom.mas_equalTo(navBar);
        make.centerX.mas_equalTo(navBar.centerX).offset(-10);
    }];
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.backgroundColor = [UIColor clearColor];
    tapBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [tapBtn addTarget:self action:@selector(selectGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:tapBtn];
    
    [tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.height.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.titleLabel).offset(10);
    }];

//    //selectTipImageView
    UIImageView *selectTip = [[UIImageView alloc] init];
    selectTip.image = [UIImage imageNamed:@"selectGroup_tip"];
    selectTip.translatesAutoresizingMaskIntoConstraints = NO;
    [navBar addSubview:selectTip];
    self.selectTip = selectTip;
    [selectTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.titleLabel);
        make.height.offset(11);
        make.width.offset(16);
    }];

}
/**
 *  照片列表
 */
- (void)setupPhotoListView {
    PWPhotoListView *collectionView = [[PWPhotoListView alloc] init];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:collectionView atIndex:0];
    self.photoListView = collectionView;
    collectionView.frame = CGRectMake(0, kTopHeight, kWidth, kHeight-kTopHeight);
    collectionView.backgroundColor = PWBackgroundColor;
}

/**
 *  相册
 */
- (void)setupGroupView {
    PWPhotoGroupView *photoGroupView = [[PWPhotoGroupView alloc] init];
    photoGroupView.assetsFilter = self.assetsFilter;
    photoGroupView.my_delegate = self;
    [self.view insertSubview:photoGroupView belowSubview:self.navBar];
    self.photoGroupView = photoGroupView;
    photoGroupView.hidden = YES;
    photoGroupView.translatesAutoresizingMaskIntoConstraints = NO;

    [photoGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom).offset(-300);
        make.left.right.mas_equalTo(self.view);
        make.height.offset(300);
    }];
}
- (void)setupData {
    [self.photoGroupView setupGroup];
}
#pragma mark - 相册切换
- (void)selectGroupAction:(UIButton *)sender {
    //无权限
    if (self.isNotAllowed) {
        return;
    }
    
    if (self.photoGroupView.hidden) {
        [self bgMaskView];
        self.photoGroupView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.photoGroupView.transform = CGAffineTransformMakeTranslation(0, 300);
            self.selectTip.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [self hidenGroupView];
    }
}
- (void)hidenGroupView {
    [self.bgMaskView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.photoGroupView.transform = CGAffineTransformIdentity;
        self.selectTip.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.photoGroupView.hidden = YES;
    }];
}

#pragma mark - BoPhotoGroupViewProtocol
- (void)didSelectGroup:(ALAssetsGroup *)assetsGroup {
    [self loadAssets:assetsGroup];
    self.titleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self hidenGroupView];
}

//加载图片
- (void)loadAssets:(ALAssetsGroup *)assetsGroup {
    [self.indexPathsForSelectedItems removeAllObjects];
    [self.assets removeAllObjects];
    
    //相机cell
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    //默认第一个为相机按钮
    if(self.cameraAdd){
    [tempList addObject:[UIImage imageNamed:@"icon_camera"]];
    }
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            [tempList addObject:asset];
        } else if (tempList.count > 0) {
            //排序
            NSArray *sortedList = [tempList sortedArrayUsingComparator:^NSComparisonResult(ALAsset *first, ALAsset *second) {
                if ([first isKindOfClass:[UIImage class]]) {
                    return NSOrderedAscending;
                }
                id firstData = [first valueForProperty:ALAssetPropertyDate];
                id secondData = [second valueForProperty:ALAssetPropertyDate];
                return [secondData compare:firstData];//降序
            }];
            [self.assets addObjectsFromArray:sortedList];
            
            [self.photoListView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            [self.photoListView reloadData];
        }
    };
    
    [assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}
#pragma mark - 遮罩背景
- (UIView *)bgMaskView {
    if (_bgMaskView == nil) {
        UIView *bgMaskView = [[UIView alloc] init];
        bgMaskView.alpha = 0.4;
        bgMaskView.translatesAutoresizingMaskIntoConstraints = NO;
        bgMaskView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:bgMaskView aboveSubview:self.photoListView];
        bgMaskView.userInteractionEnabled = YES;
        [bgMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgMaskView:)]];
        _bgMaskView = bgMaskView;
        NSArray *cons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgMaskView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgMaskView)];
        NSArray *cons2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgMaskView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgMaskView)];
        [self.view addConstraints:cons1];
        [self.view addConstraints:cons2];
    }
    return _bgMaskView;
}

- (void)tapBgMaskView:(UITapGestureRecognizer *)sender {
    if (!self.photoGroupView.hidden) {
        [self hidenGroupView];
    }
}

#pragma mark - 没有访问权限提示
- (void)showNotAllowed {
    //没有权限时隐藏部分控件
    self.isNotAllowed = YES;
    self.selectTip.hidden = YES;
//    self.titleLabel.text = @"无权限访问相册";
//    NSString *tipTitle = self.sourceType == 2? @"请开启照片权限":@"请开启相机权限";
//    NSString *tipMessage = type == 2?@"可依次进入[设置-隐私-照片]，允许访问手机相册":@"可依次进入[设置-隐私]中，允许访问相机";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请开启照片权限" message:@"可依次进入[设置-隐私-照片]，允许访问手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *comfirmAction = [PWCommonCtrl actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    
    [alertController addAction:cancle];
    [alertController addAction:comfirmAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}
#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    PWPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    [cell layoutIfNeeded];
    BOOL isSelected = [self.indexPathsForSelectedItems containsObject:self.assets[indexPath.row]];
    [cell bind:self.assets[indexPath.row] selectionFilter:self.selectionFilter isSelected:isSelected];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wh = (collectionView.bounds.size.width - 20)/3.0;
    return CGSizeMake(wh, wh);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    PWPhotoListCell *cell = (PWPhotoListCell *)[self.photoListView cellForItemAtIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    
    //相机按钮处理
    if ([asset isKindOfClass:[UIImage class]] ) {
        self.myPicker = [[PWPhotoOrAlbumImagePicker alloc]init];
        WeakSelf;
        [self.myPicker takeAPhotoWithController:self photoBlock:^(UIImage *image) {
            [weakSelf corop:image];
        }];
        return;
    }
    if (!self.cameraAdd) {
        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didSelectAsset:)])
            [self.navigationController popViewControllerAnimated:NO];
            [_delegate photoPicker:self didSelectAsset:asset];
            return;
    }else{
    self.cropper= [[LZImageCropper alloc]init];
    //设置代理
    self.cropper.delegate = self;
    //设置图片
    
    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    self.cropper.image = image;
    //设置自定义裁剪区域大小
    self.cropper.cropSize = CGSizeMake(ZOOM_SCALE(337), ZOOM_SCALE(337));
    self.cropper.isRound = YES;
    [self presentViewController:self.cropper animated:YES completion:nil];
    }
//    //单选
//    if (!self.multipleSelection && self.indexPathsForSelectedItems.count==1) {
//        //取消上一个选中
//        NSInteger index = [self.assets indexOfObject:self.indexPathsForSelectedItems[0]];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//        PWPhotoListCell *previousCell = (PWPhotoListCell *)[self.photoListView cellForItemAtIndexPath:indexPath];
//        [previousCell isSelected:NO];
//        [self.indexPathsForSelectedItems removeAllObjects];
//
//        //选中当前的
//        [self.indexPathsForSelectedItems addObject:asset];
//        [cell isSelected:YES];
//        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didDeselectAsset:)])
//            [_delegate photoPicker:self didDeselectAsset:asset];
//        return;
//    }
//
//    //超出最大限制
//    if (self.indexPathsForSelectedItems.count >= self.maximumNumberOfSelection && ![self.indexPathsForSelectedItems containsObject:asset]) {
//        if (_delegate && [_delegate respondsToSelector:@selector(photoPickerDidMaximum:)])
//            [_delegate photoPickerDidMaximum:self];
//        return;
//    }
//
//    //选择过滤
//    BOOL selectable = [self.selectionFilter evaluateWithObject:asset];
//    if (!selectable) {
//        if (_delegate && [_delegate respondsToSelector:@selector(photoPickerDidSelectionFilter:)])
//            [_delegate photoPickerDidSelectionFilter:self];
//        return;
//    }
//
//    //取消选中
//    if ([self.indexPathsForSelectedItems containsObject:asset]) {
//        [self.indexPathsForSelectedItems removeObject:asset];
//        [cell isSelected:NO];
//        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didDeselectAsset:)])
//            [_delegate photoPicker:self didDeselectAsset:asset];
//        return;
//    }
//
//    //选中
//    [self.indexPathsForSelectedItems addObject:asset];
//    [cell isSelected:YES];
//    if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didSelectAsset:)])
//        [_delegate photoPicker:self didSelectAsset:asset];
}
- (void)corop:(UIImage *)img{
    self.cropper= [[LZImageCropper alloc]init];
    //设置代理
    self.cropper.delegate = self;
    //设置图片
    
    self.cropper.image = img;
    //设置自定义裁剪区域大小
    self.cropper.cropSize = CGSizeMake(self.view.frame.size.width - 60, (self.view.frame.size.width-60)*960/1280);
    self.cropper.isRound = YES;
    [self presentViewController:self.cropper animated:YES completion:nil];
}
#pragma mark - Action
- (void)onPanForSelection:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:_photoListView];
    
    for (UICollectionViewCell *cell in _photoListView.visibleCells) {
        if (CGRectContainsPoint(cell.frame, point)) {
            NSIndexPath *indexPath = [_photoListView indexPathForCell:cell];
            if (_lastAccessed != indexPath) {
                [self collectionView:_photoListView didSelectItemAtIndexPath:indexPath];
            }
            _lastAccessed = indexPath;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        _lastAccessed = nil;
    }
}
#pragma mark - Delegate
-(void)lzImageCropping:(LZImageCropper *)cropping didCropImage:(UIImage *)image{
    [self.navigationController popViewControllerAnimated:NO];

    if ([_delegate respondsToSelector:@selector(photoPicker:image:)]) {
        [_delegate photoPicker:self image:image];
    }
}
- (void)cancelBtnAction:(UIButton *)sender {
//    if ([_delegate respondsToSelector:@selector(photoPickerDidCancel:)]) {
//        [_delegate photoPickerDidCancel:self];
//    }
    [self.navigationController popViewControllerAnimated:YES];
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
