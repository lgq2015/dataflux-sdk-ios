//
//  FTMobileConfig.h
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2019/12/6.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum FTError : NSInteger {
  NetWorkException = 101,        //网络问题
  InvalidParamsException = 102,  //参数问题
  FileIOException = 103,         //文件 IO 问题
  UnknownException = 104,        //未知问题
} FTError;

/**
 * @enum
 * AutoTrack 抓取信息
 *
 * @constant
 *   FTAutoTrackEventTypeAppLaunch      - 项目启动
 *   FTAutoTrackEventTypeAppClick       - 点击事件
 *   FTAutoTrackEventTypeAppViewScreen  - 页面的生命周期 open/close
 */
typedef NS_OPTIONS(NSInteger, FTAutoTrackEventType) {
    FTAutoTrackTypeNone          = 0,
    FTAutoTrackEventTypeAppLaunch     = 1 << 0,
    FTAutoTrackEventTypeAppClick      = 1 << 1,
    FTAutoTrackEventTypeAppViewScreen = 1 << 2,
};
/**
 * @enum  TAG 中的设备信息
 *
 * @constant
 *   FTMonitorInfoTypeBattery  - 电池总量、使用量
 *   FTMonitorInfoTypeMemory   - 内存总量、使用率
 *   FTMonitorInfoTypeCpu      - CPU型号、占用率
 *   FTMonitorInfoTypeCpu      - GPU型号、占用率
 *   FTMonitorInfoTypeNetwork  - 网络的信号强度、网络速度、类型、代理
 *   FTMonitorInfoTypeCamera   - 前置/后置 像素
 *   FTMonitorInfoTypeLocation - 位置信息  国家、省、市、经纬度
 *   FTMonitorInfoTypeSystem   - 开机时间、设备名
 *   FTMonitorInfoTypeSensor   - 屏幕亮度
 *   FTMonitorInfoTypeBluetooth- 蓝牙对外显示名称
 */
typedef NS_OPTIONS(NSInteger, FTMonitorInfoType) {
    FTMonitorInfoTypeAll          = 1 << 0,
    FTMonitorInfoTypeBattery      = 1 << 1,
    FTMonitorInfoTypeMemory       = 1 << 2,
    FTMonitorInfoTypeCpu          = 1 << 3,
    FTMonitorInfoTypeGpu          = 1 << 4,
    FTMonitorInfoTypeNetwork      = 1 << 5,
    FTMonitorInfoTypeCamera       = 1 << 6,
    FTMonitorInfoTypeLocation     = 1 << 7,
    FTMonitorInfoTypeSystem       = 1 << 8,
    FTMonitorInfoTypeSensor       = 1 << 9,
    FTMonitorInfoTypeBluetooth    = 1 << 10,
};
NS_ASSUME_NONNULL_BEGIN

@interface FTMobileConfig : NSObject
/**
 * @method 指定初始化方法，设置 metricsUrl
 * @param metricsUrl FT-GateWay metrics 写入地址
 * @param akId       access key ID
 * @param akSecret   access key Secret
 * @param enableRequestSigning 配置是否需要进行请求签名 为YES 时akId与akSecret 不能为空
 * @return 配置对象
 */
- (instancetype)initWithMetricsUrl:(nonnull NSString *)metricsUrl akId:(nullable NSString *)akId akSecret:(nullable NSString *)akSecret enableRequestSigning:(BOOL)enableRequestSigning;
/**
 * @method 指定初始化方法，设置 metricsUrl 配置是否不需要进行请求签名
 * @param metricsUrl FT-GateWay metrics 写入地址
 * @return 配置对象
 */
- (instancetype)initWithMetricsUrl:(nonnull NSString *)metricsUrl;

/// 禁用 init 初始化
- (instancetype)init NS_UNAVAILABLE;

/// 禁用 new 初始化
+ (instancetype)new NS_UNAVAILABLE;
#pragma mark ========== 基本设置 ==========
/* SDK版本 */
@property (nonatomic, copy) NSString *sdkAgentVersion;
/* SDK版本 */
@property (nonatomic, copy) NSString *sdkTrackVersion;

/*应用名称（默认：info.plist中的CFBundleDisplayName）*/
@property (nonatomic ,copy) NSString *appName;

/*FT-GateWay metrics 写入地址*/
@property (nonatomic, copy) NSString *metricsUrl;

/*配置是否需要进行请求签名*/
@property (nonatomic, assign) BOOL enableRequestSigning;

/*access key ID*/
@property (nonatomic, copy) NSString *akId;

/*access key Secret*/
@property (nonatomic, copy) NSString *akSecret;

/*设置是否允许打印日志*/
@property (nonatomic, assign) BOOL enableLog;

/*TAG 中的设备信息*/
@property (nonatomic) FTMonitorInfoType monitorInfoType;

/*是否开启绑定用户数据*/
@property (nonatomic, assign) BOOL needBindUser;

/*请求HTTP请求头X-Datakit-UUID 数据采集端  如果用户不设置会自动配置 */
@property (nonatomic, copy) NSString *XDataKitUUID;

#pragma mark ==========  FTAutoTrack 全埋点配置 ==========
/**
 * 默认为NO   开启需要使用 FTAutoTrackSDK  总开关
 */
@property (nonatomic) BOOL enableAutoTrack;
/**
 * @property
 *
 * @abstract
 * 打开 SDK 设置追踪事件类型, 默认只追踪 App 启动 / 关闭、进入页面、元素点击
 *
 * @discussion
 * 该功能自动追踪 App 的一些行为，例如 SDK 初始化、App 启动 / 关闭、进入页面 等等，具体信息请参考文档:
 * 该功能默认关闭   开启需要使用 FTAutoTrackSDK 且 enableAutoTrack = YES
 */
@property (nonatomic) FTAutoTrackEventType autoTrackEventType;

/**
 * @abstract
 *  抓取某一类型的 View
 *  与 黑名单  二选一使用  若都没有则为全抓取
 *  eg: @[UITableView.class];
 */
@property (nonatomic,strong) NSArray<Class> *whiteViewClass;
/**
 * @abstract
 *  忽略某一类型的 View
 *  与 白名单  二选一使用  若都没有则为全抓取
 */
@property (nonatomic,strong) NSArray<Class> *blackViewClass;

/**
 *  抓取界面（实例对象数组）  白名单 与 黑名单 二选一使用  若都没有则为全抓取
 * eg: @[@"HomeViewController"];  字符串类型
 */
@property (nonatomic,strong) NSArray *whiteVCList;
/**
 *  抓取界面（实例对象数组）  黑名单 与白名单  二选一使用  若都没有则为全抓取
 */
@property (nonatomic,strong) NSArray *blackVCList;
#pragma mark ========== 上报流程图 ==========
/**
 * @abstract
 *  设置是否抓取页面流程图
 */
- (void)enableTrackScreenFlow:(BOOL)enable;
/**
 * @abstract
 *  设置上报流程行为指标集名
 */
- (void)setTrackViewFlowProduct:(NSString *)product;

/*设置是否需要视图跳转流程图*/
@property (nonatomic, assign) BOOL enableScreenFlow;
/**
 * @abstract
 * 上报流程行为指标集名称 设置 enableScreenFlow = YES; 时 product 不能为空。
 * 命名只能包含英文字母、数字、中划线和下划线，区分大小写
*/
@property (nonatomic, copy) NSString *product;

#pragma mark ========== Monitor 相关设置==========
/**
 * @property
 *
 * @abstract
 * 是否开启监控项定时上传 默认NO
*/
@property (nonatomic, assign) BOOL enableMonitorFlush;

/**
 * @property
 *
 * @abstract
 * 两次数据发送的最小时间间隔，单位毫秒
 *
 * @discussion
 * 默认值为 10 * 1000 毫秒
 * 上传判断条件：
 * 1. 是否 WIFI/3G/4G 网络
 * 2. 与上次发送的时间间隔是否大于 flushInterval
 * 如果满足这两个条件之一，则向服务器发送一次数据；如果都不满足，则把数据加入到队列中，等待下次检查时把整个队列的内容一并发送。
*/
@property (nonatomic) NSInteger flushInterval;
@end

NS_ASSUME_NONNULL_END
