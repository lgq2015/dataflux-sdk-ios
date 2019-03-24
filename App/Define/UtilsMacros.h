//
//  define.h
//  MiAiApp
//
//
//

// 全局工具类宏定义

#ifndef define_h
#define define_h

#define APP_ID @"1441939241"
#define ERROR_CODE @"errorCode"
// iOS 11 以下的评价跳转
#define APP_OPEN_EVALUATE [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APP_ID]
// iOS 11 的评价跳转
#define APP_OPEN_EVALUATE_AFTER_IOS11 [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review", APP_ID]

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController

#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
//验证码有效时间token key
#define verifyCode_token @"verifyCode_token"

//安全区域顶部
#define SafeAreaTop_Height  (kTopHeight-64)
//安全区域底部（iPhone X有）
#define SafeAreaBottom_Height  (kTabBarHeight-49)

//获取屏幕宽高
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据设计图的尺寸来拉伸
#define ZOOM_SCALE(fitting)  fitting*(float)([[UIScreen mainScreen] bounds].size.width/375.0)
#define Interval(fitting)  fitting
//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define WeakSelf __weak typeof(self) weakSelf = self;

#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言
#define CurrentLanguage ([NSLocale preferredLanguages] objectAtIndex:0])

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif
//#define NSLocalizedString(key,comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
//主题色 导航栏颜色
#define CNavBgColor  [UIColor whiteColor]
#define CTabbarTextColor [UIColor colorWithHexString:@"333333"]

#define PWTextColor [UIColor colorWithHexString:@"333333"]
#define PWOrangeTextColor [UIColor colorWithHexString:@"FF4E00"]
#define PWTextLight [UIColor colorWithHexString:@"A6A6A6"]
#define PWBackgroundColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]
#define PWTextBlackColor [UIColor colorWithHexString:@"140F26"]
#define PWReadColor [UIColor colorWithHexString:@"8E8E93"]
#define PWCancelBtnColor [UIColor colorWithHexString:@"140F26"]
#define PWDefaultBtnColor [UIColor colorWithHexString:@"0D47A1"]
#define PWDestructiveBtnColor [UIColor colorWithHexString:@"D50000"]
#define textColorNormalState [UIColor colorWithHexString:@"8E8E93"]
#define textColorWarningState [UIColor colorWithHexString:@"D50000"]
#define WarningTextColor [UIColor colorWithHexString:@"2A7AF7"]
#define PWTitleColor [UIColor colorWithHexString:@"595860"]
#define PWSubTitleColor [UIColor colorWithHexString:@"8E8E93"] 
//颜色
#define PWChatCellColor  RGBACOLOR(250,250,250,1)
#define CellLineColor    RGBACOLOR(200,200,200,1)

#define PWClearColor [UIColor clearColor]
#define PWWhiteColor [UIColor whiteColor]
#define PWBlackColor [UIColor blackColor]
#define PWGrayColor [UIColor grayColor]
#define PWGray2Color [UIColor lightGrayColor]
#define PWBlueColor [UIColor colorWithHexString:@"2A7AF7"]
#define PWRedColor [UIColor redColor]
#define PWRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//字体 Family: PingFang SC
#define RegularFONT(FONTSIZE)           FONT(@"PingFangSC-Regular", FONTSIZE)
#define BOLDFONT(FONTSIZE)      FONT(@"PingFangSC-Semibold", FONTSIZE)
#define MediumFONT(FONTSIZE)    FONT(@"PingFangSC-Medium", FONTSIZE)
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


//定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

//数据验证
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])


//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)





//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define PW_DBNAME_INFORMATION @"information.sqlite"
#define PW_DB_INFORMATION_TABLE_NAME @"information"

#endif /* define_h */
