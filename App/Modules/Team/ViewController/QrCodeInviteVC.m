//
//  QrCodeInviteVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "QrCodeInviteVC.h"
#import "PrivacySecurityControls.h"
@interface QrCodeInviteVC ()
@property (nonatomic, strong) UIImageView *qrImgView;
@end

@implementation QrCodeInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码邀请";
    [self createUI];
    [self loadQrData];
}
- (void)loadQrData{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data":@{@"invite_type":@"qrcode"}};
    [PWNetworking requsetHasTokenWithUrl:PW_teamInvite withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *rv = [content stringValueForKey:@"rv" default:@""];
            [self dealWithImg:rv];
        }
        [SVProgressHUD dismiss];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)dealWithImg:(NSString *)rv{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将字符串转换成NSData
    NSData *data = [rv dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    self.qrImgView.image =  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:ZOOM_SCALE(145)];
    
}
-(UIImageView *)qrImgView{
    if (!_qrImgView) {
        _qrImgView = [[UIImageView alloc]init];
        [self.view addSubview:_qrImgView];
    }
    return _qrImgView;
}
- (void)createUI{
    [self.qrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(Interval(56));
        make.width.height.offset(ZOOM_SCALE(145));
    }];
    UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectMake(0, Interval(95)+ZOOM_SCALE(145), kWidth, ZOOM_SCALE(48)) font:RegularFONT(16) textColor:PWTitleColor text:@"成员扫描此二维码即可加入团队\n二维码 30 分钟内有效"];
    tip.numberOfLines = 2;
    tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tip];
    
    UIButton *commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"保存二维码到相册"];
    [commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(tip.mas_bottom).offset(Interval(68));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
}
- (void)commitClick{
    PrivacySecurityControls *privacy = [[PrivacySecurityControls alloc]init];
    NSInteger index = [privacy getPrivacyStatusIsGrantedWithType:PrivacyTypePHPhotoLibrary controller:self];
    if (index == 1){
            UIImageWriteToSavedPhotosAlbum(self.qrImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        if (self.qrImgView.image){
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    }
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)showOpenPhotoAuth{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请开启相册权限" message:@"可依次进入[设置-隐私-照片]，允许访问手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:confirm];

    UIAlertAction *open = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alert addAction:open];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
