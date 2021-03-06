//
//  SecondViewController.m
//  RuntimDemo
//
//  Created by 胡蕾蕾 on 2019/11/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ResultVC.h"
#import "AppDelegate.h"
#import <FTMobileAgent/FTMobileAgent.h>
#import <FTMobileAgent/FTDataBase/FTTrackerEventDBTool.h>
#import "UITestManger.h"

@interface ResultVC ()
@property (nonatomic ,strong) FTMobileConfig *config;

@property (nonatomic, strong) UILabel *lable;
@end

@implementation ResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Result";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.config = appDelegate.config;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createUI];
}
- (void)createUI{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, 350, 250)];
    lable.backgroundColor = [UIColor whiteColor];
    lable.textColor = [UIColor blackColor];
    lable.numberOfLines = 0;
    lable.text = [NSString stringWithFormat:@"数据库原有数据 %ld 条\n 数据库增加：\nlunch:%ld\nopen、close：%ld \nclick:%ld \n数据库现有数据： %ld 条 \n",[UITestManger sharedManger].lastCount,[UITestManger sharedManger].trackCount,[UITestManger sharedManger].autoTrackViewScreenCount,[UITestManger sharedManger].autoTrackClickCount,[[FTTrackerEventDBTool sharedManger] getDatasCountWithOp:@"metrics"]];
    
    self.lable = lable;
    [self.view addSubview:lable];
    dispatch_queue_t queue = dispatch_queue_create("net.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(queue, ^{
            NSInteger count = [self getUploadInfo];
            [self judjeSuccessWithCount:count];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 追加在主线程中执行的任务
                self.lable.text = [NSString stringWithFormat:@"数据库原有数据 %ld 条\n 数据库增加：\nlunch:%ld\nopen、close：%ld \nclick:%ld \n数据库现有数据： %ld 条 \n上传：%ld条",[UITestManger sharedManger].lastCount,[UITestManger sharedManger].trackCount,[UITestManger sharedManger].autoTrackViewScreenCount,[UITestManger sharedManger].autoTrackClickCount,[[FTTrackerEventDBTool sharedManger] getDatasCountWithOp:@"metrics"],(long)count];
            });
        });
    });
}

-(void)judjeSuccessWithCount:(NSInteger)count{
  
    
    
}
-(NSString *)login{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *account =[processInfo environment][@"FTTestAccount"];
    NSString *password = [processInfo environment][@"FTTestPassword"];
    if (account.length>0 && password.length>0) {
        NSLog(@"account:%@,password:%@",account,password);
    }else{
        return @"";
    }
    NSURL *url = [NSURL URLWithString:@"http://testing.api-ft2x.cloudcare.cn:10531/api/v1/auth-token/login"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
    mutableRequest.HTTPMethod = @"POST";
    //添加header
    [mutableRequest addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求参数
    [mutableRequest setValue:@"zh-CN" forHTTPHeaderField:@"Accept-Language"];
    NSDictionary *param = @{
        @"username": account,
        @"password": password,
        @"workspaceUUID": [NSString stringWithFormat:@"wksp_%@",[[NSUUID UUID] UUIDString]],
    };
    NSData* data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [mutableRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    
    request = [mutableRequest copy];
    __block NSString *token = @"";
    
    //设置请求session
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    //设置网络请求的返回接收器
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                
            }else{
                NSError *errors;
                NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errors];
                
                if (!errors){
                    NSDictionary *content = [responseObject valueForKey:@"content"];
                    token = [content valueForKey:@"token"];
                }
            }
            dispatch_group_leave(group);
        });
        
    }];
    //开始请求
    [dataTask resume];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return token;
}
-(NSInteger)getUploadInfo{
    NSString *token = [self login];
    NSURL *url = [NSURL URLWithString:@"http://testing.api-ft2x.cloudcare.cn:10531/api/v1/influx/query_data"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //设置请求地址
    //添加header
    NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
    mutableRequest.HTTPMethod = @"POST";
    //添加header
    [mutableRequest addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求参数
    [mutableRequest setValue:token forHTTPHeaderField:@"X-FT-Auth-Token"];
    [mutableRequest setValue:@"zh-CN" forHTTPHeaderField:@"Accept-Language"];
    NSDictionary *param = [self getParams];
    NSData* data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [mutableRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    request = [mutableRequest copy];        //拷贝回去
    __block NSInteger count = 0;
    
    //设置请求session
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    //设置网络请求的返回接收器
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                
            }else{
                NSError *errors;
                NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errors];
                
                if (!errors){
                    NSDictionary *content= [responseObject valueForKey:@"content"];
                    NSArray *data = [content valueForKey:@"data"];
                    NSArray *series = [[data firstObject] valueForKey:@"Series"];
                    if (![series isKindOfClass:[NSNull class]] && ![series isEqual:[NSNull null]]) {
                        NSArray *values = [[series firstObject] valueForKey:@"values"];
                        
                        count = values.count;
                    }
                }
            }
            dispatch_group_leave(group);
        });
        
    }];
    //开始请求
    [dataTask resume];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return count;
    
}
-(NSDictionary *)getParams{
    NSDictionary *param = @{@"qtype":@"http",
                            @"query":@{@"filter":@{@"tags":@[@{@"name":@"application_identifier",
                                                               @"condition":@"",
                                                               @"operation":@"=",
                                                               @"value":@"HLL.ft-sdk-iosTest",
                            }],
                                                   @"time":[self getTime],
                            },
                                       @"measurements":@[@"mobile_tracker"],
                                       @"tz":@"Asia/Shanghai",
                                       @"orderBy":@[@{@"name":@"time",
                                                      @"method":@"desc"}],
                                       @"offset":@0,
                                       @"limit":@1000,
                                       @"fields":@[@{@"name":@"event"}],
                                       
                            },
    };
    
    return param;
}
-(NSArray *)getTime{
    NSDate *datenow = [NSDate date];
    long  time= (long)([datenow timeIntervalSince1970]*1000);
    return @[[NSNumber numberWithLong:time-(1000 * 60 * 2)],[NSNumber numberWithLong:time]];
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
