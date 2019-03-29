//
//  ScanViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ScanViewController.h"
#import "LBXScanVideoZoomView.h"
#import "PWBaseWebVC.h"
#import "PWPhotoPickerViewController.h"
#import "ScanResultVC.h"


@interface ScanViewController ()<PWPhotoPickerProtocol>
@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置扫码区域参数设置
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.style = style;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //设置扫码后需要扫码图像
//    self.isNeedScanImage = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self drawTopItems];
    [self drawTipLab];
}
- (void)drawTopItems{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight+22)];
    topView.backgroundColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:0.6];
    [self.view addSubview:topView];
    UIButton *cancle = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"取消"];
    [cancle setTitleColor:PWWhiteColor forState:UIControlStateNormal];
    cancle.titleLabel.font = MediumFONT(16);
    [cancle addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancle];
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView).offset(Interval(16));
        make.bottom.mas_equalTo(topView).offset(-Interval(19));
        make.height.offset(ZOOM_SCALE(22));
    }];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(18) textColor:PWWhiteColor text:@"扫一扫"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView);
        make.centerY.mas_equalTo(cancle);
        make.width.offset(ZOOM_SCALE(100));
        make.height.offset(ZOOM_SCALE(25));
    }];
    UIButton *album =[PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"相册"];
    [album setTitleColor:PWWhiteColor forState:UIControlStateNormal];
    album.titleLabel.font = MediumFONT(16);
    [album addTarget:self action:@selector(albumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:album];
    [album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView).offset(-Interval(16));
        make.centerY.mas_equalTo(cancle);
        make.height.offset(ZOOM_SCALE(22));
    }];
}
- (void)drawTipLab{
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(18) textColor:PWTextBlackColor text:@"扫描团队二维码以加入团队"];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    tipLab.layer.masksToBounds = YES;
    tipLab.layer.cornerRadius = ZOOM_SCALE(22);
    [self.view addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-Interval(32)-kTabBarHeight);
        make.width.offset(ZOOM_SCALE(300));
        make.centerX.mas_equalTo(self.view);
        make.height.offset(ZOOM_SCALE(44));
    }];
}
- (void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)albumBtnClick{
    PWPhotoPickerViewController *photo = [[PWPhotoPickerViewController alloc]init];
    photo.delegate = self;
    photo.cameraAdd = NO;
    photo.isHidenNaviBar = YES;
    [self.navigationController pushViewController:photo animated:YES];
}
- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        [self zoomView];
    }
}
- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
        
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value)
        {
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
    
}
- (void)tap
{
    _zoomView.hidden = !_zoomView.hidden;
}
- (void)showError:(NSString*)str
{
//    [LBXAlertAction showAlertWithTitle:@"提示" msg:str buttonsStatement:@[@"知道了"] chooseBlock:nil];
}
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString *strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    

    
    [self showNextVCWithScanResult:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"照片中未识别二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
       
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:strResult preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
 
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    if ([strResult.strScanned isUrlAddress]) {
        ScanResultVC *web = [[ScanResultVC alloc]initWithTitle:@"扫描结果" andURLString:strResult.strScanned];
        [self.navigationController pushViewController:web animated:YES];
    }else{
        
    }
   
    
}
-(void)photoPicker:(PWPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset{
    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];

    [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
        [self scanResultWithArray:array];
    }];
    
}
- (void)photoPicker:(PWPhotoPickerViewController *)picker image:(UIImage *)image{
    //shangchuan
    
    [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
        [self scanResultWithArray:array];
    }];
    
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
